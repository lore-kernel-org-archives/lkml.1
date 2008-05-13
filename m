Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYEMTRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYEMTRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbYEMTRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:17:35 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:54692 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbYEMTRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:17:34 -0400
X-ME-UUID: 20080513191732372.5B0B31C0008D@mwinf2713.orange.fr
Subject: [PATCH 1/1] avr32/pata: avoid unnecessary memset (updated after comments)
From: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>
To: "cj" <christophe.jaillet@wanadoo.fr>,
       "linux" <linux-kernel@vger.kernel.org>, <hskinnemoen@atmel.com>,
       <jeff@garzik.org>, <gregerts@stud.ntnu.no>
Date: Tue, 13 May 2008 21:17:30 +0200
Content-Type: text/plain
X-Mailer: email v2.5.1 (CYGWIN_NT-5.0 1.5.25(0.156/4/2) i686 [http://email.cleancode.org])
X-Antivirus: avast! (VPS 080513-0, 13/05/2008), Outbound message
X-Antivirus-Status: Clean
Message-Id: <20080513191732.5B0B31C0008D@mwinf2713.orange.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Hi, here is a patch against linux/drivers/ata/pata_at32.c which :
	
1) Remove an explicit memset(.., 0, ...) to a variable allocated with
kzalloc (i.e. 'info').


Note: this patch is based on 'linux-2.6.25.tar.bz2'

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

---

--- linux/drivers/ata/pata_at32.c	2008-04-17 04:49:44.000000000 +0200
+++ linux/drivers/ata/pata_at32.c.cj	2008-05-12 23:07:10.000000000 +0200
@@ -329,8 +329,6 @@ static int __init pata_at32_probe(struct
 	if (!info)
 		return -ENOMEM;
 
-	memset(info, 0, sizeof(struct at32_ide_info));
-
 	info->irq = irq;
 	info->cs  = board->cs;
 


