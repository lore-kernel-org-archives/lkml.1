Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXDJLFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXDJLFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 07:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbXDJLFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 07:05:00 -0400
Received: from ozlabs.org ([203.10.76.45]:42862 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbXDJLE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 07:04:59 -0400
Subject: [PATCH 0/8] lguest
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 21:04:28 +1000
Message-Id: <1176203068.26372.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As promised to Andrew, and with much thanks to Andi Kleen for feedback,
this is the new series of lguest patches.

Main change is the move to drivers/lguest (for future non-i386
expansion), but lots of cleanups driven by Andi's feedback and the
documentation effort (which made me examine every line of code).

It's not perfect, but it's definitely useful.

Cheers,
Rusty.

List of changes from the previous version in -mm:
- Updated to 2.6.21-rc6-mm1
- Moved to drivers/lguest
- Don't bother fflush()ing in verbose(): we always use a \n now anyway.
- Remove part of lguest.txt which documents the code: moving them to the
  code, is in progress.
- Move assembler parts of lguest.c out to lguest_asm.S.
- Use ktimer_get_real_ts() rather than do_gettimeofday.  It's the new
  black!
- Use explicit types (w/ typechecking) for shadow pagetable code.
- Use unsigned long for addresses rather than u32.
- Comment on wmb().
- Use mask-in, not mask-out on CPUID for more future proofiness.
- Implement noop wbinvd (used when cpuid says there's no clflush,
  ie. pre Pentium 4). (Discovered while playing with CPUID).
- Rename many internal shadow pagetable functions & vars for clarity.
- Remove cr3 member from "struct lguest": easy to calculate when needed.
- Add comment on lack of interface stability.
- Move lguest_devices array declaration from lguest.h to lguest_bus.h
  (it's only useful for devices).
- Use read_cr0() and write_cr0() rather than open-coding them.
- Use KERN_INFO on printk() for lguest initialization
- Remove unneeded __attribute_used__ in core.c
- Print out message when failing to run lguest under lguest/Xen etc.
- Use a wmb() for dma transfer code, not mb().
- Change hash table size from 64 to 61.
- Reorder can cleanup of example launcher code to make it suck less.
- s/hypervisor/switcher/ for more clarity.
- lguest_address_ok() now takes length to check.
- Rename GUEST_DPL to GUEST_PL: it's not just for descriptors.
- Wake other guest when it's out of buffers, don't just yield.
- Rename "addr" to "key" as I/O argument.
- Rename "interrupts" in "struct lguest_data" to "blocked_interrupts".
- Don't set regs fields to 0: allocated with get_zeroed_page() anyway.
- Various minor cleanups.






