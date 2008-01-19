Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbYASSQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbYASSQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 13:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYASSQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 13:16:47 -0500
Received: from kanga.kvack.org ([66.96.29.28]:58959 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYASSQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 13:16:46 -0500
Date: Sat, 19 Jan 2008 16:19:09 -0200
From: Marcelo Tosatti <marcelo@kvack.org>
To: mingo@elte.hu, gcosta@redhat.com
Cc: ehabkost@redhat.com, glommer@gmail.com, jeremy@goop.org, chrisw@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] fill in missing pv_mmu_ops entries for PAGETABLE_LEVELS >= 3
Message-ID: <20080119181909.GA4640@dmt>
References: <12006768251548-git-send-email-gcosta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12006768251548-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 03:20:15PM -0200, Glauber de Oliveira Costa wrote:
> Hi,
> 
> This small series provides some more fixes towards the goal
> to have the PARAVIRT selectable for x86_64. After that, just
> some more small steps are needed.
> 
> The first fix is not even specific for PARAVIRT, and it's actually
> preventing the whole tree from booting.
> 

And the following allows PARAVIRT kernels to boot on x86_64.

-----

Fill in missing pagetable manipulation entries in pv_mmu_ops 
for PAGETABLE_LEVELS >= 3.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>


Index: linux-2.6-x86/arch/x86/kernel/paravirt.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/paravirt.c
+++ linux-2.6-x86/arch/x86/kernel/paravirt.c
@@ -396,16 +396,25 @@ struct pv_mmu_ops pv_mmu_ops = {
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
+	.set_pgd = native_set_pgd,
+	.pgd_clear = native_pgd_clear,
 	.pmd_val = native_pmd_val,
 	.make_pmd = native_make_pmd,
+
+#if PAGETABLE_LEVELS == 4
+	.pud_val = native_pud_val,
+	.make_pud = native_make_pud,
+	.pud_clear = native_pud_clear,
 #endif
+#endif /* PAGETABLE_LEVELS >= 3 */
 
 	.pte_val = native_pte_val,
 	.pgd_val = native_pgd_val,



