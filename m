Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZFYRA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZFYRA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZFYRAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:00:17 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36952 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366AbZFYRAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:00:16 -0400
Subject: Re: kmemleak false positive?
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090625154014.GA7866@redhat.com>
References: <20090625001137.GB22755@redhat.com>
	 <1245921918.26218.19.camel@pc1117.cambridge.arm.com>
	 <20090625145600.GA6654@redhat.com>
	 <1245943539.26218.70.camel@pc1117.cambridge.arm.com>
	 <20090625154014.GA7866@redhat.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 25 Jun 2009 18:00:02 +0100
Message-Id: <1245949202.26218.88.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 17:00:03.0609 (UTC) FILETIME=[62231890:01C9F5B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 11:40 -0400, Dave Jones wrote:
> Here's another case (with stack scanning on btw) which looks odd..
> 
>  kmemleak: unreferenced object 0xd86ba000 (size 16):
>  kmemleak:   comm "init", pid 1, jiffies 4294683556
>  kmemleak:   backtrace:
>  kmemleak:     [<c04fd8b3>] kmemleak_alloc+0x193/0x2b8
>  kmemleak:     [<c04f5e73>] kmem_cache_alloc+0x11e/0x174
>  kmemleak:     [<c05cdfdc>] avtab_insertf+0xd6/0x140
>  kmemleak:     [<c05ce3d7>] avtab_read_item+0x26a/0x284
>  kmemleak:     [<c05ce5a5>] avtab_read+0x82/0xe5
>  kmemleak:     [<c05d0618>] policydb_read+0x40c/0x1028
>  kmemleak:     [<c05d459d>] security_load_policy+0x57/0x37c
>  kmemleak:     [<c05c9995>] sel_write_load+0xb2/0x54a
>  kmemleak:     [<c0500186>] vfs_write+0x9f/0x10f
>  kmemleak:     [<c05002e1>] sys_write+0x58/0x8d
>  kmemleak:     [<c040a8eb>] sysenter_do_call+0x12/0x38
>  kmemleak:     [<ffffffff>] 0xffffffff
> 
> I looked over the SELinux code, and couldn't see an obvious leak.
> Eric Paris came to the same conclusion.

How long does a memory scanning take (i.e. time cat debug/kmemleak) on
your platform? Another tweak is to increase MSECS_MIN_AGE to something
like 1 minute or more. Especially on SMP, some newly allocated objects
may be in registers and reported as leaks.

I'll have a look at the initial colour assigned to newly allocated
objects. Currently the objects allocated during a scan have no colour so
that they are not reported. However, they are not scanned either so
other object pointers allocated before the scan started may be stored in
those new objects.

-- 
Catalin

