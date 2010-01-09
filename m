Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656Ab0AIOKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab0AIOKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 09:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624Ab0AIOKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 09:10:44 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:49166 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0AIOKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 09:10:44 -0500
X-Authuid: nmarci
Message-ID: <4B488E5A.6060505@freemail.hu>
Date: Sat, 09 Jan 2010 15:10:34 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-mtd@lists.infradead.org, Julia Lawall <julia@diku.dk>, cocci@diku.dk,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] nand: make PCI device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32721; Body=5 Fuz1=5
	Fuz2=9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct pci_driver is constant in <linux/pci.h>
so it is worth to make cafe_nand_tbl also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
--- a/drivers/mtd/nand/cafe_nand.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/mtd/nand/cafe_nand.c 2010-01-08 04:27:58.000000000 +0100
@@ -848,7 +848,7 @@ static void __devexit cafe_nand_remove(s
 	kfree(mtd);
 }

-static struct pci_device_id cafe_nand_tbl[] = {
+static const struct pci_device_id cafe_nand_tbl[] = {
 	{ PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_88ALP01_NAND,
 	  PCI_ANY_ID, PCI_ANY_ID },
 	{ }
