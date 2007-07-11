Return-Path: <linux-kernel-owner+w=401wt.eu-S936714AbXGLALE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936714AbXGLALE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936748AbXGKX7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:59:09 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58819
	"EHLO vs166246.vserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S935770AbXGKX7H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:59:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] rocket: Fix mutex locking compile warning
Date: Thu, 12 Jul 2007 01:56:32 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707120156.32795.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes

drivers/char/rocket.c: In function ‘rp_write’:
drivers/char/rocket.c:1705: warning: ignoring return value of ‘mutex_lock_interruptible’, declared with attribute warn_unused_result

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: bu3sch-wireless-dev/drivers/char/rocket.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/char/rocket.c	2007-05-18 18:09:48.000000000 +0200
+++ bu3sch-wireless-dev/drivers/char/rocket.c	2007-07-12 01:52:44.000000000 +0200
@@ -1702,7 +1702,8 @@ static int rp_write(struct tty_struct *t
 	if (count <= 0 || rocket_paranoia_check(info, "rp_write"))
 		return 0;
 
-	mutex_lock_interruptible(&info->write_mtx);
+	if (mutex_lock_interruptible(&info->write_mtx))
+		return -ERESTARTSYS;
 
 #ifdef ROCKET_DEBUG_WRITE
 	printk(KERN_INFO "rp_write %d chars...", count);

-- 
Greetings Michael.
