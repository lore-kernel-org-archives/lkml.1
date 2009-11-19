Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbZKSXMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbZKSXMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 18:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbZKSXMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 18:12:17 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49010 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754073AbZKSXMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 18:12:16 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: sgi uv BAU initialization
Cc: mingo@elte.hu
Message-Id: <E1NBGB9-0005nU-Dp@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 19 Nov 2009 17:12:43 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

A memory mapped register that affects the SGI UV Broadcast Assist Unit's
interrupt handling may sometimes be unintialized.

Remove the condition on its initialization, as that condition can be
randomly satisfied by a hardware reset.

Diffed against 2.6.32-rc7

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/tlb_uv.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: 091119.linux/arch/x86/kernel/tlb_uv.c
===================================================================
--- 091119.linux.orig/arch/x86/kernel/tlb_uv.c
+++ 091119.linux/arch/x86/kernel/tlb_uv.c
@@ -817,10 +817,8 @@ static int __init uv_init_blade(int blad
 	 */
 	apicid = blade_to_first_apicid(blade);
 	pa = uv_read_global_mmr64(pnode, UVH_BAU_DATA_CONFIG);
-	if ((pa & 0xff) != UV_BAU_MESSAGE) {
-		uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
+	uv_write_global_mmr64(pnode, UVH_BAU_DATA_CONFIG,
 				      ((apicid << 32) | UV_BAU_MESSAGE));
-	}
 	return 0;
 }
 
