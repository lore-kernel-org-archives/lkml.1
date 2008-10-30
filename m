Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYJ3T4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYJ3T4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJ3T4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:56:32 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:3501 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751035AbYJ3T4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:56:31 -0400
Date: Thu, 30 Oct 2008 22:56:30 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/3] powerpc: Add mmc-spi-slot bindings
Message-ID: <20081030195630.GA13640@oksana.dev.rtsoft.ru>
References: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081030195546.GA30645@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bindings describes a case where MMC/SD/SDIO slot directly connected
to a SPI bus. Such setups are widely used on embedded PowerPC boards.

The patch also adds the mmc-spi-slot entry to the OpenFirmware modalias
table.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 .../powerpc/dts-bindings/mmc-spi-slot.txt          |   23 ++++++++++++++++++++
 drivers/of/base.c                                  |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/mmc-spi-slot.txt

diff --git a/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt b/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
new file mode 100644
index 0000000..c39ac28
--- /dev/null
+++ b/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
@@ -0,0 +1,23 @@
+MMC/SD/SDIO slot directly connected to a SPI bus
+
+Required properties:
+- compatible : should be "mmc-spi-slot".
+- reg : should specify SPI address (chip-select number).
+- spi-max-frequency : maximum frequency for this device (Hz).
+- voltage-ranges : two cells are required, first cell specifies minimum
+  slot voltage (mV), second cell specifies maximum slot voltage (mV).
+  Several ranges could be specified.
+- gpios : (optional) may specify GPIOs in this order: Card-Detect GPIO,
+  Write-Protect GPIO.
+
+Example:
+
+	mmc-slot@0 {
+		compatible = "fsl,mpc8323rdb-mmc-slot",
+			     "mmc-spi-slot";
+		reg = <0>;
+		gpios = <&qe_pio_d 14 1
+			 &qe_pio_d 15 0>;
+		voltage-ranges = <3300 3300>;
+		spi-max-frequency = <50000000>;
+	};
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 7c79e94..c6797ca 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -411,6 +411,7 @@ struct of_modalias_table {
 };
 static struct of_modalias_table of_modalias_table[] = {
 	{ "fsl,mcu-mpc8349emitx", "mcu-mpc8349emitx" },
+	{ "mmc-spi-slot", "mmc_spi" },
 };
 
 /**
-- 
1.5.6.3

