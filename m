Return-Path: <linux-kernel-owner+w=401wt.eu-S1761262AbXFTBf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262AbXFTBf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 21:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758314AbXFTBfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 21:35:20 -0400
Received: from [60.23.248.87] ([60.23.248.87]:42720 "EHLO virgo.fc-cn.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbXFTBfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 21:35:19 -0400
X-Greylist: delayed 1142 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 21:35:19 EDT
Date: Wed, 20 Jun 2007 09:17:53 +0800
From: Qi Yong <qiyong@mail.fc-cn.com>
To: dtor@mail.ru
Cc: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch] add printk_ratelimit to atkbd_interrupt
Message-ID: <20070620011753.GA16692@virgo.fc-cn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add printk_ratelimit() to atkbd_interrupt(). I get "Spurious ACK" messages flushing on my
screen. This patch helps to read the screen.

Signed-off-by: Qi Yong <qiyong@mail.fc-cn.com>
--
diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index be1fe46..13e6bd4 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -408,9 +408,10 @@ static irqreturn_t atkbd_interrupt(struct serio *serio, unsigned char data,
 			goto out;
 		case ATKBD_RET_ACK:
 		case ATKBD_RET_NAK:
-			printk(KERN_WARNING "atkbd.c: Spurious %s on %s. "
-			       "Some program might be trying access hardware directly.\n",
-			       data == ATKBD_RET_ACK ? "ACK" : "NAK", serio->phys);
+			if (printk_ratelimit())
+				printk(KERN_WARNING "atkbd.c: Spurious %s on %s. "
+				       "Some program might be trying access hardware directly.\n",
+				       data == ATKBD_RET_ACK ? "ACK" : "NAK", serio->phys);
 			goto out;
 		case ATKBD_RET_HANGEUL:
 		case ATKBD_RET_HANJA:
