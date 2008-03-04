Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYCDDLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYCDDLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYCDDJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:09:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:11850 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbYCDDJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:09:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UX17oejaK4YkWQe/0L5NGe+FMB/jqFlCI5ewhQq2pZHkbwBYPMPfNs5XQsDfBm+hNim9K42ViPPh4eqJZfpT7+9txbwvYsJsbUjVcPNIEFC+RHRvtqOiBv9YW7w39/RnnO1bd5LlNXz+dbbV6ykOADqh9WQ8hh5BkXMT3uyivhQ=
Subject: [PATCH 04/14] i2c: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:44 -0800
Message-Id: <1204600184.22933.84.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/i2c/busses/i2c-davinci.c |    6 ++--
 drivers/i2c/busses/i2c-pmcmsp.c  |    4 +-
 drivers/i2c/busses/i2c-pnx.c     |   44 +++++++++++++++++++-------------------
 drivers/i2c/busses/i2c-pxa.c     |    2 +-
 drivers/i2c/busses/i2c-s3c2410.c |    4 +-
 drivers/i2c/chips/isp1301_omap.c |   28 ++++++++++++------------
 drivers/i2c/i2c-core.c           |    2 +-
 7 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index cce5a61..89c697d 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -328,7 +328,7 @@ i2c_davinci_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	int i;
 	int ret;
 
-	dev_dbg(dev->dev, "%s: msgs: %d\n", __FUNCTION__, num);
+	dev_dbg(dev->dev, "%s: msgs: %d\n", __func__, num);
 
 	ret = i2c_davinci_wait_bus_not_busy(dev, 1);
 	if (ret < 0) {
@@ -342,7 +342,7 @@ i2c_davinci_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 			return ret;
 	}
 
-	dev_dbg(dev->dev, "%s:%d ret: %d\n", __FUNCTION__, __LINE__, ret);
+	dev_dbg(dev->dev, "%s:%d ret: %d\n", __func__, __LINE__, ret);
 
 	return num;
 }
@@ -364,7 +364,7 @@ static irqreturn_t i2c_davinci_isr(int this_irq, void *dev_id)
 	u16 w;
 
 	while ((stat = davinci_i2c_read_reg(dev, DAVINCI_I2C_IVR_REG))) {
-		dev_dbg(dev->dev, "%s: stat=0x%x\n", __FUNCTION__, stat);
+		dev_dbg(dev->dev, "%s: stat=0x%x\n", __func__, stat);
 		if (count++ == 100) {
 			dev_warn(dev->dev, "Too much work in one IRQ\n");
 			break;
diff --git a/drivers/i2c/busses/i2c-pmcmsp.c b/drivers/i2c/busses/i2c-pmcmsp.c
index b03af56..9ea0f8a 100644
--- a/drivers/i2c/busses/i2c-pmcmsp.c
+++ b/drivers/i2c/busses/i2c-pmcmsp.c
@@ -467,7 +467,7 @@ static enum pmcmsptwi_xfer_result pmcmsptwi_xfer_cmd(
 	    (cmd->read_len == 0 || cmd->write_len == 0))) {
 		dev_err(&pmcmsptwi_adapter.dev,
 			"%s: Cannot transfer less than 1 byte\n",
-			__FUNCTION__);
+			__func__);
 		return -EINVAL;
 	}
 
@@ -475,7 +475,7 @@ static enum pmcmsptwi_xfer_result pmcmsptwi_xfer_cmd(
 	    cmd->write_len > MSP_MAX_BYTES_PER_RW) {
 		dev_err(&pmcmsptwi_adapter.dev,
 			"%s: Cannot transfer more than %d bytes\n",
-			__FUNCTION__, MSP_MAX_BYTES_PER_RW);
+			__func__, MSP_MAX_BYTES_PER_RW);
 		return -EINVAL;
 	}
 
diff --git a/drivers/i2c/busses/i2c-pnx.c b/drivers/i2c/busses/i2c-pnx.c
index f8d0dff..6695d59 100644
--- a/drivers/i2c/busses/i2c-pnx.c
+++ b/drivers/i2c/busses/i2c-pnx.c
@@ -76,7 +76,7 @@ static int i2c_pnx_start(unsigned char slave_addr, struct i2c_adapter *adap)
 {
 	struct i2c_pnx_algo_data *alg_data = adap->algo_data;
 
-	dev_dbg(&adap->dev, "%s(): addr 0x%x mode %d\n", __FUNCTION__,
+	dev_dbg(&adap->dev, "%s(): addr 0x%x mode %d\n", __func__,
 		slave_addr, alg_data->mif.mode);
 
 	/* Check for 7 bit slave addresses only */
@@ -110,14 +110,14 @@ static int i2c_pnx_start(unsigned char slave_addr, struct i2c_adapter *adap)
 	iowrite32(ioread32(I2C_REG_STS(alg_data)) | mstatus_tdi | mstatus_afi,
 		  I2C_REG_STS(alg_data));
 
-	dev_dbg(&adap->dev, "%s(): sending %#x\n", __FUNCTION__,
+	dev_dbg(&adap->dev, "%s(): sending %#x\n", __func__,
 		(slave_addr << 1) | start_bit | alg_data->mif.mode);
 
 	/* Write the slave address, START bit and R/W bit */
 	iowrite32((slave_addr << 1) | start_bit | alg_data->mif.mode,
 		  I2C_REG_TX(alg_data));
 
-	dev_dbg(&adap->dev, "%s(): exit\n", __FUNCTION__);
+	dev_dbg(&adap->dev, "%s(): exit\n", __func__);
 
 	return 0;
 }
@@ -135,7 +135,7 @@ static void i2c_pnx_stop(struct i2c_adapter *adap)
 	long timeout = 1000;
 
 	dev_dbg(&adap->dev, "%s(): entering: stat = %04x.\n",
-		__FUNCTION__, ioread32(I2C_REG_STS(alg_data)));
+		__func__, ioread32(I2C_REG_STS(alg_data)));
 
 	/* Write a STOP bit to TX FIFO */
 	iowrite32(0xff | stop_bit, I2C_REG_TX(alg_data));
@@ -149,7 +149,7 @@ static void i2c_pnx_stop(struct i2c_adapter *adap)
 	}
 
 	dev_dbg(&adap->dev, "%s(): exiting: stat = %04x.\n",
-		__FUNCTION__, ioread32(I2C_REG_STS(alg_data)));
+		__func__, ioread32(I2C_REG_STS(alg_data)));
 }
 
 /**
@@ -164,7 +164,7 @@ static int i2c_pnx_master_xmit(struct i2c_adapter *adap)
 	u32 val;
 
 	dev_dbg(&adap->dev, "%s(): entering: stat = %04x.\n",
-		__FUNCTION__, ioread32(I2C_REG_STS(alg_data)));
+		__func__, ioread32(I2C_REG_STS(alg_data)));
 
 	if (alg_data->mif.len > 0) {
 		/* We still have something to talk about... */
@@ -179,7 +179,7 @@ static int i2c_pnx_master_xmit(struct i2c_adapter *adap)
 		alg_data->mif.len--;
 		iowrite32(val, I2C_REG_TX(alg_data));
 
-		dev_dbg(&adap->dev, "%s(): xmit %#x [%d]\n", __FUNCTION__,
+		dev_dbg(&adap->dev, "%s(): xmit %#x [%d]\n", __func__,
 			val, alg_data->mif.len + 1);
 
 		if (alg_data->mif.len == 0) {
@@ -197,7 +197,7 @@ static int i2c_pnx_master_xmit(struct i2c_adapter *adap)
 			del_timer_sync(&alg_data->mif.timer);
 
 			dev_dbg(&adap->dev, "%s(): Waking up xfer routine.\n",
-				__FUNCTION__);
+				__func__);
 
 			complete(&alg_data->mif.complete);
 		}
@@ -213,13 +213,13 @@ static int i2c_pnx_master_xmit(struct i2c_adapter *adap)
 		/* Stop timer. */
 		del_timer_sync(&alg_data->mif.timer);
 		dev_dbg(&adap->dev, "%s(): Waking up xfer routine after "
-			"zero-xfer.\n", __FUNCTION__);
+			"zero-xfer.\n", __func__);
 
 		complete(&alg_data->mif.complete);
 	}
 
 	dev_dbg(&adap->dev, "%s(): exiting: stat = %04x.\n",
-		__FUNCTION__, ioread32(I2C_REG_STS(alg_data)));
+		__func__, ioread32(I2C_REG_STS(alg_data)));
 
 	return 0;
 }
@@ -237,14 +237,14 @@ static int i2c_pnx_master_rcv(struct i2c_adapter *adap)
 	u32 ctl = 0;
 
 	dev_dbg(&adap->dev, "%s(): entering: stat = %04x.\n",
-		__FUNCTION__, ioread32(I2C_REG_STS(alg_data)));
+		__func__, ioread32(I2C_REG_STS(alg_data)));
 
 	/* Check, whether there is already data,
 	 * or we didn't 'ask' for it yet.
 	 */
 	if (ioread32(I2C_REG_STS(alg_data)) & mstatus_rfe) {
 		dev_dbg(&adap->dev, "%s(): Write dummy data to fill "
-			"Rx-fifo...\n", __FUNCTION__);
+			"Rx-fifo...\n", __func__);
 
 		if (alg_data->mif.len == 1) {
 			/* Last byte, do not acknowledge next rcv. */
@@ -276,7 +276,7 @@ static int i2c_pnx_master_rcv(struct i2c_adapter *adap)
 	if (alg_data->mif.len > 0) {
 		val = ioread32(I2C_REG_RX(alg_data));
 		*alg_data->mif.buf++ = (u8) (val & 0xff);
-		dev_dbg(&adap->dev, "%s(): rcv 0x%x [%d]\n", __FUNCTION__, val,
+		dev_dbg(&adap->dev, "%s(): rcv 0x%x [%d]\n", __func__, val,
 			alg_data->mif.len);
 
 		alg_data->mif.len--;
@@ -300,7 +300,7 @@ static int i2c_pnx_master_rcv(struct i2c_adapter *adap)
 	}
 
 	dev_dbg(&adap->dev, "%s(): exiting: stat = %04x.\n",
-		__FUNCTION__, ioread32(I2C_REG_STS(alg_data)));
+		__func__, ioread32(I2C_REG_STS(alg_data)));
 
 	return 0;
 }
@@ -312,7 +312,7 @@ static irqreturn_t i2c_pnx_interrupt(int irq, void *dev_id)
 	struct i2c_pnx_algo_data *alg_data = adap->algo_data;
 
 	dev_dbg(&adap->dev, "%s(): mstat = %x mctrl = %x, mode = %d\n",
-		__FUNCTION__,
+		__func__,
 		ioread32(I2C_REG_STS(alg_data)),
 		ioread32(I2C_REG_CTL(alg_data)),
 		alg_data->mif.mode);
@@ -336,7 +336,7 @@ static irqreturn_t i2c_pnx_interrupt(int irq, void *dev_id)
 		/* Slave did not acknowledge, generate a STOP */
 		dev_dbg(&adap->dev, "%s(): "
 			"Slave did not acknowledge, generating a STOP.\n",
-			__FUNCTION__);
+			__func__);
 		i2c_pnx_stop(adap);
 
 		/* Disable master interrupts. */
@@ -375,7 +375,7 @@ static irqreturn_t i2c_pnx_interrupt(int irq, void *dev_id)
 	iowrite32(stat | mstatus_tdi | mstatus_afi, I2C_REG_STS(alg_data));
 
 	dev_dbg(&adap->dev, "%s(): exiting, stat = %x ctrl = %x.\n",
-		 __FUNCTION__, ioread32(I2C_REG_STS(alg_data)),
+		 __func__, ioread32(I2C_REG_STS(alg_data)),
 		 ioread32(I2C_REG_CTL(alg_data)));
 
 	return IRQ_HANDLED;
@@ -447,7 +447,7 @@ i2c_pnx_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	u32 stat = ioread32(I2C_REG_STS(alg_data));
 
 	dev_dbg(&adap->dev, "%s(): entering: %d messages, stat = %04x.\n",
-		__FUNCTION__, num, ioread32(I2C_REG_STS(alg_data)));
+		__func__, num, ioread32(I2C_REG_STS(alg_data)));
 
 	bus_reset_if_active(adap);
 
@@ -473,7 +473,7 @@ i2c_pnx_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 		alg_data->mif.ret = 0;
 		alg_data->last = (i == num - 1);
 
-		dev_dbg(&adap->dev, "%s(): mode %d, %d bytes\n", __FUNCTION__,
+		dev_dbg(&adap->dev, "%s(): mode %d, %d bytes\n", __func__,
 			alg_data->mif.mode,
 			alg_data->mif.len);
 
@@ -498,7 +498,7 @@ i2c_pnx_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 		if (!(rc = alg_data->mif.ret))
 			completed++;
 		dev_dbg(&adap->dev, "%s(): Complete, return code = %d.\n",
-			__FUNCTION__, rc);
+			__func__, rc);
 
 		/* Clear TDI and AFI bits in case they are set. */
 		if ((stat = ioread32(I2C_REG_STS(alg_data))) & mstatus_tdi) {
@@ -522,7 +522,7 @@ i2c_pnx_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	alg_data->mif.len = 0;
 
 	dev_dbg(&adap->dev, "%s(): exiting, stat = %x\n",
-		__FUNCTION__, ioread32(I2C_REG_STS(alg_data)));
+		__func__, ioread32(I2C_REG_STS(alg_data)));
 
 	if (completed != num)
 		return ((rc < 0) ? rc : -EREMOTEIO);
@@ -563,7 +563,7 @@ static int __devinit i2c_pnx_probe(struct platform_device *pdev)
 
 	if (!i2c_pnx || !i2c_pnx->adapter) {
 		dev_err(&pdev->dev, "%s: no platform data supplied\n",
-		       __FUNCTION__);
+		       __func__);
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 2d2087a..43fef50 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -154,7 +154,7 @@ static void i2c_pxa_show_state(struct pxa_i2c *i2c, int lno, const char *fname)
 		readl(_ISR(i2c)), readl(_ICR(i2c)), readl(_IBMR(i2c)));
 }
 
-#define show_state(i2c) i2c_pxa_show_state(i2c, __LINE__, __FUNCTION__)
+#define show_state(i2c) i2c_pxa_show_state(i2c, __LINE__, __func__)
 #else
 #define i2c_debug	0
 
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index c44ada5..5ece33e 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -276,12 +276,12 @@ static int i2s_s3c_irq_nextbyte(struct s3c24xx_i2c *i2c, unsigned long iicstat)
 	switch (i2c->state) {
 
 	case STATE_IDLE:
-		dev_err(i2c->dev, "%s: called in STATE_IDLE\n", __FUNCTION__);
+		dev_err(i2c->dev, "%s: called in STATE_IDLE\n", __func__);
 		goto out;
 		break;
 
 	case STATE_STOP:
-		dev_err(i2c->dev, "%s: called in STATE_STOP\n", __FUNCTION__);
+		dev_err(i2c->dev, "%s: called in STATE_STOP\n", __func__);
 		s3c24xx_i2c_disable_irq(i2c);		
 		goto out_ack;
 
diff --git a/drivers/i2c/chips/isp1301_omap.c b/drivers/i2c/chips/isp1301_omap.c
index 2a31601..b1b45dd 100644
--- a/drivers/i2c/chips/isp1301_omap.c
+++ b/drivers/i2c/chips/isp1301_omap.c
@@ -658,7 +658,7 @@ pulldown:
 		OTG_CTRL_REG |= OTG_PULLUP;
 	}
 
-	check_state(isp, __FUNCTION__);
+	check_state(isp, __func__);
 	dump_regs(isp, "otg->isp1301");
 }
 
@@ -782,7 +782,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		if (otg_ctrl & OTG_DRIVER_SEL) {
 			switch (isp->otg.state) {
 			case OTG_STATE_A_IDLE:
-				b_idle(isp, __FUNCTION__);
+				b_idle(isp, __func__);
 				break;
 			default:
 				break;
@@ -826,7 +826,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 						isp->otg.host->otg_port);
 	}
 
-	check_state(isp, __FUNCTION__);
+	check_state(isp, __func__);
 	return ret;
 }
 
@@ -837,7 +837,7 @@ static int otg_init(struct isp1301 *isp)
 	if (!otg_dev)
 		return -ENODEV;
 
-	dump_regs(isp, __FUNCTION__);
+	dump_regs(isp, __func__);
 	/* some of these values are board-specific... */
 	OTG_SYSCON_2_REG |= OTG_EN
 		/* for B-device: */
@@ -853,9 +853,9 @@ static int otg_init(struct isp1301 *isp)
 	update_otg1(isp, isp1301_get_u8(isp, ISP1301_INTERRUPT_SOURCE));
 	update_otg2(isp, isp1301_get_u8(isp, ISP1301_OTG_STATUS));
 
-	check_state(isp, __FUNCTION__);
+	check_state(isp, __func__);
 	pr_debug("otg: %s, %s %06x\n",
-			state_name(isp), __FUNCTION__, OTG_CTRL_REG);
+			state_name(isp), __func__, OTG_CTRL_REG);
 
 	OTG_IRQ_EN_REG = DRIVER_SWITCH | OPRT_CHG
 			| B_SRP_TMROUT | B_HNP_FAIL
@@ -1041,11 +1041,11 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 						OTG1_DP_PULLDOWN);
 			isp1301_clear_bits(isp, ISP1301_OTG_CONTROL_1,
 						OTG1_DP_PULLUP);
-			dump_regs(isp, __FUNCTION__);
+			dump_regs(isp, __func__);
 #endif
 			/* FALLTHROUGH */
 		case OTG_STATE_B_SRP_INIT:
-			b_idle(isp, __FUNCTION__);
+			b_idle(isp, __func__);
 			OTG_CTRL_REG &= OTG_CTRL_REG & OTG_XCEIV_OUTPUTS;
 			/* FALLTHROUGH */
 		case OTG_STATE_B_IDLE:
@@ -1077,7 +1077,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 	 */
 	update_otg1(isp, isp_stat);
 	update_otg2(isp, isp_bstat);
-	check_state(isp, __FUNCTION__);
+	check_state(isp, __func__);
 #endif
 
 	dump_regs(isp, "isp1301->otg");
@@ -1310,7 +1310,7 @@ isp1301_set_host(struct otg_transceiver *otg, struct usb_bus *host)
 	 */
 	isp1301_set_bits(isp, ISP1301_OTG_CONTROL_1, OTG1_VBUS_DRV);
 
-	dump_regs(isp, __FUNCTION__);
+	dump_regs(isp, __func__);
 
 	return 0;
 
@@ -1365,7 +1365,7 @@ isp1301_set_peripheral(struct otg_transceiver *otg, struct usb_gadget *gadget)
 	isp1301_set_bits(isp, ISP1301_INTERRUPT_FALLING,
 		INTR_VBUS_VLD);
 	dev_info(&isp->client.dev, "B-Peripheral sessions ok\n");
-	dump_regs(isp, __FUNCTION__);
+	dump_regs(isp, __func__);
 
 	/* If this has a Mini-AB connector, this mode is highly
 	 * nonstandard ... but can be handy for testing, so long
@@ -1416,7 +1416,7 @@ isp1301_start_srp(struct otg_transceiver *dev)
 
 	pr_debug("otg: SRP, %s ... %06x\n", state_name(isp), OTG_CTRL_REG);
 #ifdef	CONFIG_USB_OTG
-	check_state(isp, __FUNCTION__);
+	check_state(isp, __func__);
 #endif
 	return 0;
 }
@@ -1463,7 +1463,7 @@ isp1301_start_hnp(struct otg_transceiver *dev)
 	}
 	pr_debug("otg: HNP %s, %06x ...\n",
 		state_name(isp), OTG_CTRL_REG);
-	check_state(isp, __FUNCTION__);
+	check_state(isp, __func__);
 	return 0;
 #else
 	/* srp-only */
@@ -1601,7 +1601,7 @@ fail2:
 	update_otg2(isp, isp1301_get_u8(isp, ISP1301_OTG_STATUS));
 #endif
 
-	dump_regs(isp, __FUNCTION__);
+	dump_regs(isp, __func__);
 
 #ifdef	VERBOSE
 	mod_timer(&isp->timer, jiffies + TIMER_JIFFIES);
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 96da22e..6cb4502 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1502,7 +1502,7 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter * adapter, u16 addr,
 		read_write = I2C_SMBUS_READ;
 		if (data->block[0] > I2C_SMBUS_BLOCK_MAX) {
 			dev_err(&adapter->dev, "%s called with invalid "
-				"block proc call size (%d)\n", __FUNCTION__,
+				"block proc call size (%d)\n", __func__,
 				data->block[0]);
 			return -1;
 		}
-- 
1.5.4.3.500.g83a2c


