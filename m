Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYIEDLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYIEDLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYIEDJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:58345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYIEDJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SdnLcVhVe83c8quQE5FZa35iCFcXmIcb3x1hl4tpNtiDPWlM20ycAvuzVRiLsEYNfP
         bU1lwH3KE12ILDJnD4cy9Zvv0SyW4eLGa9nrUDe7P2lg01ACnswHiStYhzBRBu8MO4ze
         /HhP1F0Jf5YNxBZhVQphS514LtGO7mEZym8AA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 07/16] x86: cpu common merge switch_to_new_gdt
Date: Thu,  4 Sep 2008 20:09:05 -0700
Message-Id: <1220584154-32497-7-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |    2 ++
 arch/x86/kernel/cpu/common_64.c |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f44678d..43d5287 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -215,7 +215,9 @@ void switch_to_new_gdt(void)
 	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
+#ifdef CONFIG_X86_32
 	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
+#endif
 }
 
 static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 2bd0ed5..d7b9965 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -214,6 +214,9 @@ void switch_to_new_gdt(void)
 	gdt_descr.address = (long)get_cpu_gdt_table(smp_processor_id());
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
+#ifdef CONFIG_X86_32
+	asm("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
+#endif
 }
 
 static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
-- 
1.5.4.5

