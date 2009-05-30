Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbZE3Xko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbZE3Xko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 19:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZE3Xke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 19:40:34 -0400
Received: from [213.58.128.207] ([213.58.128.207]:43225 "EHLO
	ftp.linux-mips.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZE3Xkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 19:40:33 -0400
Date: Sun, 31 May 2009 00:40:31 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jeff Garzik <jgarzik@pobox.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 3c509: Add missing EISA IDs
Message-ID: <alpine.LFD.1.10.0905310021070.15490@ftp.linux-mips.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Several EISA device IDs for 3c509 family network cards are missing from 
the driver, making the cards unusable in their EISA mode.  Here's a fix to 
add them based on the EISA configuration files distributed by 3Com and our 
eisa.ids database.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Successfully tested with a 3c509-Combo network card:

EISA: Probing bus 0 at eisa.0
EISA: Mainboard AEI0401 detected.
EISA: slot 6 : NPI0303 detected.
EISA: slot 8 : TCM5094 detected.
eth0: 3c5x9 found at 0x8000, 10baseT port, address 00:a0:24:b6:8b:db, IRQ 11.
3c509.c:1.20 04Feb2008 becker@scyld.com
EISA: Detected 2 cards.

 Please apply.

  Maciej

patch-mips-2.6.27-rc8-20081004-3c509-eisa-0
Index: linux-mips-2.6.27-rc8-20081004-dolch/drivers/net/3c509.c
===================================================================
--- linux-mips-2.6.27-rc8-20081004-dolch.orig/drivers/net/3c509.c
+++ linux-mips-2.6.27-rc8-20081004-dolch/drivers/net/3c509.c
@@ -480,9 +480,13 @@ static int pnp_registered;
 
 #ifdef CONFIG_EISA
 static struct eisa_device_id el3_eisa_ids[] = {
+		{ "TCM5090" },
+		{ "TCM5091" },
 		{ "TCM5092" },
 		{ "TCM5093" },
+		{ "TCM5094" },
 		{ "TCM5095" },
+		{ "TCM5098" },
 		{ "" }
 };
 MODULE_DEVICE_TABLE(eisa, el3_eisa_ids);
