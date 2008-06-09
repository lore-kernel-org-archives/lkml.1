Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbYFIOTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbYFIOTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbYFIOSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:18:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbYFIOSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:18:31 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 03/15] x86: remove early_gdt_descr reference
Date: Mon,  9 Jun 2008 11:16:46 -0300
Message-Id: <1213021018-14159-4-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213021018-14159-3-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since we use switch_to_new_gdt, there is no point
in assigning early_gdt_descr except for the first
assignment, which is done manually.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/kernel/smpboot.c           |    1 -
 arch/x86/mach-voyager/voyager_smp.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c77a7d2..181b109 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -898,7 +898,6 @@ do_rest:
 #ifdef CONFIG_X86_32
 	per_cpu(current_task, cpu) = c_idle.idle;
 	init_gdt(cpu);
-	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	c_idle.idle->thread.ip = (unsigned long) start_secondary;
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	irq_ctx_init(cpu);
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 8dedd01..6b97d9b 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -529,7 +529,6 @@ static void __init do_boot_cpu(__u8 cpu)
 
 	init_gdt(cpu);
 	per_cpu(current_task, cpu) = idle;
-	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
 	irq_ctx_init(cpu);
 
 	/* Note: Don't modify initial ss override */
-- 
1.5.4.5

