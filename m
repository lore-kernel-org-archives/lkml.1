Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYGHXP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYGHXP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYGHXOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:39 -0400
Received: from gw.goop.org ([64.81.55.164]:51200 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbYGHXOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 03 of 55] x86_64: there's no need to preallocate
	level1_fixmap_pgt
X-Mercurial-Node: a2dc660956f9dedbd81ee15f6e67e99a40919eb3
Message-Id: <a2dc660956f9dedbd81e.1215554785@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early fixmap will allocate its own L1 pagetable page for fixmap
mappings, so there's no need to preallocate one.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/head_64.S |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -362,12 +362,6 @@
 	.quad	level2_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
 
 NEXT_PAGE(level2_fixmap_pgt)
-	.fill	506,8,0
-	.quad	level1_fixmap_pgt - __START_KERNEL_map + _PAGE_TABLE
-	/* 8MB reserved for vsyscalls + a 2MB hole = 4 + 1 entries */
-	.fill	5,8,0
-
-NEXT_PAGE(level1_fixmap_pgt)
 	.fill	512,8,0
 
 NEXT_PAGE(level2_ident_pgt)


