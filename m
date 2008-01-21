Return-Path: <linux-kernel-owner+w=401wt.eu-S1758438AbYAUVyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbYAUVyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbYAUVxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:53:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338AbYAUVxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:53:18 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com
Subject: [PATCH 4/4] Fill in missing pv_mmu_ops entries for PAGETABLE_LEVELS >= 3
Date: Mon, 21 Jan 2008 19:48:53 -0200
Message-Id: <1200952133-31581-5-git-send-email-ehabkost@redhat.com>
X-Mailer: git-send-email 1.5.4.rc3
In-Reply-To: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This finally makes paravirt-ops able to compile and boot under x86_64.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/paravirt.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 37f38b7..075962c 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -398,16 +398,23 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.kmap_atomic_pte = kmap_atomic,
 #endif
 
+#if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.set_pte_present = native_set_pte_present,
-	.set_pud = native_set_pud,
 	.pte_clear = native_pte_clear,
 	.pmd_clear = native_pmd_clear,
-
+#endif
+	.set_pud = native_set_pud,
 	.pmd_val = native_pmd_val,
 	.make_pmd = native_make_pmd,
+
+#if PAGETABLE_LEVELS == 4
+	.pud_val = native_pud_val,
+	.make_pud = native_make_pud,
+	.set_pgd = native_set_pgd,
 #endif
+#endif /* PAGETABLE_LEVELS >= 3 */
 
 	.pte_val = native_pte_val,
 	.pgd_val = native_pgd_val,
-- 
1.5.3.4

