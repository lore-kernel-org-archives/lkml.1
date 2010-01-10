Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752Ab0AJALS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0AJALS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 19:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553Ab0AJALR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 19:11:17 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:65290 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0AJALR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 19:11:17 -0500
X-Authuid: nmarci
Message-ID: <4B491B17.5070305@freemail.hu>
Date: Sun, 10 Jan 2010 01:11:03 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH] leds: make PCI device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct pci_driver is constant in <linux/pci.h>
so it is worth to make pci_device_id also constant.

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
diff -u -p a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
--- a/drivers/leds/leds-ss4200.c 2010-01-07 19:08:40.000000000 +0100
+++ b/drivers/leds/leds-ss4200.c 2010-01-08 11:25:42.000000000 +0100
@@ -63,7 +63,7 @@ MODULE_LICENSE("GPL");
 /*
  * PCI ID of the Intel ICH7 LPC Device within which the GPIO block lives.
  */
-static struct pci_device_id ich7_lpc_pci_id[] =
+static const struct pci_device_id ich7_lpc_pci_id[] =
 {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_1) },
