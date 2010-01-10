Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155Ab0AJMOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0AJMOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 07:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823Ab0AJMOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 07:14:04 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:61637 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0AJMOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 07:14:01 -0500
X-Authuid: nmarci
Message-ID: <4B49C483.5090901@freemail.hu>
Date: Sun, 10 Jan 2010 13:13:55 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH] gpio: make PCI device id constant
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
diff -u -p a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c 2010-01-07 19:08:39.000000000 +0100
+++ b/drivers/gpio/langwell_gpio.c 2010-01-08 07:52:43.000000000 +0100
@@ -157,7 +157,7 @@ static struct irq_chip lnw_irqchip = {
 	.set_type	= lnw_irq_type,
 };

-static struct pci_device_id lnw_gpio_ids[] = {
+static const struct pci_device_id lnw_gpio_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f) },
 	{ 0, }
 };
diff -u -p a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
--- a/drivers/gpio/bt8xxgpio.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/gpio/bt8xxgpio.c 2010-01-08 07:53:33.000000000 +0100
@@ -312,7 +312,7 @@ static int bt8xxgpio_resume(struct pci_d
 #define bt8xxgpio_resume NULL
 #endif /* CONFIG_PM */

-static struct pci_device_id bt8xxgpio_pci_tbl[] = {
+static const struct pci_device_id bt8xxgpio_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT848) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT849) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT878) },
