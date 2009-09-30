Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZI3Tob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZI3Tob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZI3To0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:44:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37006 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbZI3ToW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:44:22 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 1/7] spi-imx: rename source file to spi_imx.c
Date: Wed, 30 Sep 2009 21:43:28 +0200
Message-Id: <1254339814-21506-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <20090930194211.GB1881@pengutronix.de>
References: <20090930194211.GB1881@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the filename match the Kconfig symbol and the driver name.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/spi/Makefile                 |    2 +-
 drivers/spi/{mxc_spi.c => spi_imx.c} |  336 +++++++++++++++++-----------------
 2 files changed, 169 insertions(+), 169 deletions(-)
 rename drivers/spi/{mxc_spi.c => spi_imx.c} (57%)

diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
index 6d7a3f8..21a1182 100644
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_SPI_BITBANG)		+= spi_bitbang.o
 obj-$(CONFIG_SPI_AU1550)		+= au1550_spi.o
 obj-$(CONFIG_SPI_BUTTERFLY)		+= spi_butterfly.o
 obj-$(CONFIG_SPI_GPIO)			+= spi_gpio.o
-obj-$(CONFIG_SPI_IMX)			+= mxc_spi.o
+obj-$(CONFIG_SPI_IMX)			+= spi_imx.o
 obj-$(CONFIG_SPI_LM70_LLP)		+= spi_lm70llp.o
 obj-$(CONFIG_SPI_PXA2XX)		+= pxa2xx_spi.o
 obj-$(CONFIG_SPI_OMAP_UWIRE)		+= omap_uwire.o
diff --git a/drivers/spi/mxc_spi.c b/drivers/spi/spi_imx.c
similarity index 57%
rename from drivers/spi/mxc_spi.c
rename to drivers/spi/spi_imx.c
index b144723..b1f530f 100644
--- a/drivers/spi/mxc_spi.c
+++ b/drivers/spi/spi_imx.c
@@ -48,14 +48,14 @@
 #define MXC_INT_RR	(1 << 0) /* Receive data ready interrupt */
 #define MXC_INT_TE	(1 << 1) /* Transmit FIFO empty interrupt */
 
-struct mxc_spi_config {
+struct spi_imx_config {
 	unsigned int speed_hz;
 	unsigned int bpw;
 	unsigned int mode;
 	int cs;
 };
 
-struct mxc_spi_data {
+struct spi_imx_data {
 	struct spi_bitbang bitbang;
 
 	struct completion xfer_done;
@@ -66,43 +66,43 @@ struct mxc_spi_data {
 	int *chipselect;
 
 	unsigned int count;
-	void (*tx)(struct mxc_spi_data *);
-	void (*rx)(struct mxc_spi_data *);
+	void (*tx)(struct spi_imx_data *);
+	void (*rx)(struct spi_imx_data *);
 	void *rx_buf;
 	const void *tx_buf;
 	unsigned int txfifo; /* number of words pushed in tx FIFO */
 
 	/* SoC specific functions */
-	void (*intctrl)(struct mxc_spi_data *, int);
-	int (*config)(struct mxc_spi_data *, struct mxc_spi_config *);
-	void (*trigger)(struct mxc_spi_data *);
-	int (*rx_available)(struct mxc_spi_data *);
+	void (*intctrl)(struct spi_imx_data *, int);
+	int (*config)(struct spi_imx_data *, struct spi_imx_config *);
+	void (*trigger)(struct spi_imx_data *);
+	int (*rx_available)(struct spi_imx_data *);
 };
 
 #define MXC_SPI_BUF_RX(type)						\
-static void mxc_spi_buf_rx_##type(struct mxc_spi_data *mxc_spi)		\
+static void spi_imx_buf_rx_##type(struct spi_imx_data *spi_imx)		\
 {									\
-	unsigned int val = readl(mxc_spi->base + MXC_CSPIRXDATA);	\
+	unsigned int val = readl(spi_imx->base + MXC_CSPIRXDATA);	\
 									\
-	if (mxc_spi->rx_buf) {						\
-		*(type *)mxc_spi->rx_buf = val;				\
-		mxc_spi->rx_buf += sizeof(type);			\
+	if (spi_imx->rx_buf) {						\
+		*(type *)spi_imx->rx_buf = val;				\
+		spi_imx->rx_buf += sizeof(type);			\
 	}								\
 }
 
 #define MXC_SPI_BUF_TX(type)						\
-static void mxc_spi_buf_tx_##type(struct mxc_spi_data *mxc_spi)		\
+static void spi_imx_buf_tx_##type(struct spi_imx_data *spi_imx)		\
 {									\
 	type val = 0;							\
 									\
-	if (mxc_spi->tx_buf) {						\
-		val = *(type *)mxc_spi->tx_buf;				\
-		mxc_spi->tx_buf += sizeof(type);			\
+	if (spi_imx->tx_buf) {						\
+		val = *(type *)spi_imx->tx_buf;				\
+		spi_imx->tx_buf += sizeof(type);			\
 	}								\
 									\
-	mxc_spi->count -= sizeof(type);					\
+	spi_imx->count -= sizeof(type);					\
 									\
-	writel(val, mxc_spi->base + MXC_CSPITXDATA);			\
+	writel(val, spi_imx->base + MXC_CSPITXDATA);			\
 }
 
 MXC_SPI_BUF_RX(u8)
@@ -119,7 +119,7 @@ static int mxc_clkdivs[] = {0, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128, 192,
 	256, 384, 512, 768, 1024};
 
 /* MX21, MX27 */
-static unsigned int mxc_spi_clkdiv_1(unsigned int fin,
+static unsigned int spi_imx_clkdiv_1(unsigned int fin,
 		unsigned int fspi)
 {
 	int i, max;
@@ -137,7 +137,7 @@ static unsigned int mxc_spi_clkdiv_1(unsigned int fin,
 }
 
 /* MX1, MX31, MX35 */
-static unsigned int mxc_spi_clkdiv_2(unsigned int fin,
+static unsigned int spi_imx_clkdiv_2(unsigned int fin,
 		unsigned int fspi)
 {
 	int i, div = 4;
@@ -174,7 +174,7 @@ static unsigned int mxc_spi_clkdiv_2(unsigned int fin,
  * the i.MX35 has a slightly different register layout for bits
  * we do not use here.
  */
-static void mx31_intctrl(struct mxc_spi_data *mxc_spi, int enable)
+static void mx31_intctrl(struct spi_imx_data *spi_imx, int enable)
 {
 	unsigned int val = 0;
 
@@ -183,24 +183,24 @@ static void mx31_intctrl(struct mxc_spi_data *mxc_spi, int enable)
 	if (enable & MXC_INT_RR)
 		val |= MX31_INTREG_RREN;
 
-	writel(val, mxc_spi->base + MXC_CSPIINT);
+	writel(val, spi_imx->base + MXC_CSPIINT);
 }
 
-static void mx31_trigger(struct mxc_spi_data *mxc_spi)
+static void mx31_trigger(struct spi_imx_data *spi_imx)
 {
 	unsigned int reg;
 
-	reg = readl(mxc_spi->base + MXC_CSPICTRL);
+	reg = readl(spi_imx->base + MXC_CSPICTRL);
 	reg |= MX31_CSPICTRL_XCH;
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
 }
 
-static int mx31_config(struct mxc_spi_data *mxc_spi,
-		struct mxc_spi_config *config)
+static int mx31_config(struct spi_imx_data *spi_imx,
+		struct spi_imx_config *config)
 {
 	unsigned int reg = MX31_CSPICTRL_ENABLE | MX31_CSPICTRL_MASTER;
 
-	reg |= mxc_spi_clkdiv_2(mxc_spi->spi_clk, config->speed_hz) <<
+	reg |= spi_imx_clkdiv_2(spi_imx->spi_clk, config->speed_hz) <<
 		MX31_CSPICTRL_DR_SHIFT;
 
 	if (cpu_is_mx31())
@@ -223,14 +223,14 @@ static int mx31_config(struct mxc_spi_data *mxc_spi,
 			reg |= (config->cs + 32) << MX35_CSPICTRL_CS_SHIFT;
 	}
 
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
 
 	return 0;
 }
 
-static int mx31_rx_available(struct mxc_spi_data *mxc_spi)
+static int mx31_rx_available(struct spi_imx_data *spi_imx)
 {
-	return readl(mxc_spi->base + MX31_CSPISTATUS) & MX31_STATUS_RR;
+	return readl(spi_imx->base + MX31_CSPISTATUS) & MX31_STATUS_RR;
 }
 
 #define MX27_INTREG_RR		(1 << 4)
@@ -246,7 +246,7 @@ static int mx31_rx_available(struct mxc_spi_data *mxc_spi)
 #define MX27_CSPICTRL_DR_SHIFT	14
 #define MX27_CSPICTRL_CS_SHIFT	19
 
-static void mx27_intctrl(struct mxc_spi_data *mxc_spi, int enable)
+static void mx27_intctrl(struct spi_imx_data *spi_imx, int enable)
 {
 	unsigned int val = 0;
 
@@ -255,24 +255,24 @@ static void mx27_intctrl(struct mxc_spi_data *mxc_spi, int enable)
 	if (enable & MXC_INT_RR)
 		val |= MX27_INTREG_RREN;
 
-	writel(val, mxc_spi->base + MXC_CSPIINT);
+	writel(val, spi_imx->base + MXC_CSPIINT);
 }
 
-static void mx27_trigger(struct mxc_spi_data *mxc_spi)
+static void mx27_trigger(struct spi_imx_data *spi_imx)
 {
 	unsigned int reg;
 
-	reg = readl(mxc_spi->base + MXC_CSPICTRL);
+	reg = readl(spi_imx->base + MXC_CSPICTRL);
 	reg |= MX27_CSPICTRL_XCH;
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
 }
 
-static int mx27_config(struct mxc_spi_data *mxc_spi,
-		struct mxc_spi_config *config)
+static int mx27_config(struct spi_imx_data *spi_imx,
+		struct spi_imx_config *config)
 {
 	unsigned int reg = MX27_CSPICTRL_ENABLE | MX27_CSPICTRL_MASTER;
 
-	reg |= mxc_spi_clkdiv_1(mxc_spi->spi_clk, config->speed_hz) <<
+	reg |= spi_imx_clkdiv_1(spi_imx->spi_clk, config->speed_hz) <<
 		MX27_CSPICTRL_DR_SHIFT;
 	reg |= config->bpw - 1;
 
@@ -285,14 +285,14 @@ static int mx27_config(struct mxc_spi_data *mxc_spi,
 	if (config->cs < 0)
 		reg |= (config->cs + 32) << MX27_CSPICTRL_CS_SHIFT;
 
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
 
 	return 0;
 }
 
-static int mx27_rx_available(struct mxc_spi_data *mxc_spi)
+static int mx27_rx_available(struct spi_imx_data *spi_imx)
 {
-	return readl(mxc_spi->base + MXC_CSPIINT) & MX27_INTREG_RR;
+	return readl(spi_imx->base + MXC_CSPIINT) & MX27_INTREG_RR;
 }
 
 #define MX1_INTREG_RR		(1 << 3)
@@ -306,7 +306,7 @@ static int mx27_rx_available(struct mxc_spi_data *mxc_spi)
 #define MX1_CSPICTRL_MASTER	(1 << 10)
 #define MX1_CSPICTRL_DR_SHIFT	13
 
-static void mx1_intctrl(struct mxc_spi_data *mxc_spi, int enable)
+static void mx1_intctrl(struct spi_imx_data *spi_imx, int enable)
 {
 	unsigned int val = 0;
 
@@ -315,24 +315,24 @@ static void mx1_intctrl(struct mxc_spi_data *mxc_spi, int enable)
 	if (enable & MXC_INT_RR)
 		val |= MX1_INTREG_RREN;
 
-	writel(val, mxc_spi->base + MXC_CSPIINT);
+	writel(val, spi_imx->base + MXC_CSPIINT);
 }
 
-static void mx1_trigger(struct mxc_spi_data *mxc_spi)
+static void mx1_trigger(struct spi_imx_data *spi_imx)
 {
 	unsigned int reg;
 
-	reg = readl(mxc_spi->base + MXC_CSPICTRL);
+	reg = readl(spi_imx->base + MXC_CSPICTRL);
 	reg |= MX1_CSPICTRL_XCH;
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
 }
 
-static int mx1_config(struct mxc_spi_data *mxc_spi,
-		struct mxc_spi_config *config)
+static int mx1_config(struct spi_imx_data *spi_imx,
+		struct spi_imx_config *config)
 {
 	unsigned int reg = MX1_CSPICTRL_ENABLE | MX1_CSPICTRL_MASTER;
 
-	reg |= mxc_spi_clkdiv_2(mxc_spi->spi_clk, config->speed_hz) <<
+	reg |= spi_imx_clkdiv_2(spi_imx->spi_clk, config->speed_hz) <<
 		MX1_CSPICTRL_DR_SHIFT;
 	reg |= config->bpw - 1;
 
@@ -341,22 +341,22 @@ static int mx1_config(struct mxc_spi_data *mxc_spi,
 	if (config->mode & SPI_CPOL)
 		reg |= MX1_CSPICTRL_POL;
 
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
 
 	return 0;
 }
 
-static int mx1_rx_available(struct mxc_spi_data *mxc_spi)
+static int mx1_rx_available(struct spi_imx_data *spi_imx)
 {
-	return readl(mxc_spi->base + MXC_CSPIINT) & MX1_INTREG_RR;
+	return readl(spi_imx->base + MXC_CSPIINT) & MX1_INTREG_RR;
 }
 
-static void mxc_spi_chipselect(struct spi_device *spi, int is_active)
+static void spi_imx_chipselect(struct spi_device *spi, int is_active)
 {
-	struct mxc_spi_data *mxc_spi = spi_master_get_devdata(spi->master);
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
 	unsigned int cs = 0;
-	int gpio = mxc_spi->chipselect[spi->chip_select];
-	struct mxc_spi_config config;
+	int gpio = spi_imx->chipselect[spi->chip_select];
+	struct spi_imx_config config;
 
 	if (spi->mode & SPI_CS_HIGH)
 		cs = 1;
@@ -370,20 +370,20 @@ static void mxc_spi_chipselect(struct spi_device *spi, int is_active)
 	config.bpw = spi->bits_per_word;
 	config.speed_hz = spi->max_speed_hz;
 	config.mode = spi->mode;
-	config.cs = mxc_spi->chipselect[spi->chip_select];
+	config.cs = spi_imx->chipselect[spi->chip_select];
 
-	mxc_spi->config(mxc_spi, &config);
+	spi_imx->config(spi_imx, &config);
 
 	/* Initialize the functions for transfer */
 	if (config.bpw <= 8) {
-		mxc_spi->rx = mxc_spi_buf_rx_u8;
-		mxc_spi->tx = mxc_spi_buf_tx_u8;
+		spi_imx->rx = spi_imx_buf_rx_u8;
+		spi_imx->tx = spi_imx_buf_tx_u8;
 	} else if (config.bpw <= 16) {
-		mxc_spi->rx = mxc_spi_buf_rx_u16;
-		mxc_spi->tx = mxc_spi_buf_tx_u16;
+		spi_imx->rx = spi_imx_buf_rx_u16;
+		spi_imx->tx = spi_imx_buf_tx_u16;
 	} else if (config.bpw <= 32) {
-		mxc_spi->rx = mxc_spi_buf_rx_u32;
-		mxc_spi->tx = mxc_spi_buf_tx_u32;
+		spi_imx->rx = spi_imx_buf_rx_u32;
+		spi_imx->tx = spi_imx_buf_tx_u32;
 	} else
 		BUG();
 
@@ -393,83 +393,83 @@ static void mxc_spi_chipselect(struct spi_device *spi, int is_active)
 	return;
 }
 
-static void mxc_spi_push(struct mxc_spi_data *mxc_spi)
+static void spi_imx_push(struct spi_imx_data *spi_imx)
 {
-	while (mxc_spi->txfifo < 8) {
-		if (!mxc_spi->count)
+	while (spi_imx->txfifo < 8) {
+		if (!spi_imx->count)
 			break;
-		mxc_spi->tx(mxc_spi);
-		mxc_spi->txfifo++;
+		spi_imx->tx(spi_imx);
+		spi_imx->txfifo++;
 	}
 
-	mxc_spi->trigger(mxc_spi);
+	spi_imx->trigger(spi_imx);
 }
 
-static irqreturn_t mxc_spi_isr(int irq, void *dev_id)
+static irqreturn_t spi_imx_isr(int irq, void *dev_id)
 {
-	struct mxc_spi_data *mxc_spi = dev_id;
+	struct spi_imx_data *spi_imx = dev_id;
 
-	while (mxc_spi->rx_available(mxc_spi)) {
-		mxc_spi->rx(mxc_spi);
-		mxc_spi->txfifo--;
+	while (spi_imx->rx_available(spi_imx)) {
+		spi_imx->rx(spi_imx);
+		spi_imx->txfifo--;
 	}
 
-	if (mxc_spi->count) {
-		mxc_spi_push(mxc_spi);
+	if (spi_imx->count) {
+		spi_imx_push(spi_imx);
 		return IRQ_HANDLED;
 	}
 
-	if (mxc_spi->txfifo) {
+	if (spi_imx->txfifo) {
 		/* No data left to push, but still waiting for rx data,
 		 * enable receive data available interrupt.
 		 */
-		mxc_spi->intctrl(mxc_spi, MXC_INT_RR);
+		spi_imx->intctrl(spi_imx, MXC_INT_RR);
 		return IRQ_HANDLED;
 	}
 
-	mxc_spi->intctrl(mxc_spi, 0);
-	complete(&mxc_spi->xfer_done);
+	spi_imx->intctrl(spi_imx, 0);
+	complete(&spi_imx->xfer_done);
 
 	return IRQ_HANDLED;
 }
 
-static int mxc_spi_setupxfer(struct spi_device *spi,
+static int spi_imx_setupxfer(struct spi_device *spi,
 				 struct spi_transfer *t)
 {
-	struct mxc_spi_data *mxc_spi = spi_master_get_devdata(spi->master);
-	struct mxc_spi_config config;
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
+	struct spi_imx_config config;
 
 	config.bpw = t ? t->bits_per_word : spi->bits_per_word;
 	config.speed_hz  = t ? t->speed_hz : spi->max_speed_hz;
 	config.mode = spi->mode;
 
-	mxc_spi->config(mxc_spi, &config);
+	spi_imx->config(spi_imx, &config);
 
 	return 0;
 }
 
-static int mxc_spi_transfer(struct spi_device *spi,
+static int spi_imx_transfer(struct spi_device *spi,
 				struct spi_transfer *transfer)
 {
-	struct mxc_spi_data *mxc_spi = spi_master_get_devdata(spi->master);
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
 
-	mxc_spi->tx_buf = transfer->tx_buf;
-	mxc_spi->rx_buf = transfer->rx_buf;
-	mxc_spi->count = transfer->len;
-	mxc_spi->txfifo = 0;
+	spi_imx->tx_buf = transfer->tx_buf;
+	spi_imx->rx_buf = transfer->rx_buf;
+	spi_imx->count = transfer->len;
+	spi_imx->txfifo = 0;
 
-	init_completion(&mxc_spi->xfer_done);
+	init_completion(&spi_imx->xfer_done);
 
-	mxc_spi_push(mxc_spi);
+	spi_imx_push(spi_imx);
 
-	mxc_spi->intctrl(mxc_spi, MXC_INT_TE);
+	spi_imx->intctrl(spi_imx, MXC_INT_TE);
 
-	wait_for_completion(&mxc_spi->xfer_done);
+	wait_for_completion(&spi_imx->xfer_done);
 
 	return transfer->len;
 }
 
-static int mxc_spi_setup(struct spi_device *spi)
+static int spi_imx_setup(struct spi_device *spi)
 {
 	if (!spi->bits_per_word)
 		spi->bits_per_word = 8;
@@ -477,20 +477,20 @@ static int mxc_spi_setup(struct spi_device *spi)
 	pr_debug("%s: mode %d, %u bpw, %d hz\n", __func__,
 		 spi->mode, spi->bits_per_word, spi->max_speed_hz);
 
-	mxc_spi_chipselect(spi, BITBANG_CS_INACTIVE);
+	spi_imx_chipselect(spi, BITBANG_CS_INACTIVE);
 
 	return 0;
 }
 
-static void mxc_spi_cleanup(struct spi_device *spi)
+static void spi_imx_cleanup(struct spi_device *spi)
 {
 }
 
-static int __init mxc_spi_probe(struct platform_device *pdev)
+static int __init spi_imx_probe(struct platform_device *pdev)
 {
 	struct spi_imx_master *mxc_platform_info;
 	struct spi_master *master;
-	struct mxc_spi_data *mxc_spi;
+	struct spi_imx_data *spi_imx;
 	struct resource *res;
 	int i, ret;
 
@@ -500,7 +500,7 @@ static int __init mxc_spi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct mxc_spi_data));
+	master = spi_alloc_master(&pdev->dev, sizeof(struct spi_imx_data));
 	if (!master)
 		return -ENOMEM;
 
@@ -509,32 +509,32 @@ static int __init mxc_spi_probe(struct platform_device *pdev)
 	master->bus_num = pdev->id;
 	master->num_chipselect = mxc_platform_info->num_chipselect;
 
-	mxc_spi = spi_master_get_devdata(master);
-	mxc_spi->bitbang.master = spi_master_get(master);
-	mxc_spi->chipselect = mxc_platform_info->chipselect;
+	spi_imx = spi_master_get_devdata(master);
+	spi_imx->bitbang.master = spi_master_get(master);
+	spi_imx->chipselect = mxc_platform_info->chipselect;
 
 	for (i = 0; i < master->num_chipselect; i++) {
-		if (mxc_spi->chipselect[i] < 0)
+		if (spi_imx->chipselect[i] < 0)
 			continue;
-		ret = gpio_request(mxc_spi->chipselect[i], DRIVER_NAME);
+		ret = gpio_request(spi_imx->chipselect[i], DRIVER_NAME);
 		if (ret) {
 			i--;
 			while (i > 0)
-				if (mxc_spi->chipselect[i] >= 0)
-					gpio_free(mxc_spi->chipselect[i--]);
+				if (spi_imx->chipselect[i] >= 0)
+					gpio_free(spi_imx->chipselect[i--]);
 			dev_err(&pdev->dev, "can't get cs gpios");
 			goto out_master_put;
 		}
-		gpio_direction_output(mxc_spi->chipselect[i], 1);
+		gpio_direction_output(spi_imx->chipselect[i], 1);
 	}
 
-	mxc_spi->bitbang.chipselect = mxc_spi_chipselect;
-	mxc_spi->bitbang.setup_transfer = mxc_spi_setupxfer;
-	mxc_spi->bitbang.txrx_bufs = mxc_spi_transfer;
-	mxc_spi->bitbang.master->setup = mxc_spi_setup;
-	mxc_spi->bitbang.master->cleanup = mxc_spi_cleanup;
+	spi_imx->bitbang.chipselect = spi_imx_chipselect;
+	spi_imx->bitbang.setup_transfer = spi_imx_setupxfer;
+	spi_imx->bitbang.txrx_bufs = spi_imx_transfer;
+	spi_imx->bitbang.master->setup = spi_imx_setup;
+	spi_imx->bitbang.master->cleanup = spi_imx_cleanup;
 
-	init_completion(&mxc_spi->xfer_done);
+	init_completion(&spi_imx->xfer_done);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -549,58 +549,58 @@ static int __init mxc_spi_probe(struct platform_device *pdev)
 		goto out_gpio_free;
 	}
 
-	mxc_spi->base = ioremap(res->start, resource_size(res));
-	if (!mxc_spi->base) {
+	spi_imx->base = ioremap(res->start, resource_size(res));
+	if (!spi_imx->base) {
 		ret = -EINVAL;
 		goto out_release_mem;
 	}
 
-	mxc_spi->irq = platform_get_irq(pdev, 0);
-	if (!mxc_spi->irq) {
+	spi_imx->irq = platform_get_irq(pdev, 0);
+	if (!spi_imx->irq) {
 		ret = -EINVAL;
 		goto out_iounmap;
 	}
 
-	ret = request_irq(mxc_spi->irq, mxc_spi_isr, 0, DRIVER_NAME, mxc_spi);
+	ret = request_irq(spi_imx->irq, spi_imx_isr, 0, DRIVER_NAME, spi_imx);
 	if (ret) {
-		dev_err(&pdev->dev, "can't get irq%d: %d\n", mxc_spi->irq, ret);
+		dev_err(&pdev->dev, "can't get irq%d: %d\n", spi_imx->irq, ret);
 		goto out_iounmap;
 	}
 
 	if (cpu_is_mx31() || cpu_is_mx35()) {
-		mxc_spi->intctrl = mx31_intctrl;
-		mxc_spi->config = mx31_config;
-		mxc_spi->trigger = mx31_trigger;
-		mxc_spi->rx_available = mx31_rx_available;
+		spi_imx->intctrl = mx31_intctrl;
+		spi_imx->config = mx31_config;
+		spi_imx->trigger = mx31_trigger;
+		spi_imx->rx_available = mx31_rx_available;
 	} else  if (cpu_is_mx27() || cpu_is_mx21()) {
-		mxc_spi->intctrl = mx27_intctrl;
-		mxc_spi->config = mx27_config;
-		mxc_spi->trigger = mx27_trigger;
-		mxc_spi->rx_available = mx27_rx_available;
+		spi_imx->intctrl = mx27_intctrl;
+		spi_imx->config = mx27_config;
+		spi_imx->trigger = mx27_trigger;
+		spi_imx->rx_available = mx27_rx_available;
 	} else if (cpu_is_mx1()) {
-		mxc_spi->intctrl = mx1_intctrl;
-		mxc_spi->config = mx1_config;
-		mxc_spi->trigger = mx1_trigger;
-		mxc_spi->rx_available = mx1_rx_available;
+		spi_imx->intctrl = mx1_intctrl;
+		spi_imx->config = mx1_config;
+		spi_imx->trigger = mx1_trigger;
+		spi_imx->rx_available = mx1_rx_available;
 	} else
 		BUG();
 
-	mxc_spi->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(mxc_spi->clk)) {
+	spi_imx->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(spi_imx->clk)) {
 		dev_err(&pdev->dev, "unable to get clock\n");
-		ret = PTR_ERR(mxc_spi->clk);
+		ret = PTR_ERR(spi_imx->clk);
 		goto out_free_irq;
 	}
 
-	clk_enable(mxc_spi->clk);
-	mxc_spi->spi_clk = clk_get_rate(mxc_spi->clk);
+	clk_enable(spi_imx->clk);
+	spi_imx->spi_clk = clk_get_rate(spi_imx->clk);
 
 	if (!cpu_is_mx31() || !cpu_is_mx35())
-		writel(1, mxc_spi->base + MXC_RESET);
+		writel(1, spi_imx->base + MXC_RESET);
 
-	mxc_spi->intctrl(mxc_spi, 0);
+	spi_imx->intctrl(spi_imx, 0);
 
-	ret = spi_bitbang_start(&mxc_spi->bitbang);
+	ret = spi_bitbang_start(&spi_imx->bitbang);
 	if (ret) {
 		dev_err(&pdev->dev, "bitbang start failed with %d\n", ret);
 		goto out_clk_put;
@@ -611,18 +611,18 @@ static int __init mxc_spi_probe(struct platform_device *pdev)
 	return ret;
 
 out_clk_put:
-	clk_disable(mxc_spi->clk);
-	clk_put(mxc_spi->clk);
+	clk_disable(spi_imx->clk);
+	clk_put(spi_imx->clk);
 out_free_irq:
-	free_irq(mxc_spi->irq, mxc_spi);
+	free_irq(spi_imx->irq, spi_imx);
 out_iounmap:
-	iounmap(mxc_spi->base);
+	iounmap(spi_imx->base);
 out_release_mem:
 	release_mem_region(res->start, resource_size(res));
 out_gpio_free:
 	for (i = 0; i < master->num_chipselect; i++)
-		if (mxc_spi->chipselect[i] >= 0)
-			gpio_free(mxc_spi->chipselect[i]);
+		if (spi_imx->chipselect[i] >= 0)
+			gpio_free(spi_imx->chipselect[i]);
 out_master_put:
 	spi_master_put(master);
 	kfree(master);
@@ -630,24 +630,24 @@ out_master_put:
 	return ret;
 }
 
-static int __exit mxc_spi_remove(struct platform_device *pdev)
+static int __exit spi_imx_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	struct mxc_spi_data *mxc_spi = spi_master_get_devdata(master);
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(master);
 	int i;
 
-	spi_bitbang_stop(&mxc_spi->bitbang);
+	spi_bitbang_stop(&spi_imx->bitbang);
 
-	writel(0, mxc_spi->base + MXC_CSPICTRL);
-	clk_disable(mxc_spi->clk);
-	clk_put(mxc_spi->clk);
-	free_irq(mxc_spi->irq, mxc_spi);
-	iounmap(mxc_spi->base);
+	writel(0, spi_imx->base + MXC_CSPICTRL);
+	clk_disable(spi_imx->clk);
+	clk_put(spi_imx->clk);
+	free_irq(spi_imx->irq, spi_imx);
+	iounmap(spi_imx->base);
 
 	for (i = 0; i < master->num_chipselect; i++)
-		if (mxc_spi->chipselect[i] >= 0)
-			gpio_free(mxc_spi->chipselect[i]);
+		if (spi_imx->chipselect[i] >= 0)
+			gpio_free(spi_imx->chipselect[i]);
 
 	spi_master_put(master);
 
@@ -658,27 +658,27 @@ static int __exit mxc_spi_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver mxc_spi_driver = {
+static struct platform_driver spi_imx_driver = {
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .owner = THIS_MODULE,
 		   },
-	.probe = mxc_spi_probe,
-	.remove = __exit_p(mxc_spi_remove),
+	.probe = spi_imx_probe,
+	.remove = __exit_p(spi_imx_remove),
 };
 
-static int __init mxc_spi_init(void)
+static int __init spi_imx_init(void)
 {
-	return platform_driver_register(&mxc_spi_driver);
+	return platform_driver_register(&spi_imx_driver);
 }
 
-static void __exit mxc_spi_exit(void)
+static void __exit spi_imx_exit(void)
 {
-	platform_driver_unregister(&mxc_spi_driver);
+	platform_driver_unregister(&spi_imx_driver);
 }
 
-module_init(mxc_spi_init);
-module_exit(mxc_spi_exit);
+module_init(spi_imx_init);
+module_exit(spi_imx_exit);
 
 MODULE_DESCRIPTION("SPI Master Controller driver");
 MODULE_AUTHOR("Sascha Hauer, Pengutronix");
-- 
1.6.4.3

