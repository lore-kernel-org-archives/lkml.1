Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbYASNUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbYASNUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 08:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYASNUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 08:20:05 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51584 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbYASNUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 08:20:04 -0500
Date: Sat, 19 Jan 2008 15:18:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: chas@cmf.nrl.navy.mil, jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] atm/idt77105.c: fix section mismatch
Message-ID: <20080119131849.GA8669@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL'ed code mustn't be __*init.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/drivers/atm/idt77105.c.old	2008-01-19 11:19:53.000000000 +0200
+++ linux-2.6/drivers/atm/idt77105.c	2008-01-19 11:20:10.000000000 +0200
@@ -354,13 +354,13 @@ static const struct atmphy_ops idt77105_
 	.ioctl =	idt77105_ioctl,
 	.interrupt =	idt77105_int,
 	.stop =		idt77105_stop,
 };
 
 
-int __devinit idt77105_init(struct atm_dev *dev)
+int idt77105_init(struct atm_dev *dev)
 {
 	dev->phy = &idt77105_ops;
 	return 0;
 }
 
 EXPORT_SYMBOL(idt77105_init);

