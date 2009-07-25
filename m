Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbZGYLf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbZGYLf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 07:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZGYLfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 07:35:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49691 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbZGYLfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 07:35:23 -0400
Message-ID: <4A6AEDFD.7040508@nokia.com>
Date: Sat, 25 Jul 2009 14:35:25 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Madhusudhan <madhu.cr@ti.com>
CC: "'Linus Walleij'" <linus.walleij@stericsson.com>,
       "'Linus Walleij'" <linus.ml.walleij@gmail.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "'Pierre Ossman'" <pierre@ossman.eu>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "'David Vrabel'" <david.vrabel@csr.com>,
       "marek.vasut@gmail.com" <marek.vasut@gmail.com>
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>	 <4A6701E3.3000204@csr.com> <63386a3d0907221533u6ab2738dpcb4484595ae757b0@mail.gmail.com> <4A68709E.5060207@csr.com> <4A68A8D9.1020207@nokia.com> <008801ca0caa$832f9df0$544ff780@am.dhcp.ti.com>
In-Reply-To: <008801ca0caa$832f9df0$544ff780@am.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2009 11:34:51.0223 (UTC) FILETIME=[EC3DC670:01CA0D1B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Madhusudhan wrote:
> Hi Adrian,
> 
> The patch #28 "The omap hsmmc driver code refactoring" in the series does
> not seem to apply.

Yes in my mailbox too, it has tabs replaced by spaces.
Here is another copy.

> 
> Regards,
> Madhu 
> 
>> -----Original Message-----
>> From: Adrian Hunter [mailto:adrian.hunter@nokia.com]
>> Sent: Thursday, July 23, 2009 1:16 PM
>> To: Linus Walleij
>> Cc: Linus Walleij; Andrew Morton; linux-kernel@vger.kernel.org; Pierre
>> Ossman; linux-arm-kernel@lists.arm.linux.org.uk; David Vrabel;
>> marek.vasut@gmail.com; Madhusudhan Chikkature
>> Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
>>
>> Hi
>>
>> Have you considered using our enable/disable approach instead?
>>
>> It is here:
>>
>> http://groups.google.com/group/linux.kernel/browse_frm/thread/a5caec1de127
>> 4be5/2ba7dee2a187a268
>>
>> Perhaps it meets your needs, whereas your patches do not seem
>> to cover the functionality we need.
>>
>> Regards
>> Adrian Hunter
> 
> 
> 

>From 10908c5264a19de415af6406ee19ef2bd68928c6 Mon Sep 17 00:00:00 2001
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Date: Mon, 18 May 2009 13:29:18 +0300
Subject: [PATCH] omap_hsmmc: code refactoring

Functions', structures', variables' names are changed to start
with omap_hsmmc_ prefix.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/mmc/host/omap_hsmmc.c |  322 +++++++++++++++++++++--------------------
 1 files changed, 162 insertions(+), 160 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index fa5f401..5055d52 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -133,7 +133,7 @@
 #define OMAP_HSMMC_WRITE(base, reg, val) \
 	__raw_writel((val), (base) + OMAP_HSMMC_##reg)
 
-struct mmc_omap_host {
+struct omap_hsmmc_host {
 	struct	device		*dev;
 	struct	mmc_host	*mmc;
 	struct	mmc_request	*mrq;
@@ -170,7 +170,7 @@ struct mmc_omap_host {
 /*
  * Stop clock to the card
  */
-static void omap_mmc_stop_clock(struct mmc_omap_host *host)
+static void omap_hsmmc_stop_clock(struct omap_hsmmc_host *host)
 {
 	OMAP_HSMMC_WRITE(host->base, SYSCTL,
 		OMAP_HSMMC_READ(host->base, SYSCTL) & ~CEN);
@@ -184,7 +184,7 @@ static void omap_mmc_stop_clock(struct mmc_omap_host *host)
  * Restore the MMC host context, if it was lost as result of a
  * power state change.
  */
-static int omap_mmc_restore_ctx(struct mmc_omap_host *host)
+static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 {
 	struct mmc_ios *ios = &host->mmc->ios;
 	struct omap_mmc_platform_data *pdata = host->pdata;
@@ -312,7 +312,7 @@ out:
 /*
  * Save the MMC host context (store the number of power state changes so far).
  */
-static void omap_mmc_save_ctx(struct mmc_omap_host *host)
+static void omap_hsmmc_context_save(struct omap_hsmmc_host *host)
 {
 	struct omap_mmc_platform_data *pdata = host->pdata;
 	int context_loss;
@@ -327,12 +327,12 @@ static void omap_mmc_save_ctx(struct mmc_omap_host *host)
 
 #else
 
-static int omap_mmc_restore_ctx(struct mmc_omap_host *host)
+static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 {
 	return 0;
 }
 
-static void omap_mmc_save_ctx(struct mmc_omap_host *host)
+static void omap_hsmmc_context_save(struct omap_hsmmc_host *host)
 {
 }
 
@@ -342,7 +342,7 @@ static void omap_mmc_save_ctx(struct mmc_omap_host *host)
  * Send init stream sequence to card
  * before sending IDLE command
  */
-static void send_init_stream(struct mmc_omap_host *host)
+static void send_init_stream(struct omap_hsmmc_host *host)
 {
 	int reg = 0;
 	unsigned long timeout;
@@ -366,7 +366,7 @@ static void send_init_stream(struct mmc_omap_host *host)
 }
 
 static inline
-int mmc_omap_cover_is_closed(struct mmc_omap_host *host)
+int omap_hsmmc_cover_is_closed(struct omap_hsmmc_host *host)
 {
 	int r = 1;
 
@@ -376,35 +376,35 @@ int mmc_omap_cover_is_closed(struct mmc_omap_host *host)
 }
 
 static ssize_t
-mmc_omap_show_cover_switch(struct device *dev, struct device_attribute *attr,
+omap_hsmmc_show_cover_switch(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
 	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
-	return sprintf(buf, "%s\n", mmc_omap_cover_is_closed(host) ? "closed" :
-		       "open");
+	return sprintf(buf, "%s\n",
+			omap_hsmmc_cover_is_closed(host) ? "closed" : "open");
 }
 
-static DEVICE_ATTR(cover_switch, S_IRUGO, mmc_omap_show_cover_switch, NULL);
+static DEVICE_ATTR(cover_switch, S_IRUGO, omap_hsmmc_show_cover_switch, NULL);
 
 static ssize_t
-mmc_omap_show_slot_name(struct device *dev, struct device_attribute *attr,
+omap_hsmmc_show_slot_name(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
 	return sprintf(buf, "%s\n", mmc_slot(host).name);
 }
 
-static DEVICE_ATTR(slot_name, S_IRUGO, mmc_omap_show_slot_name, NULL);
+static DEVICE_ATTR(slot_name, S_IRUGO, omap_hsmmc_show_slot_name, NULL);
 
 /*
  * Configure the response type and send the cmd.
  */
 static void
-mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
+omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
 	struct mmc_data *data)
 {
 	int cmdreg = 0, resptype = 0, cmdtype = 0;
@@ -464,7 +464,7 @@ mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
 }
 
 static int
-mmc_omap_get_dma_dir(struct mmc_omap_host *host, struct mmc_data *data)
+omap_hsmmc_get_dma_dir(struct omap_hsmmc_host *host, struct mmc_data *data)
 {
 	if (data->flags & MMC_DATA_WRITE)
 		return DMA_TO_DEVICE;
@@ -476,7 +476,7 @@ mmc_omap_get_dma_dir(struct mmc_omap_host *host, struct mmc_data *data)
  * Notify the transfer complete to MMC core
  */
 static void
-mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
+omap_hsmmc_xfer_done(struct omap_hsmmc_host *host, struct mmc_data *data)
 {
 	if (!data) {
 		struct mmc_request *mrq = host->mrq;
@@ -497,7 +497,7 @@ mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 
 	if (host->use_dma && host->dma_ch != -1)
 		dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->dma_len,
-			mmc_omap_get_dma_dir(host, data));
+			omap_hsmmc_get_dma_dir(host, data));
 
 	if (!data->error)
 		data->bytes_xfered += data->blocks * (data->blksz);
@@ -509,14 +509,14 @@ mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 		mmc_request_done(host->mmc, data->mrq);
 		return;
 	}
-	mmc_omap_start_command(host, data->stop, NULL);
+	omap_hsmmc_start_command(host, data->stop, NULL);
 }
 
 /*
  * Notify the core about command completion
  */
 static void
-mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
+omap_hsmmc_cmd_done(struct omap_hsmmc_host *host, struct mmc_command *cmd)
 {
 	host->cmd = NULL;
 
@@ -541,13 +541,13 @@ mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
 /*
  * DMA clean up for command errors
  */
-static void mmc_dma_cleanup(struct mmc_omap_host *host, int errno)
+static void omap_hsmmc_dma_cleanup(struct omap_hsmmc_host *host, int errno)
 {
 	host->data->error = errno;
 
 	if (host->use_dma && host->dma_ch != -1) {
 		dma_unmap_sg(mmc_dev(host->mmc), host->data->sg, host->dma_len,
-			mmc_omap_get_dma_dir(host, host->data));
+			omap_hsmmc_get_dma_dir(host, host->data));
 		omap_free_dma(host->dma_ch);
 		host->dma_ch = -1;
 		up(&host->sem);
@@ -559,10 +559,10 @@ static void mmc_dma_cleanup(struct mmc_omap_host *host, int errno)
  * Readable error output
  */
 #ifdef CONFIG_MMC_DEBUG
-static void mmc_omap_report_irq(struct mmc_omap_host *host, u32 status)
+static void omap_hsmmc_report_irq(struct omap_hsmmc_host *host, u32 status)
 {
 	/* --- means reserved bit without definition at documentation */
-	static const char *mmc_omap_status_bits[] = {
+	static const char *omap_hsmmc_status_bits[] = {
 		"CC", "TC", "BGE", "---", "BWR", "BRR", "---", "---", "CIRQ",
 		"OBI", "---", "---", "---", "---", "---", "ERRI", "CTO", "CCRC",
 		"CEB", "CIE", "DTO", "DCRC", "DEB", "---", "ACE", "---",
@@ -575,9 +575,9 @@ static void mmc_omap_report_irq(struct mmc_omap_host *host, u32 status)
 	len = sprintf(buf, "MMC IRQ 0x%x :", status);
 	buf += len;
 
-	for (i = 0; i < ARRAY_SIZE(mmc_omap_status_bits); i++)
+	for (i = 0; i < ARRAY_SIZE(omap_hsmmc_status_bits); i++)
 		if (status & (1 << i)) {
-			len = sprintf(buf, " %s", mmc_omap_status_bits[i]);
+			len = sprintf(buf, " %s", omap_hsmmc_status_bits[i]);
 			buf += len;
 		}
 
@@ -592,8 +592,8 @@ static void mmc_omap_report_irq(struct mmc_omap_host *host, u32 status)
  *  SRC or SRD bit of SYSCTL register
  * Can be called from interrupt context
  */
-static inline void mmc_omap_reset_controller_fsm(struct mmc_omap_host *host,
-		unsigned long bit)
+static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
+						   unsigned long bit)
 {
 	unsigned long i = 0;
 	unsigned long limit = (loops_per_jiffy *
@@ -615,9 +615,9 @@ static inline void mmc_omap_reset_controller_fsm(struct mmc_omap_host *host,
 /*
  * MMC controller IRQ handler
  */
-static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
+static irqreturn_t omap_hsmmc_irq(int irq, void *dev_id)
 {
-	struct mmc_omap_host *host = dev_id;
+	struct omap_hsmmc_host *host = dev_id;
 	struct mmc_data *data;
 	int end_cmd = 0, end_trans = 0, status;
 
@@ -635,14 +635,14 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 
 	if (status & ERR) {
 #ifdef CONFIG_MMC_DEBUG
-		mmc_omap_report_irq(host, status);
+		omap_hsmmc_report_irq(host, status);
 #endif
 		if ((status & CMD_TIMEOUT) ||
 			(status & CMD_CRC)) {
 			if (host->cmd) {
 				if (status & CMD_TIMEOUT) {
-					mmc_omap_reset_controller_fsm(host,
-								      SRC);
+					omap_hsmmc_reset_controller_fsm(host,
+									SRC);
 					host->cmd->error = -ETIMEDOUT;
 				} else {
 					host->cmd->error = -EILSEQ;
@@ -651,9 +651,10 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 			}
 			if (host->data || host->response_busy) {
 				if (host->data)
-					mmc_dma_cleanup(host, -ETIMEDOUT);
+					omap_hsmmc_dma_cleanup(host,
+								-ETIMEDOUT);
 				host->response_busy = 0;
-				mmc_omap_reset_controller_fsm(host, SRD);
+				omap_hsmmc_reset_controller_fsm(host, SRD);
 			}
 		}
 		if ((status & DATA_TIMEOUT) ||
@@ -663,11 +664,11 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 						-ETIMEDOUT : -EILSEQ;
 
 				if (host->data)
-					mmc_dma_cleanup(host, err);
+					omap_hsmmc_dma_cleanup(host, err);
 				else
 					host->mrq->cmd->error = err;
 				host->response_busy = 0;
-				mmc_omap_reset_controller_fsm(host, SRD);
+				omap_hsmmc_reset_controller_fsm(host, SRD);
 				end_trans = 1;
 			}
 		}
@@ -686,14 +687,14 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
 	OMAP_HSMMC_READ(host->base, STAT);
 
 	if (end_cmd || ((status & CC) && host->cmd))
-		mmc_omap_cmd_done(host, host->cmd);
+		omap_hsmmc_cmd_done(host, host->cmd);
 	if ((end_trans || (status & TC)) && host->mrq)
-		mmc_omap_xfer_done(host, data);
+		omap_hsmmc_xfer_done(host, data);
 
 	return IRQ_HANDLED;
 }
 
-static void set_sd_bus_power(struct mmc_omap_host *host)
+static void set_sd_bus_power(struct omap_hsmmc_host *host)
 {
 	unsigned long i;
 
@@ -713,7 +714,7 @@ static void set_sd_bus_power(struct mmc_omap_host *host)
  * The MMC2 transceiver controls are used instead of DAT4..DAT7.
  * Some chips, like eMMC ones, use internal transceivers.
  */
-static int omap_mmc_switch_opcond(struct mmc_omap_host *host, int vdd)
+static int omap_hsmmc_switch_opcond(struct omap_hsmmc_host *host, int vdd)
 {
 	u32 reg_val = 0;
 	int ret;
@@ -744,7 +745,7 @@ static int omap_mmc_switch_opcond(struct mmc_omap_host *host, int vdd)
 	/*
 	 * If a MMC dual voltage card is detected, the set_ios fn calls
 	 * this fn with VDD bit set for 1.8V. Upon card removal from the
-	 * slot, omap_mmc_set_ios sets the VDD back to 3V on MMC_POWER_OFF.
+	 * slot, omap_hsmmc_set_ios sets the VDD back to 3V on MMC_POWER_OFF.
 	 *
 	 * Cope with a bit of slop in the range ... per data sheets:
 	 *  - "1.8V" for vdds_mmc1/vdds_mmc1a can be up to 2.45V max,
@@ -773,10 +774,10 @@ err:
 /*
  * Work Item to notify the core about card insertion/removal
  */
-static void mmc_omap_detect(struct work_struct *work)
+static void omap_hsmmc_detect(struct work_struct *work)
 {
-	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
-						mmc_carddetect_work);
+	struct omap_hsmmc_host *host =
+		container_of(work, struct omap_hsmmc_host, mmc_carddetect_work);
 	struct omap_mmc_slot_data *slot = &mmc_slot(host);
 	int carddetect;
 
@@ -794,8 +795,9 @@ static void mmc_omap_detect(struct work_struct *work)
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
 	} else {
 		mmc_host_enable(host->mmc);
-		mmc_omap_reset_controller_fsm(host, SRD);
+		omap_hsmmc_reset_controller_fsm(host, SRD);
 		mmc_host_lazy_disable(host->mmc);
+
 		mmc_detect_change(host->mmc, (HZ * 50) / 1000);
 	}
 }
@@ -803,9 +805,9 @@ static void mmc_omap_detect(struct work_struct *work)
 /*
  * ISR for handling card insertion and removal
  */
-static irqreturn_t omap_mmc_cd_handler(int irq, void *dev_id)
+static irqreturn_t omap_hsmmc_cd_handler(int irq, void *dev_id)
 {
-	struct mmc_omap_host *host = (struct mmc_omap_host *)dev_id;
+	struct omap_hsmmc_host *host = (struct omap_hsmmc_host *)dev_id;
 
 	if (host->suspended)
 		return IRQ_HANDLED;
@@ -814,7 +816,7 @@ static irqreturn_t omap_mmc_cd_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int mmc_omap_get_dma_sync_dev(struct mmc_omap_host *host,
+static int omap_hsmmc_get_dma_sync_dev(struct omap_hsmmc_host *host,
 				     struct mmc_data *data)
 {
 	int sync_dev;
@@ -826,7 +828,7 @@ static int mmc_omap_get_dma_sync_dev(struct mmc_omap_host *host,
 	return sync_dev;
 }
 
-static void mmc_omap_config_dma_params(struct mmc_omap_host *host,
+static void omap_hsmmc_config_dma_params(struct omap_hsmmc_host *host,
 				       struct mmc_data *data,
 				       struct scatterlist *sgl)
 {
@@ -850,7 +852,7 @@ static void mmc_omap_config_dma_params(struct mmc_omap_host *host,
 
 	omap_set_dma_transfer_params(dma_ch, OMAP_DMA_DATA_TYPE_S32,
 			blksz / 4, nblk, OMAP_DMA_SYNC_FRAME,
-			mmc_omap_get_dma_sync_dev(host, data),
+			omap_hsmmc_get_dma_sync_dev(host, data),
 			!(data->flags & MMC_DATA_WRITE));
 
 	omap_start_dma(dma_ch);
@@ -859,9 +861,9 @@ static void mmc_omap_config_dma_params(struct mmc_omap_host *host,
 /*
  * DMA call back function
  */
-static void mmc_omap_dma_cb(int lch, u16 ch_status, void *data)
+static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *data)
 {
-	struct mmc_omap_host *host = data;
+	struct omap_hsmmc_host *host = data;
 
 	if (ch_status & OMAP2_DMA_MISALIGNED_ERR_IRQ)
 		dev_dbg(mmc_dev(host->mmc), "MISALIGNED_ADRS_ERR\n");
@@ -872,7 +874,7 @@ static void mmc_omap_dma_cb(int lch, u16 ch_status, void *data)
 	host->dma_sg_idx++;
 	if (host->dma_sg_idx < host->dma_len) {
 		/* Fire up the next transfer. */
-		mmc_omap_config_dma_params(host, host->data,
+		omap_hsmmc_config_dma_params(host, host->data,
 					   host->data->sg + host->dma_sg_idx);
 		return;
 	}
@@ -889,8 +891,8 @@ static void mmc_omap_dma_cb(int lch, u16 ch_status, void *data)
 /*
  * Routine to configure and start DMA for the MMC card
  */
-static int
-mmc_omap_start_dma_transfer(struct mmc_omap_host *host, struct mmc_request *req)
+static int omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host,
+					struct mmc_request *req)
 {
 	int dma_ch = 0, ret = 0, err = 1, i;
 	struct mmc_data *data = req->data;
@@ -927,8 +929,8 @@ mmc_omap_start_dma_transfer(struct mmc_omap_host *host, struct mmc_request *req)
 			return err;
 	}
 
-	ret = omap_request_dma(mmc_omap_get_dma_sync_dev(host, data), "MMC/SD",
-			       mmc_omap_dma_cb, host, &dma_ch);
+	ret = omap_request_dma(omap_hsmmc_get_dma_sync_dev(host, data),
+			       "MMC/SD", omap_hsmmc_dma_cb, host, &dma_ch);
 	if (ret != 0) {
 		dev_err(mmc_dev(host->mmc),
 			"%s: omap_request_dma() failed with %d\n",
@@ -937,16 +939,16 @@ mmc_omap_start_dma_transfer(struct mmc_omap_host *host, struct mmc_request *req)
 	}
 
 	host->dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg,
-			data->sg_len, mmc_omap_get_dma_dir(host, data));
+			data->sg_len, omap_hsmmc_get_dma_dir(host, data));
 	host->dma_ch = dma_ch;
 	host->dma_sg_idx = 0;
 
-	mmc_omap_config_dma_params(host, data, data->sg);
+	omap_hsmmc_config_dma_params(host, data, data->sg);
 
 	return 0;
 }
 
-static void set_data_timeout(struct mmc_omap_host *host,
+static void set_data_timeout(struct omap_hsmmc_host *host,
 			     struct mmc_request *req)
 {
 	unsigned int timeout, cycle_ns;
@@ -986,7 +988,7 @@ static void set_data_timeout(struct mmc_omap_host *host,
  * Configure block length for MMC/SD cards and initiate the transfer.
  */
 static int
-mmc_omap_prepare_data(struct mmc_omap_host *host, struct mmc_request *req)
+omap_hsmmc_prepare_data(struct omap_hsmmc_host *host, struct mmc_request *req)
 {
 	int ret;
 	host->data = req->data;
@@ -1001,7 +1003,7 @@ mmc_omap_prepare_data(struct mmc_omap_host *host, struct mmc_request *req)
 	set_data_timeout(host, req);
 
 	if (host->use_dma) {
-		ret = mmc_omap_start_dma_transfer(host, req);
+		ret = omap_hsmmc_start_dma_transfer(host, req);
 		if (ret != 0) {
 			dev_dbg(mmc_dev(host->mmc), "MMC start dma failure\n");
 			return ret;
@@ -1013,9 +1015,9 @@ mmc_omap_prepare_data(struct mmc_omap_host *host, struct mmc_request *req)
 /*
  * Request function. for read/write operation
  */
-static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
+static void omap_hsmmc_request(struct mmc_host *mmc, struct mmc_request *req)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 	int err;
 
 	/*
@@ -1027,7 +1029,7 @@ static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
 		disable_irq(host->irq);
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
-	err = mmc_omap_prepare_data(host, req);
+	err = omap_hsmmc_prepare_data(host, req);
 	if (err) {
 		req->cmd->error = err;
 		if (req->data)
@@ -1039,14 +1041,13 @@ static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
 		return;
 	}
 
-	mmc_omap_start_command(host, req->cmd, req->data);
+	omap_hsmmc_start_command(host, req->cmd, req->data);
 }
 
-
 /* Routine to configure clock values. Exposed API to core */
-static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+static void omap_hsmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 	u16 dsor = 0;
 	unsigned long regval;
 	unsigned long timeout;
@@ -1105,8 +1106,8 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 				 * MMC_POWER_UP upon recalculating the voltage.
 				 * vdd 1.8v.
 				 */
-				if (omap_mmc_switch_opcond(host, ios->vdd) != 0)
-					dev_dbg(mmc_dev(host->mmc),
+			if (omap_hsmmc_switch_opcond(host, ios->vdd) != 0)
+				dev_dbg(mmc_dev(host->mmc),
 						"Switch operation failed\n");
 		}
 	}
@@ -1122,7 +1123,7 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		if (dsor > 250)
 			dsor = 250;
 	}
-	omap_mmc_stop_clock(host);
+	omap_hsmmc_stop_clock(host);
 	regval = OMAP_HSMMC_READ(host->base, SYSCTL);
 	regval = regval & ~(CLKD_MASK);
 	regval = regval | (dsor << 6) | (DTO << 16);
@@ -1156,7 +1157,7 @@ static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 static int omap_hsmmc_get_cd(struct mmc_host *mmc)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
 	if (!mmc_slot(host).card_detect)
 		return -ENOSYS;
@@ -1165,14 +1166,14 @@ static int omap_hsmmc_get_cd(struct mmc_host *mmc)
 
 static int omap_hsmmc_get_ro(struct mmc_host *mmc)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
 	if (!mmc_slot(host).get_ro)
 		return -ENOSYS;
 	return mmc_slot(host).get_ro(host->dev, 0);
 }
 
-static void omap_hsmmc_init(struct mmc_omap_host *host)
+static void omap_hsmmc_conf_bus_power(struct omap_hsmmc_host *host)
 {
 	u32 hctl, capa, value;
 
@@ -1218,9 +1219,9 @@ static void omap_hsmmc_init(struct mmc_omap_host *host)
 enum {ENABLED = 0, DISABLED, CARDSLEEP, REGSLEEP, OFF};
 
 /* Handler for [ENABLED -> DISABLED] transition */
-static int omap_mmc_enabled_to_disabled(struct mmc_omap_host *host)
+static int omap_hsmmc_enabled_to_disabled(struct omap_hsmmc_host *host)
 {
-	omap_mmc_save_ctx(host);
+	omap_hsmmc_context_save(host);
 	clk_disable(host->fclk);
 	host->dpm_state = DISABLED;
 
@@ -1233,7 +1234,7 @@ static int omap_mmc_enabled_to_disabled(struct mmc_omap_host *host)
 }
 
 /* Handler for [DISABLED -> REGSLEEP / CARDSLEEP] transition */
-static int omap_mmc_disabled_to_sleep(struct mmc_omap_host *host)
+static int omap_hsmmc_disabled_to_sleep(struct omap_hsmmc_host *host)
 {
 	int err, new_state;
 
@@ -1241,7 +1242,7 @@ static int omap_mmc_disabled_to_sleep(struct mmc_omap_host *host)
 		return 0;
 
 	clk_enable(host->fclk);
-	omap_mmc_restore_ctx(host);
+	omap_hsmmc_context_restore(host);
 	if (mmc_card_can_sleep(host->mmc)) {
 		err = mmc_card_sleep(host->mmc);
 		if (err < 0) {
@@ -1250,8 +1251,9 @@ static int omap_mmc_disabled_to_sleep(struct mmc_omap_host *host)
 			return err;
 		}
 		new_state = CARDSLEEP;
-	} else
+	} else {
 		new_state = REGSLEEP;
+	}
 	if (mmc_slot(host).set_sleep)
 		mmc_slot(host).set_sleep(host->dev, host->slot_id, 1, 0,
 					 new_state == CARDSLEEP);
@@ -1274,7 +1276,7 @@ static int omap_mmc_disabled_to_sleep(struct mmc_omap_host *host)
 }
 
 /* Handler for [REGSLEEP / CARDSLEEP -> OFF] transition */
-static int omap_mmc_sleep_to_off(struct mmc_omap_host *host)
+static int omap_hsmmc_sleep_to_off(struct omap_hsmmc_host *host)
 {
 	if (!mmc_try_claim_host(host->mmc))
 		return 0;
@@ -1302,7 +1304,7 @@ static int omap_mmc_sleep_to_off(struct mmc_omap_host *host)
 }
 
 /* Handler for [DISABLED -> ENABLED] transition */
-static int omap_mmc_disabled_to_enabled(struct mmc_omap_host *host)
+static int omap_hsmmc_disabled_to_enabled(struct omap_hsmmc_host *host)
 {
 	int err;
 
@@ -1310,8 +1312,7 @@ static int omap_mmc_disabled_to_enabled(struct mmc_omap_host *host)
 	if (err < 0)
 		return err;
 
-	omap_mmc_restore_ctx(host);
-
+	omap_hsmmc_context_restore(host);
 	host->dpm_state = ENABLED;
 
 	dev_dbg(mmc_dev(host->mmc), "DISABLED -> ENABLED\n");
@@ -1320,13 +1321,13 @@ static int omap_mmc_disabled_to_enabled(struct mmc_omap_host *host)
 }
 
 /* Handler for [SLEEP -> ENABLED] transition */
-static int omap_mmc_sleep_to_enabled(struct mmc_omap_host *host)
+static int omap_hsmmc_sleep_to_enabled(struct omap_hsmmc_host *host)
 {
 	if (!mmc_try_claim_host(host->mmc))
 		return 0;
 
 	clk_enable(host->fclk);
-	omap_mmc_restore_ctx(host);
+	omap_hsmmc_context_restore(host);
 	if (mmc_slot(host).set_sleep)
 		mmc_slot(host).set_sleep(host->dev, host->slot_id, 0,
 			 host->vdd, host->dpm_state == CARDSLEEP);
@@ -1344,12 +1345,12 @@ static int omap_mmc_sleep_to_enabled(struct mmc_omap_host *host)
 }
 
 /* Handler for [OFF -> ENABLED] transition */
-static int omap_mmc_off_to_enabled(struct mmc_omap_host *host)
+static int omap_hsmmc_off_to_enabled(struct omap_hsmmc_host *host)
 {
 	clk_enable(host->fclk);
 
-	omap_mmc_restore_ctx(host);
-	omap_hsmmc_init(host);
+	omap_hsmmc_context_restore(host);
+	omap_hsmmc_conf_bus_power(host);
 	mmc_power_restore_host(host->mmc);
 
 	host->dpm_state = ENABLED;
@@ -1362,18 +1363,18 @@ static int omap_mmc_off_to_enabled(struct mmc_omap_host *host)
 /*
  * Bring MMC host to ENABLED from any other PM state.
  */
-static int omap_mmc_enable(struct mmc_host *mmc)
+static int omap_hsmmc_enable(struct mmc_host *mmc)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
 	switch (host->dpm_state) {
 	case DISABLED:
-		return omap_mmc_disabled_to_enabled(host);
+		return omap_hsmmc_disabled_to_enabled(host);
 	case CARDSLEEP:
 	case REGSLEEP:
-		return omap_mmc_sleep_to_enabled(host);
+		return omap_hsmmc_sleep_to_enabled(host);
 	case OFF:
-		return omap_mmc_off_to_enabled(host);
+		return omap_hsmmc_off_to_enabled(host);
 	default:
 		dev_dbg(mmc_dev(host->mmc), "UNKNOWN state\n");
 		return -EINVAL;
@@ -1383,68 +1384,68 @@ static int omap_mmc_enable(struct mmc_host *mmc)
 /*
  * Bring MMC host in PM state (one level deeper).
  */
-static int omap_mmc_disable(struct mmc_host *mmc, int lazy)
+static int omap_hsmmc_disable(struct mmc_host *mmc, int lazy)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
 	switch (host->dpm_state) {
 	case ENABLED: {
 		int delay;
 
-		delay = omap_mmc_enabled_to_disabled(host);
+		delay = omap_hsmmc_enabled_to_disabled(host);
 		if (lazy || delay < 0)
 			return delay;
 		return 0;
 	}
 	case DISABLED:
-		return omap_mmc_disabled_to_sleep(host);
+		return omap_hsmmc_disabled_to_sleep(host);
 	case CARDSLEEP:
 	case REGSLEEP:
-		return omap_mmc_sleep_to_off(host);
+		return omap_hsmmc_sleep_to_off(host);
 	default:
 		dev_dbg(mmc_dev(host->mmc), "UNKNOWN state\n");
 		return -EINVAL;
 	}
 }
 
-static int omap_mmc_enable_fclk(struct mmc_host *mmc)
+static int omap_hsmmc_enable_fclk(struct mmc_host *mmc)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 	int err;
 
 	err = clk_enable(host->fclk);
 	if (err)
 		return err;
 	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: enabled\n");
-	omap_mmc_restore_ctx(host);
+	omap_hsmmc_context_restore(host);
 	return 0;
 }
 
-static int omap_mmc_disable_fclk(struct mmc_host *mmc, int lazy)
+static int omap_hsmmc_disable_fclk(struct mmc_host *mmc, int lazy)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
-	omap_mmc_save_ctx(host);
+	omap_hsmmc_context_save(host);
 	clk_disable(host->fclk);
 	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: disabled\n");
 	return 0;
 }
 
-static const struct mmc_host_ops mmc_omap_ops = {
-	.enable = omap_mmc_enable_fclk,
-	.disable = omap_mmc_disable_fclk,
-	.request = omap_mmc_request,
-	.set_ios = omap_mmc_set_ios,
+static const struct mmc_host_ops omap_hsmmc_ops = {
+	.enable = omap_hsmmc_enable_fclk,
+	.disable = omap_hsmmc_disable_fclk,
+	.request = omap_hsmmc_request,
+	.set_ios = omap_hsmmc_set_ios,
 	.get_cd = omap_hsmmc_get_cd,
 	.get_ro = omap_hsmmc_get_ro,
 	/* NYET -- enable_sdio_irq */
 };
 
-static const struct mmc_host_ops mmc_omap_ps_ops = {
-	.enable = omap_mmc_enable,
-	.disable = omap_mmc_disable,
-	.request = omap_mmc_request,
-	.set_ios = omap_mmc_set_ios,
+static const struct mmc_host_ops omap_hsmmc_ps_ops = {
+	.enable = omap_hsmmc_enable,
+	.disable = omap_hsmmc_disable,
+	.request = omap_hsmmc_request,
+	.set_ios = omap_hsmmc_set_ios,
 	.get_cd = omap_hsmmc_get_cd,
 	.get_ro = omap_hsmmc_get_ro,
 	/* NYET -- enable_sdio_irq */
@@ -1452,15 +1453,14 @@ static const struct mmc_host_ops mmc_omap_ps_ops = {
 
 #ifdef CONFIG_DEBUG_FS
 
-static int mmc_regs_show(struct seq_file *s, void *data)
+static int omap_hsmmc_regs_show(struct seq_file *s, void *data)
 {
 	struct mmc_host *mmc = s->private;
-	struct mmc_omap_host *host = mmc_priv(mmc);
-	struct omap_mmc_platform_data *pdata = host->pdata;
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 	int context_loss = 0;
 
-	if (pdata->get_context_loss_count)
-		context_loss = pdata->get_context_loss_count(host->dev);
+	if (host->pdata->get_context_loss_count)
+		context_loss = host->pdata->get_context_loss_count(host->dev);
 
 	seq_printf(s, "mmc%d:\n"
 			" enabled:\t%d\n"
@@ -1502,19 +1502,19 @@ static int mmc_regs_show(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int mmc_regs_open(struct inode *inode, struct file *file)
+static int omap_hsmmc_regs_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, mmc_regs_show, inode->i_private);
+	return single_open(file, omap_hsmmc_regs_show, inode->i_private);
 }
 
 static const struct file_operations mmc_regs_fops = {
-	.open           = mmc_regs_open,
+	.open           = omap_hsmmc_regs_open,
 	.read           = seq_read,
 	.llseek         = seq_lseek,
 	.release        = single_release,
 };
 
-static void omap_mmc_debugfs(struct mmc_host *mmc)
+static void omap_hsmmc_debugfs(struct mmc_host *mmc)
 {
 	if (mmc->debugfs_root)
 		debugfs_create_file("regs", S_IRUSR, mmc->debugfs_root,
@@ -1523,17 +1523,17 @@ static void omap_mmc_debugfs(struct mmc_host *mmc)
 
 #else
 
-static void omap_mmc_debugfs(struct mmc_host *mmc)
+static void omap_hsmmc_debugfs(struct mmc_host *mmc)
 {
 }
 
 #endif
 
-static int __init omap_mmc_probe(struct platform_device *pdev)
+static int __init omap_hsmmc_probe(struct platform_device *pdev)
 {
 	struct omap_mmc_platform_data *pdata = pdev->dev.platform_data;
 	struct mmc_host *mmc;
-	struct mmc_omap_host *host = NULL;
+	struct omap_hsmmc_host *host = NULL;
 	struct resource *res;
 	int ret = 0, irq;
 
@@ -1557,7 +1557,7 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	if (res == NULL)
 		return -EBUSY;
 
-	mmc = mmc_alloc_host(sizeof(struct mmc_omap_host), &pdev->dev);
+	mmc = mmc_alloc_host(sizeof(struct omap_hsmmc_host), &pdev->dev);
 	if (!mmc) {
 		ret = -ENOMEM;
 		goto err;
@@ -1578,12 +1578,12 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	host->power_mode = -1;
 
 	platform_set_drvdata(pdev, host);
-	INIT_WORK(&host->mmc_carddetect_work, mmc_omap_detect);
+	INIT_WORK(&host->mmc_carddetect_work, omap_hsmmc_detect);
 
 	if (mmc_slot(host).power_saving)
-		mmc->ops	= &mmc_omap_ps_ops;
+		mmc->ops	= &omap_hsmmc_ps_ops;
 	else
-		mmc->ops	= &mmc_omap_ops;
+		mmc->ops	= &omap_hsmmc_ops;
 
 	mmc->f_min	= 400000;
 	mmc->f_max	= 52000000;
@@ -1604,7 +1604,7 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	omap_mmc_save_ctx(host);
+	omap_hsmmc_context_save(host);
 
 	mmc->caps |= MMC_CAP_DISABLE;
 	mmc_set_disable_delay(mmc, msecs_to_jiffies(OMAP_MMC_DISABLED_TIMEOUT));
@@ -1657,7 +1657,7 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 
 	mmc->caps |= mmc_slot(host).caps;
 
-	omap_hsmmc_init(host);
+	omap_hsmmc_conf_bus_power(host);
 
 	/* Select DMA lines */
 	switch (host->id) {
@@ -1679,7 +1679,7 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	}
 
 	/* Request IRQ for MMC operations */
-	ret = request_irq(host->irq, mmc_omap_irq, IRQF_DISABLED,
+	ret = request_irq(host->irq, omap_hsmmc_irq, IRQF_DISABLED,
 			mmc_hostname(mmc), host);
 	if (ret) {
 		dev_dbg(mmc_dev(host->mmc), "Unable to grab HSMMC IRQ\n");
@@ -1689,7 +1689,8 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	/* initialize power supplies, gpios, etc */
 	if (pdata->init != NULL) {
 		if (pdata->init(&pdev->dev) != 0) {
-			dev_dbg(mmc_dev(host->mmc), "late init error\n");
+			dev_dbg(mmc_dev(host->mmc),
+				"Unable to configure MMC IRQs\n");
 			goto err_irq_cd_init;
 		}
 	}
@@ -1698,7 +1699,7 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 	/* Request IRQ for card detect */
 	if ((mmc_slot(host).card_detect_irq)) {
 		ret = request_irq(mmc_slot(host).card_detect_irq,
-				  omap_mmc_cd_handler,
+				  omap_hsmmc_cd_handler,
 				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING
 					  | IRQF_DISABLED,
 				  mmc_hostname(mmc), host);
@@ -1728,7 +1729,7 @@ static int __init omap_mmc_probe(struct platform_device *pdev)
 			goto err_cover_switch;
 	}
 
-	omap_mmc_debugfs(mmc);
+	omap_hsmmc_debugfs(mmc);
 
 	return 0;
 
@@ -1760,9 +1761,9 @@ err:
 	return ret;
 }
 
-static int omap_mmc_remove(struct platform_device *pdev)
+static int omap_hsmmc_remove(struct platform_device *pdev)
 {
-	struct mmc_omap_host *host = platform_get_drvdata(pdev);
+	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
 	struct resource *res;
 
 	if (host) {
@@ -1797,10 +1798,10 @@ static int omap_mmc_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int omap_mmc_suspend(struct platform_device *pdev, pm_message_t state)
+static int omap_hsmmc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	int ret = 0;
-	struct mmc_omap_host *host = platform_get_drvdata(pdev);
+	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
 
 	if (host && host->suspended)
 		return 0;
@@ -1848,10 +1849,10 @@ static int omap_mmc_suspend(struct platform_device *pdev, pm_message_t state)
 }
 
 /* Routine to resume the MMC device */
-static int omap_mmc_resume(struct platform_device *pdev)
+static int omap_hsmmc_resume(struct platform_device *pdev)
 {
 	int ret = 0;
-	struct mmc_omap_host *host = platform_get_drvdata(pdev);
+	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
 
 	if (host && !host->suspended)
 		return 0;
@@ -1870,7 +1871,7 @@ static int omap_mmc_resume(struct platform_device *pdev)
 			goto clk_en_err;
 		}
 
-		omap_hsmmc_init(host);
+		omap_hsmmc_conf_bus_power(host);
 
 		if (host->pdata->resume) {
 			ret = host->pdata->resume(&pdev->dev, host->slot_id);
@@ -1883,6 +1884,7 @@ static int omap_mmc_resume(struct platform_device *pdev)
 		ret = mmc_resume_host(host->mmc);
 		if (ret == 0)
 			host->suspended = 0;
+
 		mmc_host_lazy_disable(host->mmc);
 	}
 
@@ -1895,35 +1897,35 @@ clk_en_err:
 }
 
 #else
-#define omap_mmc_suspend	NULL
-#define omap_mmc_resume		NULL
+#define omap_hsmmc_suspend	NULL
+#define omap_hsmmc_resume		NULL
 #endif
 
-static struct platform_driver omap_mmc_driver = {
-	.probe		= omap_mmc_probe,
-	.remove		= omap_mmc_remove,
-	.suspend	= omap_mmc_suspend,
-	.resume		= omap_mmc_resume,
+static struct platform_driver omap_hsmmc_driver = {
+	.probe		= omap_hsmmc_probe,
+	.remove		= omap_hsmmc_remove,
+	.suspend	= omap_hsmmc_suspend,
+	.resume		= omap_hsmmc_resume,
 	.driver		= {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 	},
 };
 
-static int __init omap_mmc_init(void)
+static int __init omap_hsmmc_init(void)
 {
 	/* Register the MMC driver */
-	return platform_driver_register(&omap_mmc_driver);
+	return platform_driver_register(&omap_hsmmc_driver);
 }
 
-static void __exit omap_mmc_cleanup(void)
+static void __exit omap_hsmmc_cleanup(void)
 {
 	/* Unregister MMC driver */
-	platform_driver_unregister(&omap_mmc_driver);
+	platform_driver_unregister(&omap_hsmmc_driver);
 }
 
-module_init(omap_mmc_init);
-module_exit(omap_mmc_cleanup);
+module_init(omap_hsmmc_init);
+module_exit(omap_hsmmc_cleanup);
 
 MODULE_DESCRIPTION("OMAP High Speed Multimedia Card driver");
 MODULE_LICENSE("GPL");
-- 
1.5.6.3
