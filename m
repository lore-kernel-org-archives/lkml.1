Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYLSRFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYLSRFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYLSRFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:05:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLSRFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:05:36 -0500
Subject: [PATCH] x86: common.c boot_cpu_stack and boot_exception_stacks
	should be static
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 22:33:52 +0530
Message-Id: <1229706232.7625.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid sparse warnings, reduce kernel size a bit

Fixes these sparse warnings:
arch/x86/kernel/cpu/common.c:869:6: warning: symbol 'boot_cpu_stack' was not declared. Should it be static?
arch/x86/kernel/cpu/common.c:910:6: warning: symbol 'boot_exception_stacks' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/cpu/common.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cd7437c..e57a725 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -866,7 +866,7 @@ EXPORT_SYMBOL(_cpu_pda);
 
 struct desc_ptr idt_descr = { 256 * 16 - 1, (unsigned long) idt_table };
 
-char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
+static char boot_cpu_stack[IRQSTACKSIZE] __page_aligned_bss;
 
 void __cpuinit pda_init(int cpu)
 {
@@ -907,8 +907,8 @@ void __cpuinit pda_init(int cpu)
 	}
 }
 
-char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
-			   DEBUG_STKSZ] __page_aligned_bss;
+static char boot_exception_stacks[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ +
+				  DEBUG_STKSZ] __page_aligned_bss;
 
 extern asmlinkage void ignore_sysret(void);
 
-- 
1.5.5.1



