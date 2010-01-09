Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784Ab0AIXSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0AIXSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490Ab0AIXSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:18:39 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:49830 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab0AIXSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:18:39 -0500
X-Authuid: nmarci
Message-ID: <4B490EC2.7050703@freemail.hu>
Date: Sun, 10 Jan 2010 00:18:26 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH 1/3] staging: make PCI device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02a.mail.t-online.hu 32721; Body=5 Fuz1=5
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
diff -u -p a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
--- a/drivers/staging/sm7xx/smtcfb.c 2010-01-07 19:08:46.000000000 +0100
+++ b/drivers/staging/sm7xx/smtcfb.c 2010-01-08 09:56:41.000000000 +0100
@@ -1103,7 +1103,7 @@ static int __init smtcfb_pci_probe(struc


 /* Jason (08/11/2009) PCI_DRV wrapper essential structs */
-static struct pci_device_id smtcfb_pci_table[] = {
+static const struct pci_device_id smtcfb_pci_table[] = {
 	{0x126f, 0x710, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0x126f, 0x712, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0x126f, 0x720, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
diff -u -p a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
--- a/drivers/staging/sep/sep_driver.c 2010-01-07 19:08:46.000000000 +0100
+++ b/drivers/staging/sep/sep_driver.c 2010-01-08 09:57:33.000000000 +0100
@@ -2586,7 +2586,7 @@ end_function:
 	return error;
 }

-static struct pci_device_id sep_pci_id_tbl[] = {
+static const struct pci_device_id sep_pci_id_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080c)},
 	{0}
 };
diff -u -p a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
--- a/drivers/staging/vme/bridges/vme_tsi148.c 2010-01-07 19:08:46.000000000 +0100
+++ b/drivers/staging/vme/bridges/vme_tsi148.c 2010-01-08 10:26:28.000000000 +0100
@@ -80,7 +80,7 @@ struct mutex vme_int;	/*

 static char driver_name[] = "vme_tsi148";

-static struct pci_device_id tsi148_ids[] = {
+static const struct pci_device_id tsi148_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TUNDRA, PCI_DEVICE_ID_TUNDRA_TSI148) },
 	{ },
 };
diff -u -p a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c 2010-01-07 19:08:46.000000000 +0100
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c 2010-01-08 10:26:58.000000000 +0100
@@ -56,7 +56,7 @@ struct mutex vme_int;   /*

 static char driver_name[] = "vme_ca91cx42";

-static struct pci_device_id ca91cx42_ids[] = {
+static const struct pci_device_id ca91cx42_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TUNDRA, PCI_DEVICE_ID_TUNDRA_CA91C142) },
 	{ },
 };
diff -u -p a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
--- a/drivers/staging/phison/phison.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/staging/phison/phison.c 2010-01-08 10:27:46.000000000 +0100
@@ -69,7 +69,7 @@ static int phison_init_one(struct pci_de
 	return ret;
 }

-static struct pci_device_id phison_pci_tbl[] = {
+static const struct pci_device_id phison_pci_tbl[] = {
 	{ PCI_VENDOR_ID_PHISON, PCI_DEVICE_ID_PS5000, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 0 },
 	{ 0, },
diff -u -p a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
--- a/drivers/staging/rar/rar_driver.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/staging/rar/rar_driver.c 2010-01-08 11:11:53.000000000 +0100
@@ -70,7 +70,7 @@ static void __exit rar_exit_handler(void
 */
 static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent);

-static struct pci_device_id rar_pci_id_tbl[] = {
+static const struct pci_device_id rar_pci_id_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4110) },
 	{ 0 }
 };
