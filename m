Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZETUJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZETUJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 16:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZETUJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 16:09:43 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43015 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZETUJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 16:09:43 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: mickflemm@gmail.com, lrodriguez@atheros.com, me@bobcopeland.com,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/3] ath5k: led, cleanup and prepare macros
Date: Wed, 20 May 2009 22:08:58 +0200
Message-Id: <1242850139-25438-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242850139-25438-1-git-send-email-jirislaby@gmail.com>
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

We need to use driver_data for more than pin and polaroty data.
Remove driver_data designator from ATH_LED definition and write
it explicitly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/wireless/ath/ath5k/led.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 762e40d..0374b1f 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -47,30 +47,39 @@
 	.vendor = PCI_ANY_ID, .device = PCI_ANY_ID, \
 	.subvendor = (subv), .subdevice = (subd)
 
-#define ATH_LED(pin,polarity) .driver_data = (((pin) << 8) | (polarity))
-#define ATH_PIN(data) ((data) >> 8)
-#define ATH_POLARITY(data) ((data) & 0xff)
+#define ATH_LED(pin, polarity)	(((pin) << 8) | (polarity))
+#define ATH_PIN(data)		(((data) >> 8) & 0xffff)
+#define ATH_POLARITY(data)	((data) & 0xff)
 
 /* Devices we match on for LED config info (typically laptops) */
 static const struct pci_device_id ath5k_led_devices[] = {
 	/* AR5211 */
-	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5211), ATH_LED(0, 0) },
+	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5211),
+			.driver_data = ATH_LED(0, 0) },
 	/* HP Compaq nc6xx, nc4000, nx6000 */
-	{ ATH_SDEVICE(PCI_VENDOR_ID_COMPAQ, PCI_ANY_ID), ATH_LED(1, 1) },
+	{ ATH_SDEVICE(PCI_VENDOR_ID_COMPAQ, PCI_ANY_ID),
+			.driver_data = ATH_LED(1, 1) },
 	/* Acer Aspire One A150 (maximlevitsky@gmail.com) */
-	{ ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, 0xe008), ATH_LED(3, 0) },
+	{ ATH_SDEVICE(PCI_VENDOR_ID_FOXCONN, 0xe008),
+			.driver_data = ATH_LED(3, 0) },
 	/* Acer Ferrari 5000 (russ.dill@gmail.com) */
-	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0422), ATH_LED(1, 1) },
+	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0422),
+			.driver_data = ATH_LED(1, 1) },
 	/* E-machines E510 (tuliom@gmail.com) */
-	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0428), ATH_LED(3, 0) },
+	{ ATH_SDEVICE(PCI_VENDOR_ID_AMBIT, 0x0428),
+			.driver_data = ATH_LED(3, 0) },
 	/* Acer Extensa 5620z (nekoreeve@gmail.com) */
-	{ ATH_SDEVICE(PCI_VENDOR_ID_QMI, 0x0105), ATH_LED(3, 0) },
+	{ ATH_SDEVICE(PCI_VENDOR_ID_QMI, 0x0105),
+			.driver_data = ATH_LED(3, 0) },
 	/* Fukato Datacask Jupiter 1014a (mrb74@gmx.at) */
-	{ ATH_SDEVICE(PCI_VENDOR_ID_AZWAVE, 0x1026), ATH_LED(3, 0) },
+	{ ATH_SDEVICE(PCI_VENDOR_ID_AZWAVE, 0x1026),
+			.driver_data = ATH_LED(3, 0) },
 	/* IBM ThinkPad AR5BXB6 (legovini@spiro.fisica.unipd.it) */
-	{ ATH_SDEVICE(PCI_VENDOR_ID_IBM, 0x058a), ATH_LED(1, 0) },
+	{ ATH_SDEVICE(PCI_VENDOR_ID_IBM, 0x058a),
+			.driver_data = ATH_LED(1, 0) },
 	/* IBM-specific AR5212 (all others) */
-	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
+	{ PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM),
+			.driver_data = ATH_LED(0, 0) },
 	{ }
 };
 
-- 
1.6.3

