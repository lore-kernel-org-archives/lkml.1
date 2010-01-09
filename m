Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815Ab0AIM40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab0AIM40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 07:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319Ab0AIM4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 07:56:24 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:50270 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab0AIM4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 07:56:11 -0500
X-Authuid: nmarci
Message-ID: <4B487CE3.5000500@freemail.hu>
Date: Sat, 09 Jan 2010 13:56:03 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] input: make PCI device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32711; Body=3 Fuz1=3
	Fuz2=3
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
diff -u -p a/drivers/input/serio/pcips2.c b/drivers/input/serio/pcips2.c
--- a/drivers/input/serio/pcips2.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/input/serio/pcips2.c 2010-01-08 19:12:05.000000000 +0100
@@ -186,7 +186,7 @@ static void __devexit pcips2_remove(stru
 	pci_disable_device(dev);
 }

-static struct pci_device_id pcips2_ids[] = {
+static const struct pci_device_id pcips2_ids[] = {
 	{
 		.vendor		= 0x14f2,	/* MOBILITY */
 		.device		= 0x0123,	/* Keyboard */
diff -u -p a/drivers/input/gameport/fm801-gp.c b/drivers/input/gameport/fm801-gp.c
--- a/drivers/input/gameport/fm801-gp.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/input/gameport/fm801-gp.c 2010-01-08 19:22:57.000000000 +0100
@@ -140,7 +140,7 @@ static void __devexit fm801_gp_remove(st
 	}
 }

-static struct pci_device_id fm801_gp_id_table[] = {
+static const struct pci_device_id fm801_gp_id_table[] = {
 	{ PCI_VENDOR_ID_FORTEMEDIA, PCI_DEVICE_ID_FM801_GP, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0  },
 	{ 0 }
 };
diff -u -p a/drivers/input/gameport/emu10k1-gp.c b/drivers/input/gameport/emu10k1-gp.c
--- a/drivers/input/gameport/emu10k1-gp.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/input/gameport/emu10k1-gp.c 2010-01-08 19:23:20.000000000 +0100
@@ -46,7 +46,7 @@ struct emu {
 	int size;
 };

-static struct pci_device_id emu_tbl[] = {
+static const struct pci_device_id emu_tbl[] = {

 	{ 0x1102, 0x7002, PCI_ANY_ID, PCI_ANY_ID }, /* SB Live gameport */
 	{ 0x1102, 0x7003, PCI_ANY_ID, PCI_ANY_ID }, /* Audigy gameport */
