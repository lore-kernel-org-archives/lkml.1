Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYEGLip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYEGLip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbYEGLiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:38:09 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56320 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbYEGLhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:37:38 -0400
Message-Id: <20080507113735.952179000@bull.net>
References: <20080507113553.395937000@bull.net>
User-Agent: quilt/0.45-1
Date: Wed, 07 May 2008 13:35:56 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 3/9] Fix a printk call
Content-Disposition: inline; filename=idr_fix_printk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 03/09]

This is a trivial patch that fixes the printk incomplete call.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/idr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.25-mm1/lib/idr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/idr.c	2008-05-06 17:24:15.000000000 +0200
+++ linux-2.6.25-mm1/lib/idr.c	2008-05-06 17:26:41.000000000 +0200
@@ -325,7 +325,8 @@ EXPORT_SYMBOL(idr_get_new);
 
 static void idr_remove_warning(int id)
 {
-	printk("idr_remove called for id=%d which is not allocated.\n", id);
+	printk(KERN_WARNING
+		"idr_remove called for id=%d which is not allocated.\n", id);
 	dump_stack();
 }
 

--
