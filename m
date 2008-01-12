Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbYALSJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbYALSJy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 13:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYALSJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 13:09:43 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:52215 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754317AbYALSJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 13:09:42 -0500
From: Sripathi Kodi <sripathik@in.ibm.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [PATCH PREEMPT_RT] Compilation fix for PPC
Date: Sat, 12 Jan 2008 23:39:48 +0530
User-Agent: KMail/1.9.4
Cc: Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801122339.48479.sripathik@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.24-rc5-rt1 won't compile on PPC if CONFIG_SMP is turned off. 

  CC      arch/powerpc/kernel/pmc.o
In file included from include/asm/tlb.h:62,
                 from arch/powerpc/mm/mem.c:44:
include/asm-generic/tlb.h: In function ‘tlb_gather_mmu’:
include/asm-generic/tlb.h:58: error: implicit declaration of function ‘__get_cpu_lock’
include/asm-generic/tlb.h:58: error: ‘mmu_gathers’ undeclared (first use in this function)
include/asm-generic/tlb.h:58: error: (Each undeclared identifier is reported only once
include/asm-generic/tlb.h:58: error: for each function it appears in.)
include/asm-generic/tlb.h:58: error: invalid lvalue in unary ‘&’
include/asm-generic/tlb.h:58: warning: type defaults to ‘int’ in declaration of ‘type name’
include/asm-generic/tlb.h:58: error: invalid lvalue in unary ‘&’
include/asm-generic/tlb.h:58: error: invalid lvalue in unary ‘&’
include/asm-generic/tlb.h:58: warning: type defaults to ‘int’ in declaration of ‘type name’
include/asm-generic/tlb.h:58: error: invalid lvalue in unary ‘&’
include/asm-generic/tlb.h:58: error: implicit declaration of function ‘__get_cpu_var_locked’
include/asm-generic/tlb.h:58: error: invalid lvalue in unary ‘&’
include/asm-generic/tlb.h: In function ‘tlb_finish_mmu’:
include/asm-generic/tlb.h:96: error: ‘mmu_gathers’ undeclared (first use in this function)
include/asm-generic/tlb.h:96: error: invalid lvalue in unary ‘&’
include/asm-generic/tlb.h:96: warning: type defaults to ‘int’ in declaration of ‘type name’
include/asm-generic/tlb.h:96: error: invalid lvalue in unary ‘&’
include/asm-generic/tlb.h:96: error: invalid lvalue in unary ‘&’
include/asm-generic/tlb.h:96: warning: type defaults to ‘int’ in declaration of ‘type name’
include/asm-generic/tlb.h:96: error: invalid lvalue in unary ‘&’

The patch below fixes it.

Thanks,
Sripathi.

Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>

diff -uprN linux-2.6.24-rc5-rt1_org/include/asm-powerpc/percpu.h linux-2.6.24-rc5-rt1/include/asm-powerpc/percpu.h
--- linux-2.6.24-rc5-rt1_org/include/asm-powerpc/percpu.h	2008-01-12 17:43:03.000000000 +0530
+++ linux-2.6.24-rc5-rt1/include/asm-powerpc/percpu.h	2008-01-12 17:43:58.000000000 +0530
@@ -68,6 +68,8 @@ extern void setup_per_cpu_areas(void);
 
 #define __get_cpu_var(var)			per_cpu__##var
 #define __raw_get_cpu_var(var)			per_cpu__##var
+#define __get_cpu_lock(var, cpu)		per_cpu_lock__##var##_locked
+#define __get_cpu_var_locked(var, cpu)		per_cpu__##var##_locked
 
 #endif	/* SMP */
 
