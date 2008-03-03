Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbYCCROB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbYCCROB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYCCRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:13:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbYCCRNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:13:52 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH 0/52] First attempt at smp integration
Date: Mon,  3 Mar 2008 14:12:28 -0300
Message-Id: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches does a first attempt at smp integration (I call it first, 
although I don't believe it's too far away from a real one). The series comprises 52 patches,
and the full diffstat says in the end:

	 34 files changed, 1858 insertions(+), 2344 deletions(-)

smp_32.c and smp_64.c are completely gone. smp.h and smpboot_{32,64}.c are not, although
substantially reduced. I know that ideally, no leftovers are wanted, but the series were
already big enough (I tried to split the patches as much as I could), so I considered this 
a good cutting point. If this is all agreed upon and merged, I'll start looking at the other 
bits that are left.

All patches are tested is various random x86 subarchitectures, and all of them works.
The result also boots fine in mine x86_64 and i386 boxes.

Comments are welcome.

 arch/x86/kernel/Makefile               |   11 
 arch/x86/kernel/apic_32.c              |    7 
 arch/x86/kernel/smp_32.c               |  730 ---------------------------------
 arch/x86/kernel/smp_64.c               |  674 +++---------------------------
 arch/x86/kernel/smpboot.c              |  372 ++++++++++++++++
 arch/x86/kernel/smpboot_32.c           |  363 ----------------
 arch/x86/kernel/smpboot_64.c           |  432 -------------------
 arch/x86/mach-voyager/voyager_smp.c    |    3 
 b/arch/x86/kernel/Makefile             |    2 
 b/arch/x86/kernel/apic_32.c            |   74 +--
 b/arch/x86/kernel/ipi.c                |  178 ++++++++
 b/arch/x86/kernel/mpparse_32.c         |    7 
 b/arch/x86/kernel/mpparse_64.c         |    7 
 b/arch/x86/kernel/smp.c                |  253 +++++++++++
 b/arch/x86/kernel/smp_32.c             |    2 
 b/arch/x86/kernel/smp_64.c             |    2 
 b/arch/x86/kernel/smpboot.c            |   53 ++
 b/arch/x86/kernel/smpboot_32.c         |    6 
 b/arch/x86/kernel/smpboot_64.c         |    2 
 b/arch/x86/kernel/smpcommon.c          |   83 +++
 b/arch/x86/kernel/smpcommon_32.c       |   82 ---
 b/arch/x86/kernel/tlb_32.c             |  243 ++++++++++
 b/arch/x86/kernel/tlb_64.c             |  274 ++++++++++++
 b/arch/x86/mach-voyager/voyager_smp.c  |    9 
 b/include/asm-x86/processor.h          |   10 
 b/include/asm-x86/smp.h                |    8 
 b/include/asm-x86/smp_32.h             |    4 
 b/include/asm-x86/smp_64.h             |    5 
 include/asm-x86/processor.h            |    5 
 include/asm-x86/smp.h                  |   99 ++++
 include/asm-x86/smp_32.h               |   86 ---
 include/asm-x86/smp_64.h               |   21 
 linux-2.6-x86/arch/x86/kernel/Makefile |    4 
 linux-2.6-x86/arch/x86/kernel/smp.c    |   91 ++++
 34 files changed, 1858 insertions(+), 2344 deletions(-)


