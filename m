Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbYD2OiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbYD2OiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbYD2Ohf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:37:35 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49706 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbYD2Ohe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:37:34 -0400
Message-Id: <20080429143728.563232000@bull.net>
References: <20080429143304.741001000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 29 Apr 2008 16:33:05 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 01/10] Fix idr_remove()
Content-Disposition: inline; filename=idr_minor_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 01/10]

This patch fixes idr_remove(): the return inside the loop makes us free only
a single layer.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/idr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.25-mm1/lib/idr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/idr.c	2008-04-25 15:29:00.000000000 +0200
+++ linux-2.6.25-mm1/lib/idr.c	2008-04-25 15:48:34.000000000 +0200
@@ -385,8 +385,8 @@ void idr_remove(struct idr *idp, int id)
 	while (idp->id_free_cnt >= IDR_FREE_MAX) {
 		p = alloc_layer(idp);
 		kmem_cache_free(idr_layer_cache, p);
-		return;
 	}
+	return;
 }
 EXPORT_SYMBOL(idr_remove);
 

--
