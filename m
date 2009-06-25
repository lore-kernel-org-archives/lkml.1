Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZFYO4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZFYO4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZFYO4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:56:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52486 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbZFYO4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:56:12 -0400
Date: Thu, 25 Jun 2009 10:56:01 -0400
From: Dave Jones <davej@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kmemleak false positive?
Message-ID: <20090625145600.GA6654@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20090625001137.GB22755@redhat.com> <1245921918.26218.19.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245921918.26218.19.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 10:25:17AM +0100, Catalin Marinas wrote:

 > > kmemleak:   backtrace:
 > > kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
 > > kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
 > > kmemleak:     [<c0aae5a7>] debug_objects_mem_init+0x63/0x1d9
 > > kmemleak:     [<c0a86a62>] start_kernel+0x2da/0x38d
 > > kmemleak:     [<c0a86090>] i386_start_kernel+0x7f/0x98
 > > kmemleak:     [<ffffffff>] 0xffffffff
 > 
 > It could be a false positive. Do you get some "kmemleak: referenced"
 > messages as well at a later time? In this case, it is just transient
 > "leak", caused maybe by pointers stored on the stack or registers.

Yes, some time later.

 > Is the obj_pool in lib/debugobjects.c supposed to be empty at the end of
 > the test and all objects freed? The obj_pool is a list and the first
 > elements in this list are from obj_static_pool, which is __initdata.
 > Objects added to the list may be referred by chaining with the
 > obj_static_pool objects but kmemleak doesn't scan __initdata as this is
 > usually freed before kmemleak does its first scan. So, if it is just a
 > transient "leak", kmemleak should later report "kmemleak: referenced" if
 > a kmem_cache_free() is called on any of the reported objects.

Hmm, it's pretty noisy, and everything it's found so far looks to be
a false positive.

 > You can mount debugfs on /sys/kerne/debug and read the kmemleak file in
 > there (it triggers a new scan as well).

Currently prints the acpi traces I already posted.

 > You can also echo stack=on to
 > the above kmemleak file to enable kernel stack scanning.
 > 
 > Could you send me your config options for DEBUG_OBJECTS_* and slab
 > allocator so I can try to reproduce this?
 
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1

	Dave

