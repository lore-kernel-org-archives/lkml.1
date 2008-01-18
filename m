Return-Path: <linux-kernel-owner+w=401wt.eu-S1765958AbYARUG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765958AbYARUG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763250AbYARUEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:04:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765500AbYARUEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:04:36 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 8/10] add asm_offset PARAVIRT constants
Date: Fri, 18 Jan 2008 15:20:23 -0200
Message-Id: <12006768732175-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <12006768683247-git-send-email-gcosta@redhat.com>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <1200676842822-git-send-email-gcosta@redhat.com> <12006768473571-git-send-email-gcosta@redhat.com> <12006768521391-git-send-email-gcosta@redhat.com> <1200676857691-git-send-email-gcosta@redhat.com> <12006768631010-git-send-email-gcosta@redhat.com> <12006768683247-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the constant PARAVIRT needs in asm_offsets_64.c

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/asm-offsets_64.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 2b32719..494e1e0 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -61,6 +61,20 @@ int main(void)
 	ENTRY(data_offset);
 	BLANK();
 #undef ENTRY
+#ifdef CONFIG_PARAVIRT
+	BLANK();
+	OFFSET(PARAVIRT_enabled, pv_info, paravirt_enabled);
+	OFFSET(PARAVIRT_PATCH_pv_cpu_ops, paravirt_patch_template, pv_cpu_ops);
+	OFFSET(PARAVIRT_PATCH_pv_irq_ops, paravirt_patch_template, pv_irq_ops);
+	OFFSET(PV_IRQ_irq_disable, pv_irq_ops, irq_disable);
+	OFFSET(PV_IRQ_irq_enable, pv_irq_ops, irq_enable);
+	OFFSET(PV_CPU_iret, pv_cpu_ops, iret);
+	OFFSET(PV_CPU_irq_enable_syscall_ret, pv_cpu_ops, irq_enable_syscall_ret);
+	OFFSET(PV_CPU_swapgs, pv_cpu_ops, swapgs);
+	OFFSET(PV_MMU_read_cr2, pv_mmu_ops, read_cr2);
+#endif
+
+
 #ifdef CONFIG_IA32_EMULATION
 #define ENTRY(entry) DEFINE(IA32_SIGCONTEXT_ ## entry, offsetof(struct sigcontext_ia32, entry))
 	ENTRY(ax);
-- 
1.4.4.2

