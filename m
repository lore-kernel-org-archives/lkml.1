Return-Path: <linux-kernel-owner+w=401wt.eu-S1764778AbYD2Oi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778AbYD2Oi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760970AbYD2Oho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:37:44 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49779 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759514AbYD2Ohm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:37:42 -0400
Message-Id: <20080429143729.700669000@bull.net>
References: <20080429143304.741001000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 29 Apr 2008 16:33:08 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 04/10] Introduce ridr_init()
Content-Disposition: inline; filename=ridr_init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 04/10]

This patch introduces the ridr_init() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/ridr.h |    1 +
 lib/ridr.c           |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

Index: linux-2.6.25-mm1/include/linux/ridr.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/ridr.h	2008-04-29 13:14:56.000000000 +0200
+++ linux-2.6.25-mm1/include/linux/ridr.h	2008-04-29 13:21:56.000000000 +0200
@@ -44,6 +44,7 @@ struct ridr {
  * This is what we export.
  */
 int ridr_pre_get(struct ridr *, gfp_t);
+void ridr_init(struct ridr *);
 
 
 void __init ridr_init_cache(void);
Index: linux-2.6.25-mm1/lib/ridr.c
===================================================================
--- linux-2.6.25-mm1.orig/lib/ridr.c	2008-04-29 13:17:59.000000000 +0200
+++ linux-2.6.25-mm1/lib/ridr.c	2008-04-29 13:23:17.000000000 +0200
@@ -70,3 +70,17 @@ void __init ridr_init_cache(void)
 				ridr_cache_ctor);
 }
 
+/**
+ * ridr_init - initialize ridr handle
+ * @idp:	ridr handle
+ *
+ * This function is used to set up the handle (@idp) that you will pass
+ * to the rest of the functions.
+ */
+void ridr_init(struct ridr *idp)
+{
+	memset(idp, 0, sizeof(struct ridr));
+	spin_lock_init(&idp->lock);
+}
+EXPORT_SYMBOL(ridr_init);
+

--
