Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYEGLi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYEGLi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYEGLhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:37:36 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56286 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYEGLhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:37:34 -0400
Message-Id: <20080507113735.137310000@bull.net>
References: <20080507113553.395937000@bull.net>
User-Agent: quilt/0.45-1
Date: Wed, 07 May 2008 13:35:54 +0200
From: Nadia.Derbey@bull.net
To: manfred@colorfullife.com, paulmck@linux.vnet.ibm.com,
       lnxninja@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, akpm@linux-foundation.org,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 1/9] Change the idr structure
Content-Disposition: inline; filename=idr_add_rcu_head.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 01/09]

This patch adds an rcu_head to the idr_layer structure in order to free it
after a grace period.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 include/linux/idr.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.25-mm1/include/linux/idr.h
===================================================================
--- linux-2.6.25-mm1.orig/include/linux/idr.h	2008-05-06 17:14:24.000000000 +0200
+++ linux-2.6.25-mm1/include/linux/idr.h	2008-05-06 17:20:58.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/init.h>
+#include <linux/rcupdate.h>
 
 #if BITS_PER_LONG == 32
 # define IDR_BITS 5
@@ -51,6 +52,7 @@ struct idr_layer {
 	unsigned long		 bitmap; /* A zero bit means "space here" */
 	struct idr_layer	*ary[1<<IDR_BITS];
 	int			 count;	 /* When zero, we can release it */
+	struct rcu_head		 rcu_head;
 };
 
 struct idr {

--
