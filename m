Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZJJKEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZJJKEM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 06:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZJJKEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 06:04:12 -0400
Received: from www.tglx.de ([62.245.132.106]:38419 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZJJKEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 06:04:11 -0400
Date: Sat, 10 Oct 2009 12:03:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] watchdog: Fix rio watchdog probe function
Message-ID: <alpine.LFD.2.00.0910101201470.9428@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After sucessfully registering the misc device the driver iounmaps the
hardware registers and kfree's the device data structure. Ouch !

This was introduced with commit e42311d75 (riowatchdog: Convert to
pure OF driver) and went unnoticed for more than a year :)

Return success instead of dropping into the error cleanup code path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/watchdog/riowd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/watchdog/riowd.c
===================================================================
--- linux-2.6-tip.orig/drivers/watchdog/riowd.c
+++ linux-2.6-tip/drivers/watchdog/riowd.c
@@ -206,7 +206,7 @@ static int __devinit riowd_probe(struct 
 
 	dev_set_drvdata(&op->dev, p);
 	riowd_device = p;
-	err = 0;
+	return 0;
 
 out_iounmap:
 	of_iounmap(&op->resource[0], p->regs, 2);
