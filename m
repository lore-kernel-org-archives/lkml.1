Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250Ab0ADXo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0ADXo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059Ab0ADXoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:44:18 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:58794 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab0ADXoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:44:08 -0500
Message-ID: <4B427D43.2080809@freemail.hu>
Date: Tue, 05 Jan 2010 00:44:03 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>, lm-sensors@lm-sensors.org
CC: Julia Lawall <julia@diku.dk>, cocci@diku.dk,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] k10temp: make PCI device ids constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32721; Body=5 Fuz1=5
	Fuz2=5
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
diff -u -p a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
--- a/drivers/hwmon/k10temp.c 2009-12-27 12:20:18.000000000 +0100
+++ b/drivers/hwmon/k10temp.c 2010-01-03 20:55:44.000000000 +0100
@@ -169,7 +169,7 @@ static void __devexit k10temp_remove(str
 	dev_set_drvdata(&pdev->dev, NULL);
 }

-static struct pci_device_id k10temp_id_table[] = {
+static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{}
