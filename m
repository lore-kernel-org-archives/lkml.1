Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbXJ2TwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbXJ2TwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXJ2Tvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:51:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56813 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750863AbXJ2Tvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:51:50 -0400
Date: Mon, 29 Oct 2007 12:51:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [stable] 2.6.23 boot failures on x86-64.
In-Reply-To: <alpine.LFD.0.999.0710291123200.30120@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710291247510.845@schroedinger.engr.sgi.com>
References: <20071029175014.GH7793@redhat.com> <20071029180739.GA17595@kroah.com>
 <alpine.LFD.0.999.0710291123200.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Linus Torvalds wrote:

> We've had some changes since 2.6.23, and afaik, the 
> "alloc_bootmem_high_node()" code is alreadt effectively dead there. It's 
> only called if CONFIG_SPARSEMEM_VMEMMAP is *not* enabled, and I *think* we 
> enable it by force on x86-64 these days.

CONFIG_SPARSEMEM_VMEMMAP was introduced in 2.6.24-rc1.

If I read this Kconfig.x86_64 correctly then it seems that DISCONTIG is 
still the default. Andy?

config ARCH_DISCONTIGMEM_ENABLE
       bool
       depends on NUMA
       default y

config ARCH_DISCONTIGMEM_DEFAULT
        def_bool y
        depends on NUMA

config ARCH_SPARSEMEM_ENABLE
        def_bool y
        depends on (NUMA || EXPERIMENTAL)
        select SPARSEMEM_VMEMMAP_ENABLE

config ARCH_MEMORY_PROBE
        def_bool y
        depends on MEMORY_HOTPLUG

config ARCH_FLATMEM_ENABLE
        def_bool y
        depends on !NUMA
