Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050Ab0AJMji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab0AJMji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 07:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829Ab0AJMjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 07:39:37 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:64458 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab0AJMjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 07:39:37 -0500
X-Authuid: nmarci
Message-ID: <4B49CA81.40706@freemail.hu>
Date: Sun, 10 Jan 2010 13:39:29 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH 1/5] block: make PCI device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct pci_driver is constant in <linux/pci.h>
so it is worth to make the initialization data also constant.

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
diff -u -p a/drivers/block/DAC960.c b/drivers/block/DAC960.c
--- a/drivers/block/DAC960.c 2010-01-07 19:08:39.000000000 +0100
+++ b/drivers/block/DAC960.c 2010-01-08 09:16:28.000000000 +0100
@@ -7134,7 +7134,7 @@ static struct DAC960_privdata DAC960_P_p
 	.MemoryWindowSize =	DAC960_PD_RegisterWindowSize,
 };

-static struct pci_device_id DAC960_id_table[] = {
+static const struct pci_device_id DAC960_id_table[] = {
 	{
 		.vendor 	= PCI_VENDOR_ID_MYLEX,
 		.device		= PCI_DEVICE_ID_MYLEX_DAC960_GEM,
diff -u -p a/drivers/block/sx8.c b/drivers/block/sx8.c
--- a/drivers/block/sx8.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/block/sx8.c 2010-01-08 09:27:47.000000000 +0100
@@ -409,7 +409,7 @@ static int carm_init_one (struct pci_dev
 static void carm_remove_one (struct pci_dev *pdev);
 static int carm_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo);

-static struct pci_device_id carm_pci_tbl[] = {
+static const struct pci_device_id carm_pci_tbl[] = {
 	{ PCI_VENDOR_ID_PROMISE, 0x8000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
 	{ PCI_VENDOR_ID_PROMISE, 0x8002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
 	{ }	/* terminate list */
