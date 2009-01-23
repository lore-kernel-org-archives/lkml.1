Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbZAWTwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbZAWTwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757807AbZAWTul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:50:41 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:63430 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754977AbZAWTui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:50:38 -0500
Date: Fri, 23 Jan 2009 22:50:37 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] powerpc: Add mmc-spi-slot bindings
Message-ID: <20090123195037.GD21237@oksana.dev.rtsoft.ru>
References: <20090123194958.GA17355@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090123194958.GA17355@oksana.dev.rtsoft.ru>
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
index cd17092..41c5dfd 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -446,6 +446,7 @@ struct of_modalias_table {
 };
 static struct of_modalias_table of_modalias_table[] = {
 	{ "fsl,mcu-mpc8349emitx", "mcu-mpc8349emitx" },
+	{ "mmc-spi-slot", "mmc_spi" },
 };
 
 /**
-- 
1.5.6.5

