Return-Path: <linux-kernel-owner+w=401wt.eu-S934072AbZARQkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072AbZARQkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZARQjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:55187 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZARQjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:32 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Subject: [PATCHSET x86:core/percpu] percpu: move PDA fields to percpu
Date: Mon, 19 Jan 2009 01:39:07 +0900
Message-Id: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello, Brian, Ingo.

This patchset is 1-12 of Brian's move PDA fields to percpu patchset.

 0001-x86-64-Move-irq-stats-from-PDA-to-per-cpu-and-conso.patch
 0002-x86-64-Move-TLB-state-from-PDA-to-per-cpu-and-conso.patch
 0003-x86-64-Convert-irqstacks-to-per-cpu.patch
 0004-x86-64-Convert-exception-stacks-to-per-cpu.patch
 0005-x86-64-Move-cpu-number-from-PDA-to-per-cpu-and-cons.patch
 0006-x86-64-Move-current-task-from-PDA-to-per-cpu-and-co.patch
 0007-x86-64-Move-kernelstack-from-PDA-to-per-cpu.patch
 0008-x86-64-Move-oldrsp-from-PDA-to-per-cpu.patch
 0009-x86-64-Move-irqcount-from-PDA-to-per-cpu.patch
 0010-x86-64-Move-nodenumber-from-PDA-to-per-cpu.patch
 0011-x86-64-Move-isidle-from-PDA-to-per-cpu.patch
 0012-x86-64-Use-absolute-displacements-for-per-cpu-acces.patch

with the following changes

* Add underbars between words in variable names (e.g. irqstack ->
  irq_stack)

* Drop irq_stack_ptr early initialization on SMP from 0003.

* Change DECLARE/DEFINE_PER_CPU(char, irq_stack[IRQ_STACK_SIZE]) to
  DECLARE/DEFINE_PER_CPU(char[IRQ_STACK_SIZE], irq_stack) in 0003.
         
* Move cpu_number definition out of CONFIG_HAVE_SETUP_PER_CPU_AREA
  in 0005.

* Remove now unused stack_thread_info() in 0007.

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

diffstat follows.

 arch/x86/ia32/ia32entry.S             |    8 +--
 arch/x86/include/asm/current.h        |   24 +----------
 arch/x86/include/asm/hardirq_64.h     |   24 +++++++++--
 arch/x86/include/asm/mmu_context_64.h |   16 +++----
 arch/x86/include/asm/page_64.h        |    4 -
 arch/x86/include/asm/pda.h            |   29 ++-----------
 arch/x86/include/asm/percpu.h         |   26 ++++++------
 arch/x86/include/asm/processor.h      |    3 +
 arch/x86/include/asm/smp.h            |    4 -
 arch/x86/include/asm/system.h         |    4 -
 arch/x86/include/asm/thread_info.h    |   20 +++------
 arch/x86/include/asm/tlbflush.h       |    7 ---
 arch/x86/include/asm/topology.h       |    3 -
 arch/x86/kernel/asm-offsets_64.c      |    6 --
 arch/x86/kernel/cpu/common.c          |   71 ++++++++++++----------------------
 arch/x86/kernel/dumpstack_64.c        |   35 ++++++++--------
 arch/x86/kernel/entry_64.S            |   34 ++++++++--------
 arch/x86/kernel/irq.c                 |    6 --
 arch/x86/kernel/irq_64.c              |    3 +
 arch/x86/kernel/nmi.c                 |   10 ----
 arch/x86/kernel/process_32.c          |    3 -
 arch/x86/kernel/process_64.c          |   22 ++++++----
 arch/x86/kernel/setup_percpu.c        |   18 +++++++-
 arch/x86/kernel/smpboot.c             |    6 +-
 arch/x86/kernel/smpcommon.c           |    2 
 arch/x86/kernel/tlb_32.c              |   12 -----
 arch/x86/kernel/tlb_64.c              |   13 +++---
 arch/x86/xen/mmu.c                    |    6 --
 arch/x86/xen/smp.c                    |   21 +---------
 arch/x86/xen/xen-asm_64.S             |   31 +++++++-------
 30 files changed, 203 insertions(+), 268 deletions(-)

--
tejun
