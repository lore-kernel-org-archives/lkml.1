Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbXHQGDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbXHQGDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 02:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbXHQGDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 02:03:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:55174 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbXHQGDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 02:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=STNylJHIUcEymzjcYRV9sGIl3WxjFdW0F/emkDu35hOHzQjNEhB130/8zZlc2Ilri1gVfkwrs0F2jt9rw3mSJWe64VLPU2UoGqgu6EdZZy7qu9OophPhuHzSze+MeF+mWLior/XSxKHlHkm55hUaycThYg8WUvHcO4P5oWyGOSQ=
Subject: [PATCH One-liner] Bug fix of cfag12864b
From: Max Extreme <maxextreme@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 17 Aug 2007 08:03:09 +0200
Message-Id: <1187330589.6130.13.camel@shirou.ubw>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This one-liner patch fixes a bug in drivers/auxdisplay/cfag12864b.c

At cfag12864b_init(), the driver tries to kalloc some memory in the
variable cfag12864b_cache.

Then, as usual, it checks if the call failed. However, it checks
cfag12864b_buffer instead.

This patch changes the "cfag12864b_buffer" to "cfag12864b_cache" so the
correct variable is checked.

Signed-off-by: Miguel Ojeda <maxextreme@gmail.com>
---
diff -Naur linux-2.6.23-rc3-original/drivers/auxdisplay/cfag12864b.c
linux-2.6.23-rc3/drivers/auxdisplay/cfag12864b.c
--- linux-2.6.23-rc3-original/drivers/auxdisplay/cfag12864b.c	2007-07-09
01:32:17.000000000 +0200
+++ linux-2.6.23-rc3/drivers/auxdisplay/cfag12864b.c	2007-08-17
07:29:35.000000000 +0200
@@ -355,7 +355,7 @@
 
 	cfag12864b_cache = kmalloc(sizeof(unsigned char) *
 		CFAG12864B_SIZE, GFP_KERNEL);
-	if (cfag12864b_buffer == NULL) {
+	if (cfag12864b_cache == NULL) {
 		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
 			"can't alloc cache buffer (%i bytes)\n",
 			CFAG12864B_SIZE);

