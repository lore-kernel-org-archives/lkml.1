Return-Path: <linux-kernel-owner+w=401wt.eu-S1030232AbXBTQcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030232AbXBTQcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030234AbXBTQcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:32:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030232AbXBTQcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:32:16 -0500
Date: Tue, 20 Feb 2007 11:32:09 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-mm@kvack.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070220163209.23777.90564.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: remove __initdata from initkmem_list3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove __initdata from initkmem_list3

Resolves MODPOST warning similar to:

WARNING: vmlinux - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0xc046a3ed) and 's_start'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/mm/slab.c b/mm/slab.c
index 70784b8..d97f252 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -305,7 +305,7 @@ struct kmem_list3 {
  * Need this for bootstrapping a per node allocator.
  */
 #define NUM_INIT_LISTS (2 * MAX_NUMNODES + 1)
-struct kmem_list3 __initdata initkmem_list3[NUM_INIT_LISTS];
+struct kmem_list3 initkmem_list3[NUM_INIT_LISTS];
 #define	CACHE_CACHE 0
 #define	SIZE_AC 1
 #define	SIZE_L3 (1 + MAX_NUMNODES)
