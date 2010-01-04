Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217Ab0ADXoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0ADXoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919Ab0ADXoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:44:06 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:55903 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab0ADXoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:44:03 -0500
Message-ID: <4B427D40.3010102@freemail.hu>
Date: Tue, 05 Jan 2010 00:44:00 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Roger Lucas <vt8231@hiddenengine.co.uk>, lm-sensors@lm-sensors.org
CC: Julia Lawall <julia@diku.dk>, cocci@diku.dk,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] vt8231: make PCI device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32711; Body=5 Fuz1=5
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
diff -u -p a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
--- a/drivers/hwmon/vt8231.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/hwmon/vt8231.c 2010-01-03 20:55:14.000000000 +0100
@@ -697,7 +697,7 @@ static struct platform_driver vt8231_dri
 	.remove	= __devexit_p(vt8231_remove),
 };

-static struct pci_device_id vt8231_pci_ids[] = {
+static const struct pci_device_id vt8231_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8231_4) },
 	{ 0, }
 };
