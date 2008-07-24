Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYGXPQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYGXPQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758777AbYGXPQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:16:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758701AbYGXPQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:16:29 -0400
From: Eduardo Habkost <ehabkost@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 1/2] Xen: Use native_pte_flags instead of native_pte_val for .pte_flags
Date: Thu, 24 Jul 2008 12:15:45 -0300
Message-Id: <1216912546-6971-1-git-send-email-ehabkost@redhat.com>
X-Mailer: git-send-email 1.5.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using native_pte_val triggers the BUG_ON() in the paravirt_ops
version of pte_flags().

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/xen/enlighten.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 3fc0c15..6b169b7 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1378,7 +1378,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
 
 	.pte_val = xen_pte_val,
-	.pte_flags = native_pte_val,
+	.pte_flags = native_pte_flags,
 	.pgd_val = xen_pgd_val,
 
 	.make_pte = xen_make_pte,
-- 
1.5.5.GIT

