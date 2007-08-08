Return-Path: <linux-kernel-owner+w=401wt.eu-S1760029AbXHHHIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029AbXHHHIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbXHHHHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:07:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbXHHHHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:07:33 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org
Subject: Introducing paravirt_ops for x86_64
Date: Wed,  8 Aug 2007 01:18:47 -0300
Message-Id: <11865467522495-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

After some time away from it, and a big rebase as a consequence, here is
the updated version of paravirt_ops for x86_64, heading to inclusion.

Your criticism is of course, very welcome. 

Have fun
--
 arch/x86_64/Kconfig              |   11 
 arch/x86_64/ia32/syscall32.c     |    2 
 arch/x86_64/kernel/Makefile      |    1 
 arch/x86_64/kernel/apic.c        |    2 
 arch/x86_64/kernel/asm-offsets.c |   14 
 arch/x86_64/kernel/entry.S       |  125 +++--
 arch/x86_64/kernel/head.S        |   10 
 arch/x86_64/kernel/head64.c      |    2 
 arch/x86_64/kernel/i8259.c       |   15 
 arch/x86_64/kernel/ldt.c         |    6 
 arch/x86_64/kernel/paravirt.c    |  455 +++++++++++++++++++
 arch/x86_64/kernel/process.c     |    2 
 arch/x86_64/kernel/reboot.c      |    3 
 arch/x86_64/kernel/setup.c       |   41 +
 arch/x86_64/kernel/setup64.c     |   18 
 arch/x86_64/kernel/smp.c         |   10 
 arch/x86_64/kernel/smpboot.c     |   10 
 arch/x86_64/kernel/suspend.c     |   11 
 arch/x86_64/kernel/tce.c         |    2 
 arch/x86_64/kernel/time.c        |   37 +
 arch/x86_64/kernel/traps.c       |    1 
 arch/x86_64/kernel/tsc.c         |   42 +
 arch/x86_64/kernel/vmlinux.lds.S |    6 
 arch/x86_64/kernel/vsyscall.c    |    4 
 arch/x86_64/kernel/x8664_ksyms.c |    6 
 arch/x86_64/mm/pageattr.c        |    2 
 arch/x86_64/vdso/vgetcpu.c       |    4 
 include/asm-x86_64/alternative.h |    8 
 include/asm-x86_64/apic.h        |   13 
 include/asm-x86_64/desc.h        |  183 +++++--
 include/asm-x86_64/e820.h        |    6 
 include/asm-x86_64/irq.h         |    2 
 include/asm-x86_64/irqflags.h    |   32 +
 include/asm-x86_64/mmu_context.h |   23 
 include/asm-x86_64/msr.h         |  284 +++++++-----
 include/asm-x86_64/page.h        |   36 +
 include/asm-x86_64/paravirt.h    |  901 +++++++++++++++++++++++++++++++++++++++
 include/asm-x86_64/pgalloc.h     |    7 
 include/asm-x86_64/pgtable.h     |  152 +++---
 include/asm-x86_64/processor.h   |   71 ++-
 include/asm-x86_64/proto.h       |    3 
 include/asm-x86_64/segment.h     |    4 
 include/asm-x86_64/smp.h         |    8 
 include/asm-x86_64/spinlock.h    |   16 
 include/asm-x86_64/tlbflush.h    |   22 
 include/linux/mm.h               |   14 
 46 files changed, 2271 insertions(+), 356 deletions(-)

