Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbYGHXeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbYGHXeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbYGHXPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:35 -0400
Received: from gw.goop.org ([64.81.55.164]:51204 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772AbYGHXOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 11 of 55] xen: define set_pte from the outset
X-Mercurial-Node: 553178d7d6b6cd5c384b3ba366cb5f0a47be6ece
Message-Id: <553178d7d6b6cd5c384b.1215554793@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need set_pte to work from a relatively early point, so enable it
from the start.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -845,9 +845,6 @@
 	pgd_t *xen_pgd = (pgd_t *)xen_start_info->pt_base;
 	int i;
 
-	/* special set_pte for pagetable initialization */
-	pv_mmu_ops.set_pte = xen_set_pte_init;
-
 	init_mm.pgd = base;
 	/*
 	 * copy top-level of Xen-supplied pagetable into place.  This
@@ -1174,7 +1171,7 @@
 	.kmap_atomic_pte = xen_kmap_atomic_pte,
 #endif
 
-	.set_pte = NULL,	/* see xen_pagetable_setup_* */
+	.set_pte = xen_set_pte_init,
 	.set_pte_at = xen_set_pte_at,
 	.set_pmd = xen_set_pmd_hyper,
 


