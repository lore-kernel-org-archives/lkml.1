Return-Path: <linux-kernel-owner+w=401wt.eu-S1763792AbXKTUvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763792AbXKTUvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760902AbXKTUvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:51:17 -0500
Received: from outmail1.freedom2surf.net ([194.106.33.237]:37486 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760685AbXKTUvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:51:16 -0500
Subject: [patch] 3/4 Support for Toshiba TMIO multifunction devices
From: ian <spyro@f2s.com>
To: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-17lY5CsuEQRemI3sTSM/"
Date: Tue, 20 Nov 2007 20:47:58 +0000
Message-Id: <1195591678.2329.62.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-17lY5CsuEQRemI3sTSM/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi guys.

This patchset contains support for three toshiba multifunction devices.

This adds necessary IRQ and GPIO definitions for use by the e-series
platform support code.

--=-17lY5CsuEQRemI3sTSM/
Content-Disposition: attachment; filename=0003-add-IRQ-and-GPIO-definitions-for-eseries.patch
Content-Type: application/mbox; name=0003-add-IRQ-and-GPIO-definitions-for-eseries.patch
Content-Transfer-Encoding: 7bit

>From 87ba14b8b579e07b395446d3029fb817e672cf01 Mon Sep 17 00:00:00 2001
From: Ian Molton <spyro@f2s.com>
Date: Tue, 20 Nov 2007 19:55:17 +0000
Subject: [PATCH] add IRQ and GPIO definitions for eseries

---
 include/asm-arm/arch-pxa/eseries-gpio.h |   33 +++++++++++++++++++++++++++++++
 include/asm-arm/arch-pxa/eseries-irq.h  |   20 ++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-arm/arch-pxa/eseries-gpio.h
 create mode 100644 include/asm-arm/arch-pxa/eseries-irq.h

diff --git a/include/asm-arm/arch-pxa/eseries-gpio.h b/include/asm-arm/arch-pxa/eseries-gpio.h
new file mode 100644
index 0000000..6d2edbd
--- /dev/null
+++ b/include/asm-arm/arch-pxa/eseries-gpio.h
@@ -0,0 +1,33 @@
+
+/* UDC GPIO definitions */
+#define GPIO_E7XX_USB_DISC       13
+#define GPIO_E7XX_USB_PULLUP      3
+
+#define GPIO_E800_USB_DISC        4
+#define GPIO_E800_USB_PULLUP     84
+
+/* e740 PCMCIA GPIO definitions */
+#define GPIO_E740_PCMCIA_CD0      8
+#define GPIO_E740_PCMCIA_CD1     44
+#define GPIO_E740_PCMCIA_RDY0    11
+#define GPIO_E740_PCMCIA_RDY1     6
+#define GPIO_E740_PCMCIA_RST0    27
+#define GPIO_E740_PCMCIA_RST1    24
+#define GPIO_E740_PCMCIA_PWR0    20
+#define GPIO_E740_PCMCIA_PWR1    23 //INVERTED!
+
+/* e750 PCMCIA GPIO definitions */
+#define GPIO_E750_PCMCIA_CD0      8
+#define GPIO_E750_PCMCIA_RDY0    12
+#define GPIO_E750_PCMCIA_RST0    27
+#define GPIO_E750_PCMCIA_PWR0    20
+
+/* e800 PCMCIA GPIO definitions */
+#define GPIO_E800_PCMCIA_RST0    69
+#define GPIO_E800_PCMCIA_RST1    72
+#define GPIO_E800_PCMCIA_PWR0    20
+#define GPIO_E800_PCMCIA_PWR1    73
+
+/* ASIC related GPIOs */
+#define GPIO_ESERIES_TMIO_IRQ        5
+#define GPIO_E800_ANGELX_IRQ      8
diff --git a/include/asm-arm/arch-pxa/eseries-irq.h b/include/asm-arm/arch-pxa/eseries-irq.h
new file mode 100644
index 0000000..92feeaf
--- /dev/null
+++ b/include/asm-arm/arch-pxa/eseries-irq.h
@@ -0,0 +1,20 @@
+void __init angelx_init_irq(int irq, unsigned int base);
+
+#define ANGELX_IRQ_BASE (IRQ_BOARD_START+8)
+#define IRQ_ANGELX(n) (ANGELX_IRQ_BASE + (n))
+
+#define ANGELX_RDY0_IRQ IRQ_ANGELX(0)
+#define ANGELX_ST0_IRQ  IRQ_ANGELX(1)
+#define ANGELX_CD0_IRQ  IRQ_ANGELX(2)
+#define ANGELX_RDY1_IRQ IRQ_ANGELX(3)
+#define ANGELX_ST1_IRQ  IRQ_ANGELX(4)
+#define ANGELX_CD1_IRQ  IRQ_ANGELX(5)
+
+#define TMIO_IRQ_BASE (IRQ_BOARD_START+0)
+#define IRQ_TMIO(n) (TMIO_IRQ_BASE + (n))
+
+int tmio_init_irq(int irq, unsigned int);
+
+#define TMIO_SD_IRQ     IRQ_TMIO(1)
+#define TMIO_USB_IRQ    IRQ_TMIO(2)
+
-- 
1.5.3.5.737.gdee1b


--=-17lY5CsuEQRemI3sTSM/--

