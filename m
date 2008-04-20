Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYDTRLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYDTRLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbYDTRK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:10:58 -0400
Received: from ZSM1387.piap.pl ([195.187.100.11]:54391 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbYDTRK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:10:57 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] WAN: Fix confusing insmod error code for C101 too.
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 20 Apr 2008 19:10:56 +0200
Message-ID: <m3myno5u5b.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WAN: Fix confusing insmod error code for C101 too.

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

diff --git a/drivers/net/wan/c101.c b/drivers/net/wan/c101.c
index c4c8eab..c2cc42f 100644
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -402,7 +402,7 @@ static int __init c101_init(void)
 #ifdef MODULE
 		printk(KERN_INFO "c101: no card initialized\n");
 #endif
-		return -ENOSYS;	/* no parameters specified, abort */
+		return -EINVAL;	/* no parameters specified, abort */
 	}
 
 	printk(KERN_INFO "%s\n", version);
@@ -420,11 +420,11 @@ static int __init c101_init(void)
 			c101_run(irq, ram);
 
 		if (*hw == '\x0')
-			return first_card ? 0 : -ENOSYS;
+			return first_card ? 0 : -EINVAL;
 	}while(*hw++ == ':');
 
 	printk(KERN_ERR "c101: invalid hardware parameters\n");
-	return first_card ? 0 : -ENOSYS;
+	return first_card ? 0 : -EINVAL;
 }
 
 
