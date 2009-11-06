Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbZKFWmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbZKFWmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933189AbZKFWmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:42:00 -0500
Received: from www.tglx.de ([62.245.132.106]:54030 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933191AbZKFWl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:41:59 -0500
Message-Id: <20091106223806.682280699@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 06 Nov 2009 22:41:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: [patch 07/16] um: Replace old style lock initializer
References: <20091106223547.784916750@linutronix.de>
Content-Disposition: inline; filename=um-replace-old-style-lock-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED is deprecated since quite a while. Runtime init the
locks instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/ubd_kern.c
+++ linux-2.6/arch/um/drivers/ubd_kern.c
@@ -180,7 +180,6 @@ struct ubd {
 	.no_cow =               0, \
 	.shared =		0, \
 	.cow =			DEFAULT_COW, \
-	.lock =			SPIN_LOCK_UNLOCKED,	\
 	.request =		NULL, \
 	.start_sg =		0, \
 	.end_sg =		0, \
@@ -838,6 +837,7 @@ static int ubd_add(int n, char **error_o
 
 	ubd_dev->size = ROUND_BLOCK(ubd_dev->size);
 
+	spin_lock_init(&ubd_dev->lock);
 	INIT_LIST_HEAD(&ubd_dev->restart);
 	sg_init_table(ubd_dev->sg, MAX_SG);
 


