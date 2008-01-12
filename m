Return-Path: <linux-kernel-owner+w=401wt.eu-S1762306AbYALUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbYALUQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbYALUQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:16:06 -0500
Received: from kanga.kvack.org ([66.96.29.28]:44842 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757539AbYALUQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:16:05 -0500
Date: Sat, 12 Jan 2008 15:15:43 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: akpm@osdl.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: remove "too much work for irq" printk
Message-ID: <20080112201543.GB12775@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using kvm with a serial console, the serial driver will print out 
"too much work for irq4" on any heavy activity (ie vi on a file repainting 
the terminal).  This message is entirely spurious, as output continues to 
work fine.  Remove the message as it corrupts screen output and is far too 
easy to trigger.

		-ben

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index f94109c..030b8b5 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1493,12 +1493,8 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 
 		l = l->next;
 
-		if (l == i->head && pass_counter++ > PASS_LIMIT) {
-			/* If we hit this, we're dead. */
-			printk(KERN_ERR "serial8250: too much work for "
-				"irq%d\n", irq);
+		if (l == i->head && pass_counter++ > PASS_LIMIT)
 			break;
-		}
 	} while (l != end);
 
 	spin_unlock(&i->lock);
