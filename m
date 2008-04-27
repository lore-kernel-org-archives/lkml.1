Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYD0HMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYD0HMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 03:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYD0HMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 03:12:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:16223 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYD0HMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:12:22 -0400
Message-ID: <a24804730804270012ycdbd962v377e0a3b9a379013@mail.gmail.com>
Date: Sun, 27 Apr 2008 00:12:22 -0700
From: "Chris Peterson" <cpeterso@cpeterso.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix uninitialized variable warning in crypto/async_tx/async_tx.c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch against linux-2.6.25-git7.

/mnt/westside/vol/silver/cpeterso/tmp/linux/linux-2.6.25/crypto/async_tx/async_tx.c:
In function `async_trigger_callback':
/mnt/westside/vol/silver/cpeterso/tmp/linux/linux-2.6.25/crypto/async_tx/async_tx.c:584:
warning: `chan' might be used uninitialized in this function

chris


Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
---
diff -Naur linux-2.6.25-git7/crypto/async_tx/async_tx.c
linux-2.6.25-git7+patch/crypto/async_tx/async_tx.c
--- linux-2.6.25-git7/crypto/async_tx/async_tx.c	2008-04-25
22:46:24.000000000 -0700
+++ linux-2.6.25-git7+patch/crypto/async_tx/async_tx.c	2008-04-25
23:39:44.000000000 -0700
@@ -596,8 +596,11 @@
 			device = NULL;

 		tx = device ? device->device_prep_dma_interrupt(chan, 0) : NULL;
-	} else
+	} else {
+		chan = NULL;
+		device = NULL;
 		tx = NULL;
+	}

 	if (tx) {
 		pr_debug("%s: (async)\n", __func__);
