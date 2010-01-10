Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763Ab0AJQ7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab0AJQ7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 11:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708Ab0AJQ7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:59:51 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:58162 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab0AJQ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:59:48 -0500
X-Authuid: nmarci
Message-ID: <4B4A077C.7020406@freemail.hu>
Date: Sun, 10 Jan 2010 17:59:40 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux-serial@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH 3/3] serial: make PCI device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct pci_driver is constant in <linux/pci.h>
so it is worth to make initialization data also constant.

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
diff -u -p a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/serial/8250_pci.c 2010-01-08 18:40:05.000000000 +0100
@@ -2567,7 +2567,7 @@ static int pciserial_resume_one(struct p
 }
 #endif

-static struct pci_device_id serial_pci_tbl[] = {
+static const struct pci_device_id serial_pci_tbl[] = {
 	/* Advantech use PCI_DEVICE_ID_ADVANTECH_PCI3620 (0x3620) as 'PCI_SUBVENDOR_ID' */
 	{	PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
 		PCI_DEVICE_ID_ADVANTECH_PCI3620, 0x0001, 0, 0,
diff -u -p a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
--- a/drivers/serial/jsm/jsm_driver.c 2010-01-07 19:08:45.000000000 +0100
+++ b/drivers/serial/jsm/jsm_driver.c 2010-01-08 18:41:09.000000000 +0100
@@ -218,7 +218,7 @@ static void __devexit jsm_remove_one(str
 	kfree(brd);
 }

-static struct pci_device_id jsm_pci_tbl[] = {
+static const struct pci_device_id jsm_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2DB9), 0, 0, 0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2DB9PRI), 0, 0, 1 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45), 0, 0, 2 },
