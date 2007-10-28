Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbXJ1LPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbXJ1LPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 07:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXJ1LPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 07:15:09 -0400
Received: from slim-2c.inet.it ([213.92.5.123]:41024 "EHLO slim-2c.inet.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXJ1LPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 07:15:08 -0400
X-Greylist: delayed 2399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Oct 2007 07:15:08 EDT
From: "sebdeg@ngi.it" <sebdeg@ngi.it>
To: linux-kernel@vger.kernel.org
X-wmSenderIP: 80.104.88.232
Message-ID: <80.104.88.232.880780238.1193567706@webmail.inet.it>
Subject: [PATCH] /drivers/ide/pci/piix.c kernel 2.6.23
Date: Sun, 28 Oct 2007 10:35:06 +0000
X-Mailer: NGI Webmail
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In piix.c (and in ata_piix.c) are already included some patches to skip the cable check on some laptops and to enable UDMA>33 modes, but I've noticed than theese doesn't work on my Acer Aspire 5602WLMi (maybe exist more versions of this laptop). 
With this simple patch i can set transfert mode to UDMA100

--- linux-source-2.6.23/drivers/ide/pci/piix.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/ide/pci/piix.c	2007-10-25 22:25:53.000000000 +0200
@@ -405,6 +405,7 @@
 
 static const struct ich_laptop ich_laptop[] = {
 	/* devid, subvendor, subdev */
+	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
 	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
 	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */

