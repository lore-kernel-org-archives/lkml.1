Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbYFPOhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbYFPOhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYFPOf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:35:26 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50186 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753618AbYFPOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:35:14 -0400
Message-Id: <20080616143512.164895707@fluff.org.uk>
References: <20080616143445.451023326@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Mon, 16 Jun 2008 15:34:47 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: drzeus-mmc@drzeus.cx, Ben Dooks <ben-linux@fluff.org>
Subject: [patch v2 02/16] MMC: S3C24XX: Fix the checkpatch.pl errors in the s3cmci driver
Content-Disposition: inline; filename=simtec/simtec-fix-checkpatch-errors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the checkpatch and other problems pointed out by
akpm.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.c	2008-06-07 12:25:20.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.c	2008-06-16 15:18:13.000000000 +0100
@@ -15,11 +15,10 @@
 #include <linux/mmc/host.h>
 #include <linux/platform_device.h>
 #include <linux/irq.h>
+#include <linux/io.h>
 
 #include <asm/dma.h>
-#include <asm/dma-mapping.h>
 
-#include <asm/io.h>
 #include <asm/arch/regs-sdi.h>
 #include <asm/arch/regs-gpio.h>
 
@@ -43,13 +42,15 @@ static const int dbgmap_err   = dbg_err 
 static const int dbgmap_info  = dbg_info | dbg_conf;
 static const int dbgmap_debug = dbg_debug;
 
-#define dbg(host, channels, args...)		 \
-	if (dbgmap_err & channels) 		 \
-		dev_err(&host->pdev->dev, args); \
-	else if (dbgmap_info & channels)	 \
-		dev_info(&host->pdev->dev, args);\
-	else if (dbgmap_debug & channels)	 \
-		dev_dbg(&host->pdev->dev, args);
+#define dbg(host, channels, args...)		  \
+	do {					  \
+	if (dbgmap_err & channels) 		  \
+		dev_err(&host->pdev->dev, args);  \
+	else if (dbgmap_info & channels)	  \
+		dev_info(&host->pdev->dev, args); \
+	else if (dbgmap_debug & channels)	  \
+		dev_dbg(&host->pdev->dev, args);  \
+	} while (0)
 
 #define RESSIZE(ressource) (((ressource)->end - (ressource)->start)+1)
 
@@ -63,7 +64,7 @@ static void s3cmci_reset(struct s3cmci_h
 
 #ifdef CONFIG_MMC_DEBUG
 
-static inline void dbg_dumpregs(struct s3cmci_host *host, char *prefix)
+static void dbg_dumpregs(struct s3cmci_host *host, char *prefix)
 {
 	u32 con, pre, cmdarg, cmdcon, cmdsta, r0, r1, r2, r3, timer, bsize;
 	u32 datcon, datcnt, datsta, fsta, imask;
@@ -103,17 +104,17 @@ static inline void dbg_dumpregs(struct s
 static void prepare_dbgmsg(struct s3cmci_host *host, struct mmc_command *cmd,
 								int stop)
 {
- 	snprintf(host->dbgmsg_cmd, 300,
-		"#%u%s op:%i arg:0x%08x flags:0x08%x retries:%u",
-		host->ccnt, (stop?" (STOP)":""),
-		cmd->opcode, cmd->arg, cmd->flags, cmd->retries);
+	snprintf(host->dbgmsg_cmd, 300,
+		 "#%u%s op:%i arg:0x%08x flags:0x08%x retries:%u",
+		 host->ccnt, (stop ? " (STOP)" : ""),
+		 cmd->opcode, cmd->arg, cmd->flags, cmd->retries);
 
 	if (cmd->data) {
 		snprintf(host->dbgmsg_dat, 300,
-			"#%u bsize:%u blocks:%u bytes:%u",
-			host->dcnt, cmd->data->blksz,
-			cmd->data->blocks,
-			cmd->data->blocks * cmd->data->blksz);
+			 "#%u bsize:%u blocks:%u bytes:%u",
+			 host->dcnt, cmd->data->blksz,
+			 cmd->data->blocks,
+			 cmd->data->blocks * cmd->data->blksz);
 	} else {
 		host->dbgmsg_dat[0] = '\0';
 	}
@@ -153,7 +154,7 @@ static inline u32 enable_imask(struct s3
 	u32 newmask;
 
 	newmask = readl(host->base + host->sdiimsk);
-	newmask|= imask;
+	newmask |= imask;
 
 	writel(newmask, host->base + host->sdiimsk);
 
@@ -165,7 +166,7 @@ static inline u32 disable_imask(struct s
 	u32 newmask;
 
 	newmask = readl(host->base + host->sdiimsk);
-	newmask&= ~imask;
+	newmask &= ~imask;
 
 	writel(newmask, host->base + host->sdiimsk);
 
@@ -178,7 +179,7 @@ static inline void clear_imask(struct s3
 }
 
 static inline int get_data_buffer(struct s3cmci_host *host,
-			volatile u32 *words, volatile u32 **pointer)
+				  u32 *words, u32 **pointer)
 {
 	struct scatterlist *sg;
 
@@ -195,69 +196,82 @@ static inline int get_data_buffer(struct
 	}
 	sg = &host->mrq->data->sg[host->pio_sgptr];
 
-	*words	= sg->length >> 2;
-	*pointer= page_address(sg->page) + sg->offset;
+	*words = sg->length >> 2;
+	*pointer = page_address(sg->page) + sg->offset;
 
 	host->pio_sgptr++;
 
 	dbg(host, dbg_sg, "new buffer (%i/%i)\n",
-	      host->pio_sgptr, host->mrq->data->sg_len);
+	    host->pio_sgptr, host->mrq->data->sg_len);
 
 	return 0;
 }
 
-#define FIFO_FILL(host) ((readl(host->base + S3C2410_SDIFSTA) & S3C2410_SDIFSTA_COUNTMASK) >> 2)
-#define FIFO_FREE(host) ((63 - (readl(host->base + S3C2410_SDIFSTA) & S3C2410_SDIFSTA_COUNTMASK)) >> 2)
+static inline u32 fifo_count(struct s3cmci_host *host)
+{
+	u32 fifostat = readl(host->base + S3C2410_SDIFSTA);
+
+	fifostat &= S3C2410_SDIFSTA_COUNTMASK;
+	return fifostat >> 2;
+}
+
+static inline u32 fifo_free(struct s3cmci_host *host)
+{
+	u32 fifostat = readl(host->base + S3C2410_SDIFSTA);
+
+	fifostat &= S3C2410_SDIFSTA_COUNTMASK;
+	return 63 - (fifostat >> 2);
+}
 
-static inline void do_pio_read(struct s3cmci_host *host)
+static void do_pio_read(struct s3cmci_host *host)
 {
 	int res;
 	u32 fifo;
 	void __iomem *from_ptr;
 
-	//write real prescaler to host, it might be set slow to fix
+	/* write real prescaler to host, it might be set slow to fix */
 	writel(host->prescaler, host->base + S3C2410_SDIPRE);
 
 	from_ptr = host->base + host->sdidata;
 
-	while ((fifo = FIFO_FILL(host))) {
+	while ((fifo = fifo_count(host))) {
 		if (!host->pio_words) {
 			res = get_data_buffer(host, &host->pio_words,
-							&host->pio_ptr);
+					      &host->pio_ptr);
 			if (res) {
 				host->pio_active = XFER_NONE;
 				host->complete_what = COMPLETION_FINALIZE;
 
 				dbg(host, dbg_pio, "pio_read(): "
-					"complete (no more data).\n");
+				    "complete (no more data).\n");
 				return;
 			}
 
-			dbg(host, dbg_pio, "pio_read(): new target: [%i]@[%p]\n",
-			       host->pio_words, host->pio_ptr);
+			dbg(host, dbg_pio,
+			    "pio_read(): new target: [%i]@[%p]\n",
+			    host->pio_words, host->pio_ptr);
 		}
 
-		dbg(host, dbg_pio, "pio_read(): fifo:[%02i] "
-				   "buffer:[%03i] dcnt:[%08X]\n",
-				   fifo, host->pio_words,
-				   readl(host->base + S3C2410_SDIDCNT));
+		dbg(host, dbg_pio,
+		    "pio_read(): fifo:[%02i] buffer:[%03i] dcnt:[%08X]\n",
+		    fifo, host->pio_words,
+		    readl(host->base + S3C2410_SDIDCNT));
 
 		if (fifo > host->pio_words)
 			fifo = host->pio_words;
 
-		host->pio_words-= fifo;
-		host->pio_count+= fifo;
+		host->pio_words -= fifo;
+		host->pio_count += fifo;
 
-		while(fifo--) {
+		while (fifo--)
 			*(host->pio_ptr++) = readl(from_ptr);
-		}
 	}
 
 	if (!host->pio_words) {
 		res = get_data_buffer(host, &host->pio_words, &host->pio_ptr);
 		if (res) {
-			dbg(host, dbg_pio, "pio_read(): "
-				"complete (no more buffers).\n");
+			dbg(host, dbg_pio,
+			    "pio_read(): complete (no more buffers).\n");
 			host->pio_active = XFER_NONE;
 			host->complete_what = COMPLETION_FINALIZE;
 
@@ -265,10 +279,11 @@ static inline void do_pio_read(struct s3
 		}
 	}
 
-	enable_imask(host, S3C2410_SDIIMSK_RXFIFOHALF | S3C2410_SDIIMSK_RXFIFOLAST);
+	enable_imask(host,
+		     S3C2410_SDIIMSK_RXFIFOHALF | S3C2410_SDIIMSK_RXFIFOLAST);
 }
 
-static inline void do_pio_write(struct s3cmci_host *host)
+static void do_pio_write(struct s3cmci_host *host)
 {
 	int res;
 	u32 fifo;
@@ -277,33 +292,32 @@ static inline void do_pio_write(struct s
 
 	to_ptr = host->base + host->sdidata;
 
-	while ((fifo = FIFO_FREE(host))) {
+	while ((fifo = fifo_free(host))) {
 		if (!host->pio_words) {
 			res = get_data_buffer(host, &host->pio_words,
 							&host->pio_ptr);
 			if (res) {
-				dbg(host, dbg_pio, "pio_write(): "
-					"complete (no more data).\n");
+				dbg(host, dbg_pio,
+				    "pio_write(): complete (no more data).\n");
 				host->pio_active = XFER_NONE;
 
 				return;
 			}
 
-			dbg(host, dbg_pio, "pio_write(): "
-				"new source: [%i]@[%p]\n",
-				host->pio_words, host->pio_ptr);
+			dbg(host, dbg_pio,
+			    "pio_write(): new source: [%i]@[%p]\n",
+			    host->pio_words, host->pio_ptr);
 
 		}
 
 		if (fifo > host->pio_words)
 			fifo = host->pio_words;
 
-		host->pio_words-= fifo;
-		host->pio_count+= fifo;
+		host->pio_words -= fifo;
+		host->pio_count += fifo;
 
-		while(fifo--) {
+		while (fifo--)
 			writel(*(host->pio_ptr++), to_ptr);
-		}
 	}
 
 	enable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
@@ -324,9 +338,9 @@ static void pio_tasklet(unsigned long da
 		clear_imask(host);
 		if (host->pio_active != XFER_NONE) {
 			dbg(host, dbg_err, "unfinished %s "
-				"- pio_count:[%u] pio_words:[%u]\n",
-				(host->pio_active == XFER_READ)?"read":"write",
-				host->pio_count, host->pio_words);
+			    "- pio_count:[%u] pio_words:[%u]\n",
+			    (host->pio_active == XFER_READ) ? "read" : "write",
+			    host->pio_count, host->pio_words);
 
 			host->mrq->data->error = MMC_ERR_DMA;
 		}
@@ -340,7 +354,7 @@ static void pio_tasklet(unsigned long da
  * ISR for SDI Interface IRQ
  * Communication between driver and ISR works as follows:
  *   host->mrq 			points to current request
- *   host->complete_what	tells the ISR when the request is considered done
+ *   host->complete_what	Indicates when the request is considered done
  *     COMPLETION_CMDSENT	  when the command was sent
  *     COMPLETION_RSPFIN          when a response was received
  *     COMPLETION_XFERFINISH	  when the data transfer is finished
@@ -365,14 +379,12 @@ static void pio_tasklet(unsigned long da
 
 static irqreturn_t s3cmci_irq(int irq, void *dev_id)
 {
-	struct s3cmci_host *host;
+	struct s3cmci_host *host = dev_id;
 	struct mmc_command *cmd;
 	u32 mci_csta, mci_dsta, mci_fsta, mci_dcnt, mci_imsk;
 	u32 mci_cclear, mci_dclear;
 	unsigned long iflags;
 
-	host = (struct s3cmci_host *)dev_id;
-
 	spin_lock_irqsave(&host->complete_lock, iflags);
 
 	mci_csta 	= readl(host->base + S3C2410_SDICMDSTAT);
@@ -384,7 +396,7 @@ static irqreturn_t s3cmci_irq(int irq, v
 	mci_dclear	= 0;
 
 	if ((host->complete_what == COMPLETION_NONE) ||
-			(host->complete_what == COMPLETION_FINALIZE)) {
+	    (host->complete_what == COMPLETION_FINALIZE)) {
 		host->status = "nothing to complete";
 		clear_imask(host);
 		goto irq_out;
@@ -396,7 +408,7 @@ static irqreturn_t s3cmci_irq(int irq, v
 		goto irq_out;
 	}
 
-	cmd = host->cmd_is_stop?host->mrq->stop:host->mrq->cmd;
+	cmd = host->cmd_is_stop ? host->mrq->stop : host->mrq->cmd;
 
 	if (!cmd) {
 		host->status = "no active cmd";
@@ -406,7 +418,7 @@ static irqreturn_t s3cmci_irq(int irq, v
 
 	if (!host->dodma) {
 		if ((host->pio_active == XFER_WRITE) &&
-				(mci_fsta & S3C2410_SDIFSTA_TFDET)) {
+		    (mci_fsta & S3C2410_SDIFSTA_TFDET)) {
 
 			disable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
 			tasklet_schedule(&host->pio_tasklet);
@@ -414,10 +426,11 @@ static irqreturn_t s3cmci_irq(int irq, v
 		}
 
 		if ((host->pio_active == XFER_READ) &&
-				(mci_fsta & S3C2410_SDIFSTA_RFDET)) {
+		    (mci_fsta & S3C2410_SDIFSTA_RFDET)) {
 
 			disable_imask(host,
-				S3C2410_SDIIMSK_RXFIFOHALF | S3C2410_SDIIMSK_RXFIFOLAST);
+				      S3C2410_SDIIMSK_RXFIFOHALF |
+				      S3C2410_SDIIMSK_RXFIFOLAST);
 
 			tasklet_schedule(&host->pio_tasklet);
 			host->status = "pio rx";
@@ -506,9 +519,8 @@ static irqreturn_t s3cmci_irq(int irq, v
 			goto close_transfer;
 		}
 
-		if (host->complete_what == COMPLETION_XFERFINISH_RSPFIN) {
+		if (host->complete_what == COMPLETION_XFERFINISH_RSPFIN)
 			host->complete_what = COMPLETION_RSPFIN;
-		}
 
 		mci_dclear |= S3C2410_SDIDSTA_XFERFINISH;
 	}
@@ -531,10 +543,9 @@ close_transfer:
 	goto irq_out;
 
 irq_out:
-	dbg(host, dbg_irq, "csta:0x%08x dsta:0x%08x "
-			   "fsta:0x%08x dcnt:0x%08x status:%s.\n",
-				mci_csta, mci_dsta, mci_fsta,
-				mci_dcnt, host->status);
+	dbg(host, dbg_irq,
+	    "csta:0x%08x dsta:0x%08x fsta:0x%08x dcnt:0x%08x status:%s.\n",
+	    mci_csta, mci_dsta, mci_fsta, mci_dcnt, host->status);
 
 	spin_unlock_irqrestore(&host->complete_lock, iflags);
 	return IRQ_HANDLED;
@@ -557,7 +568,7 @@ static irqreturn_t s3cmci_irq_cd(int irq
 }
 
 void s3cmci_dma_done_callback(struct s3c2410_dma_chan *dma_ch, void *buf_id,
-	int size, enum s3c2410_dma_buffresult result)
+			      int size, enum s3c2410_dma_buffresult result)
 {
 	unsigned long iflags;
 	u32 mci_csta, mci_dsta, mci_fsta, mci_dcnt;
@@ -568,11 +579,9 @@ void s3cmci_dma_done_callback(struct s3c
 	mci_fsta 	= readl(host->base + S3C2410_SDIFSTA);
 	mci_dcnt 	= readl(host->base + S3C2410_SDIDCNT);
 
-	if ((!host->mrq) || (!host->mrq) || (!host->mrq->data))
-		return;
-
-	if (!host->dmatogo)
-		return;
+	BUG_ON(!host->mrq);
+	BUG_ON(!host->mrq->data);
+	BUG_ON(!host->dmatogo);
 
 	spin_lock_irqsave(&host->complete_lock, iflags);
 
@@ -616,7 +625,7 @@ fail_request:
 static void finalize_request(struct s3cmci_host *host)
 {
 	struct mmc_request *mrq = host->mrq;
-	struct mmc_command *cmd = host->cmd_is_stop?mrq->stop:mrq->cmd;
+	struct mmc_command *cmd = host->cmd_is_stop ? mrq->stop : mrq->cmd;
 	int debug_as_failure = 0;
 
 	if (host->complete_what != COMPLETION_FINALIZE)
@@ -626,21 +635,19 @@ static void finalize_request(struct s3cm
 		return;
 
 	if (cmd->data && (cmd->error == MMC_ERR_NONE) &&
-		  (cmd->data->error == MMC_ERR_NONE)) {
-
+	    (cmd->data->error == MMC_ERR_NONE)) {
 		if (host->dodma && (!host->dma_complete)) {
 			dbg(host, dbg_dma, "DMA Missing!\n");
 			return;
 		}
 	}
 
-	// Read response
+	/* Read response from controller. */
 	cmd->resp[0] = readl(host->base + S3C2410_SDIRSP0);
 	cmd->resp[1] = readl(host->base + S3C2410_SDIRSP1);
 	cmd->resp[2] = readl(host->base + S3C2410_SDIRSP2);
 	cmd->resp[3] = readl(host->base + S3C2410_SDIRSP3);
 
-	// reset clock speed, as it could still be set low for
 	writel(host->prescaler, host->base + S3C2410_SDIPRE);
 
 	if (cmd->error)
@@ -649,12 +656,10 @@ static void finalize_request(struct s3cm
 	if (cmd->data && cmd->data->error)
 		debug_as_failure = 1;
 
-	//if(cmd->flags & MMC_RSP_MAYFAIL) debug_as_failure = 0;
-
 #ifdef CONFIG_MMC_DEBUG
 	dbg_dumpcmd(host, cmd, debug_as_failure);
 #endif
-	//Cleanup controller
+	/* Cleanup controller */
 	writel(0, host->base + S3C2410_SDICMDARG);
 	writel(0, host->base + S3C2410_SDIDCON);
 	writel(0, host->base + S3C2410_SDICMDCON);
@@ -669,12 +674,11 @@ static void finalize_request(struct s3cm
 		return;
 	}
 
-	// If we have no data transfer we are finished here
+	/* If we have no data transfer we are finished here */
 	if (!mrq->data)
 		goto request_done;
 
-	// Calulate the amout of bytes transfer, but only if there was
-	// no error
+	/* Calulate the amout of bytes transfer if there was no error */
 	if (mrq->data->error == MMC_ERR_NONE) {
 		mrq->data->bytes_xfered =
 			(mrq->data->blocks * mrq->data->blksz);
@@ -682,23 +686,23 @@ static void finalize_request(struct s3cm
 		mrq->data->bytes_xfered = 0;
 	}
 
-	// If we had an error while transfering data we flush the
-	// DMA channel and the fifo to clear out any garbage
+	/* If we had an error while transfering data we flush the
+	 * DMA channel and the fifo to clear out any garbage. */
 	if (mrq->data->error != MMC_ERR_NONE) {
 		if (host->dodma)
 			s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
 
 		if (host->is2440) {
-			//Clear failure register and reset fifo
+			/* Clear failure register and reset fifo. */
 			writel(S3C2440_SDIFSTA_FIFORESET |
 			       S3C2440_SDIFSTA_FIFOFAIL,
 			       host->base + S3C2410_SDIFSTA);
 		} else {
 			u32 mci_con;
 
-			//reset fifo
+			/* reset fifo */
 			mci_con = readl(host->base + S3C2410_SDICON);
-			mci_con|= S3C2410_SDICON_FIFORESET;
+			mci_con |= S3C2410_SDICON_FIFORESET;
 
 			writel(mci_con, host->base + S3C2410_SDICON);
 		}
@@ -713,8 +717,8 @@ request_done:
 
 void s3cmci_dma_setup(struct s3cmci_host *host, enum s3c2410_dmasrc source)
 {
-	static int setup_ok = 0;
 	static enum s3c2410_dmasrc last_source = -1;
+	static int setup_ok;
 
 	if (last_source == source)
 		return;
@@ -727,7 +731,8 @@ void s3cmci_dma_setup(struct s3cmci_host
 	if (!setup_ok) {
 		s3c2410_dma_config(host->dma, 4,
 			(S3C2410_DCON_HWTRIG | S3C2410_DCON_CH0_SDI));
-		s3c2410_dma_set_buffdone_fn(host->dma, s3cmci_dma_done_callback);
+		s3c2410_dma_set_buffdone_fn(host->dma,
+					    s3cmci_dma_done_callback);
 		s3c2410_dma_setflags(host->dma, S3C2410_DMAF_AUTOSTART);
 		setup_ok = 1;
 	}
@@ -744,31 +749,30 @@ static void s3cmci_send_command(struct s
 
 	enable_imask(host, imsk);
 
-	if (cmd->data) {
+	if (cmd->data)
 		host->complete_what = COMPLETION_XFERFINISH_RSPFIN;
-	} else if (cmd->flags & MMC_RSP_PRESENT) {
+	else if (cmd->flags & MMC_RSP_PRESENT)
 		host->complete_what = COMPLETION_RSPFIN;
-	} else {
+	else
 		host->complete_what = COMPLETION_CMDSENT;
-	}
 
 	writel(cmd->arg, host->base + S3C2410_SDICMDARG);
 
-	ccon = cmd->opcode & S3C2410_SDICMDCON_INDEX;
-	ccon|= S3C2410_SDICMDCON_SENDERHOST | S3C2410_SDICMDCON_CMDSTART;
+	ccon  = cmd->opcode & S3C2410_SDICMDCON_INDEX;
+	ccon |= S3C2410_SDICMDCON_SENDERHOST | S3C2410_SDICMDCON_CMDSTART;
 
 	if (cmd->flags & MMC_RSP_PRESENT)
 		ccon |= S3C2410_SDICMDCON_WAITRSP;
 
 	if (cmd->flags & MMC_RSP_136)
-		ccon|= S3C2410_SDICMDCON_LONGRSP;
+		ccon |= S3C2410_SDICMDCON_LONGRSP;
 
 	writel(ccon, host->base + S3C2410_SDICMDCON);
 }
 
 static int s3cmci_setup_data(struct s3cmci_host *host, struct mmc_data *data)
 {
-	u32 dcon, imsk, stoptries=3;
+	u32 dcon, imsk, stoptries = 3;
 
 	/* write DCON register */
 
@@ -777,16 +781,16 @@ static int s3cmci_setup_data(struct s3cm
 		return 0;
 	}
 
-	while(readl(host->base + S3C2410_SDIDSTA) &
-		(S3C2410_SDIDSTA_TXDATAON | S3C2410_SDIDSTA_RXDATAON)) {
+	while (readl(host->base + S3C2410_SDIDSTA) &
+	       (S3C2410_SDIDSTA_TXDATAON | S3C2410_SDIDSTA_RXDATAON)) {
 
 		dbg(host, dbg_err,
-			"mci_setup_data() transfer stillin progress.\n");
+		    "mci_setup_data() transfer stillin progress.\n");
 
 		writel(0, host->base + S3C2410_SDIDCON);
 		s3cmci_reset(host);
 
-		if (0 == (stoptries--)) {
+		if ((stoptries--) == 0) {
 #ifdef CONFIG_MMC_DEBUG
 			dbg_dumpregs(host, "DRF");
 #endif
@@ -797,17 +801,14 @@ static int s3cmci_setup_data(struct s3cm
 
 	dcon  = data->blocks & S3C2410_SDIDCON_BLKNUM_MASK;
 
-	if (host->dodma) {
+	if (host->dodma)
 		dcon |= S3C2410_SDIDCON_DMAEN;
-	}
 
-	if (host->bus_width == MMC_BUS_WIDTH_4) {
+	if (host->bus_width == MMC_BUS_WIDTH_4)
 		dcon |= S3C2410_SDIDCON_WIDEBUS;
-	}
 
-	if (!(data->flags & MMC_DATA_STREAM)) {
+	if (!(data->flags & MMC_DATA_STREAM))
 		dcon |= S3C2410_SDIDCON_BLOCKMODE;
-	}
 
 	if (data->flags & MMC_DATA_WRITE) {
 		dcon |= S3C2410_SDIDCON_TXAFTERRESP;
@@ -831,8 +832,8 @@ static int s3cmci_setup_data(struct s3cm
 	writel(data->blksz, host->base + S3C2410_SDIBSIZE);
 
 	/* add to IMASK register */
-	imsk =	S3C2410_SDIIMSK_FIFOFAIL | S3C2410_SDIIMSK_DATACRC |
-		S3C2410_SDIIMSK_DATATIMEOUT | S3C2410_SDIIMSK_DATAFINISH;
+	imsk = S3C2410_SDIIMSK_FIFOFAIL | S3C2410_SDIIMSK_DATACRC |
+	       S3C2410_SDIIMSK_DATATIMEOUT | S3C2410_SDIIMSK_DATAFINISH;
 
 	enable_imask(host, imsk);
 
@@ -843,35 +844,33 @@ static int s3cmci_setup_data(struct s3cm
 	} else {
 		writel(0x0000FFFF, host->base + S3C2410_SDITIMER);
 
-		//FIX: set slow clock to prevent timeouts on read
-		if (data->flags & MMC_DATA_READ) {
+		/* FIX: set slow clock to prevent timeouts on read */
+		if (data->flags & MMC_DATA_READ)
 			writel(0xFF, host->base + S3C2410_SDIPRE);
-		}
 	}
 
-	//debug_dump_registers(host, "Data setup:");
-
 	return 0;
 }
 
+#define BOTH_DIR (MMC_DATA_WRITE | MMC_DATA_READ)
+
 static int s3cmci_prepare_pio(struct s3cmci_host *host, struct mmc_data *data)
 {
-	int rw = (data->flags & MMC_DATA_WRITE)?1:0;
+	int rw = (data->flags & MMC_DATA_WRITE) ? 1 : 0;
 
-	if (rw != ((data->flags & MMC_DATA_READ)?0:1))
-		return -EINVAL;
+	BUG_ON((data->flags & BOTH_DIR) == BOTH_DIR);
 
 	host->pio_sgptr = 0;
 	host->pio_words = 0;
 	host->pio_count = 0;
-	host->pio_active = rw?XFER_WRITE:XFER_READ;
+	host->pio_active = rw ? XFER_WRITE : XFER_READ;
 
 	if (rw) {
 		do_pio_write(host);
 		enable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
 	} else {
 		enable_imask(host, S3C2410_SDIIMSK_RXFIFOHALF
-			| S3C2410_SDIIMSK_RXFIFOLAST);
+			     | S3C2410_SDIIMSK_RXFIFOLAST);
 	}
 
 	return 0;
@@ -880,18 +879,15 @@ static int s3cmci_prepare_pio(struct s3c
 static int s3cmci_prepare_dma(struct s3cmci_host *host, struct mmc_data *data)
 {
 	int dma_len, i;
+	int rw = (data->flags & MMC_DATA_WRITE) ? 1 : 0;
 
-	int rw = (data->flags & MMC_DATA_WRITE)?1:0;
-
-	if (rw != ((data->flags & MMC_DATA_READ)?0:1))
-		return -EINVAL;
+	BUG_ON((data->flags & BOTH_DIR) == BOTH_DIR);
 
-	s3cmci_dma_setup(host, rw?S3C2410_DMASRC_MEM:S3C2410_DMASRC_HW);
+	s3cmci_dma_setup(host, rw ? S3C2410_DMASRC_MEM : S3C2410_DMASRC_HW);
 	s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
 
 	dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
-				(rw)?DMA_TO_DEVICE:DMA_FROM_DEVICE);
-
+			     (rw) ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
 	if (dma_len == 0)
 		return -ENOMEM;
@@ -907,14 +903,14 @@ static int s3cmci_prepare_dma(struct s3c
 			sg_dma_len(&data->sg[i]));
 
 		res = s3c2410_dma_enqueue(host->dma, (void *) host,
-				sg_dma_address(&data->sg[i]),
-				sg_dma_len(&data->sg[i]));
+					  sg_dma_address(&data->sg[i]),
+					  sg_dma_len(&data->sg[i]));
 
 		if (res) {
 			s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
 			return -EBUSY;
 		}
- 	}
+	}
 
 	s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_START);
 
@@ -925,21 +921,21 @@ static void s3cmci_send_request(struct m
 {
 	struct s3cmci_host *host = mmc_priv(mmc);
 	struct mmc_request *mrq = host->mrq;
-	struct mmc_command *cmd = host->cmd_is_stop?mrq->stop:mrq->cmd;
+	struct mmc_command *cmd = host->cmd_is_stop ? mrq->stop : mrq->cmd;
 
 	host->ccnt++;
 #ifdef CONFIG_MMC_DEBUG
 	prepare_dbgmsg(host, cmd, host->cmd_is_stop);
 #endif
-	//Clear command, data and fifo status registers
-	//Fifo clear only necessary on 2440, but doesn't hurt on 2410
+	/* Clear command, data and fifo status registers
+	   Fifo clear only necessary on 2440, but doesn't hurt on 2410
+	*/
 	writel(0xFFFFFFFF, host->base + S3C2410_SDICMDSTAT);
 	writel(0xFFFFFFFF, host->base + S3C2410_SDIDSTA);
 	writel(0xFFFFFFFF, host->base + S3C2410_SDIFSTA);
 
 	if (cmd->data) {
-		int res;
-		res = s3cmci_setup_data(host, cmd->data);
+		int res = s3cmci_setup_data(host, cmd->data);
 
 		host->dcnt++;
 
@@ -951,12 +947,10 @@ static void s3cmci_send_request(struct m
 			return;
 		}
 
-
-		if (host->dodma) {
+		if (host->dodma)
 			res = s3cmci_prepare_dma(host, cmd->data);
-		} else {
+		else
 			res = s3cmci_prepare_pio(host, cmd->data);
-		}
 
 		if (res) {
 			cmd->error = MMC_ERR_DMA;
@@ -968,16 +962,16 @@ static void s3cmci_send_request(struct m
 
 	}
 
-	// Send command
+	/* Send command */
 	s3cmci_send_command(host, cmd);
 
-	// Enable Interrupt
+	/* Enable Interrupt */
 	enable_irq(host->irq);
 }
 
 static void s3cmci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
- 	struct s3cmci_host *host = mmc_priv(mmc);
+	struct s3cmci_host *host = mmc_priv(mmc);
 
 	host->cmd_is_stop = 0;
 	host->mrq = mrq;
@@ -990,62 +984,64 @@ static void s3cmci_set_ios(struct mmc_ho
 	struct s3cmci_host *host = mmc_priv(mmc);
 	u32 mci_psc, mci_con;
 
-	//Set power
-	mci_con = readl(host->base + S3C2410_SDICON);
-	switch(ios->power_mode) {
-		case MMC_POWER_ON:
-		case MMC_POWER_UP:
-			s3c2410_gpio_cfgpin(S3C2410_GPE5, S3C2410_GPE5_SDCLK);
-			s3c2410_gpio_cfgpin(S3C2410_GPE6, S3C2410_GPE6_SDCMD);
-			s3c2410_gpio_cfgpin(S3C2410_GPE7, S3C2410_GPE7_SDDAT0);
-			s3c2410_gpio_cfgpin(S3C2410_GPE8, S3C2410_GPE8_SDDAT1);
-			s3c2410_gpio_cfgpin(S3C2410_GPE9, S3C2410_GPE9_SDDAT2);
-			s3c2410_gpio_cfgpin(S3C2410_GPE10, S3C2410_GPE10_SDDAT3);
-
-			if (!host->is2440)
-				mci_con|=S3C2410_SDICON_FIFORESET;
+	/* Set the power state */
 
-			break;
+	mci_con = readl(host->base + S3C2410_SDICON);
 
-		case MMC_POWER_OFF:
-		default:
-			s3c2410_gpio_setpin(S3C2410_GPE5, 0);
-			s3c2410_gpio_cfgpin(S3C2410_GPE5, S3C2410_GPE5_OUTP);
+	switch (ios->power_mode) {
+	case MMC_POWER_ON:
+	case MMC_POWER_UP:
+		s3c2410_gpio_cfgpin(S3C2410_GPE5, S3C2410_GPE5_SDCLK);
+		s3c2410_gpio_cfgpin(S3C2410_GPE6, S3C2410_GPE6_SDCMD);
+		s3c2410_gpio_cfgpin(S3C2410_GPE7, S3C2410_GPE7_SDDAT0);
+		s3c2410_gpio_cfgpin(S3C2410_GPE8, S3C2410_GPE8_SDDAT1);
+		s3c2410_gpio_cfgpin(S3C2410_GPE9, S3C2410_GPE9_SDDAT2);
+		s3c2410_gpio_cfgpin(S3C2410_GPE10, S3C2410_GPE10_SDDAT3);
+
+		if (!host->is2440)
+			mci_con |= S3C2410_SDICON_FIFORESET;
+
+		break;
+
+	case MMC_POWER_OFF:
+	default:
+		s3c2410_gpio_setpin(S3C2410_GPE5, 0);
+		s3c2410_gpio_cfgpin(S3C2410_GPE5, S3C2410_GPE5_OUTP);
 
-			if (host->is2440)
-				mci_con|=S3C2440_SDICON_SDRESET;
+		if (host->is2440)
+			mci_con |= S3C2440_SDICON_SDRESET;
 
-			break;
+		break;
 	}
 
-	//Set clock
-	for (mci_psc=0; mci_psc<255; mci_psc++) {
+	/* Set clock */
+	for (mci_psc = 0; mci_psc < 255; mci_psc++) {
 		host->real_rate = host->clk_rate / (host->clk_div*(mci_psc+1));
 
 		if (host->real_rate <= ios->clock)
 			break;
 	}
 
-	if(mci_psc > 255) mci_psc = 255;
-	host->prescaler = mci_psc;
+	if (mci_psc > 255)
+		mci_psc = 255;
 
+	host->prescaler = mci_psc;
 	writel(host->prescaler, host->base + S3C2410_SDIPRE);
 
-	//If requested clock is 0, real_rate will be 0, too
+	/* If requested clock is 0, real_rate will be 0, too */
 	if (ios->clock == 0)
 		host->real_rate = 0;
 
-	//Set CLOCK_ENABLE
+	/* Set CLOCK_ENABLE */
 	if (ios->clock)
 		mci_con |= S3C2410_SDICON_CLOCKTYPE;
 	else
-		mci_con &=~S3C2410_SDICON_CLOCKTYPE;
+		mci_con &= ~S3C2410_SDICON_CLOCKTYPE;
 
 	writel(mci_con, host->base + S3C2410_SDICON);
 
-	if ((ios->power_mode==MMC_POWER_ON)
-		|| (ios->power_mode==MMC_POWER_UP)) {
-
+	if ((ios->power_mode == MMC_POWER_ON) ||
+	    (ios->power_mode == MMC_POWER_UP)) {
 		dbg(host, dbg_conf, "running at %lukHz (requested: %ukHz).\n",
 			host->real_rate/1000, ios->clock/1000);
 	} else {
@@ -1053,7 +1049,6 @@ static void s3cmci_set_ios(struct mmc_ho
 	}
 
 	host->bus_width = ios->bus_width;
-
 }
 
 static void s3cmci_reset(struct s3cmci_host *host)
@@ -1061,7 +1056,6 @@ static void s3cmci_reset(struct s3cmci_h
 	u32 con = readl(host->base + S3C2410_SDICON);
 
 	con |= S3C2440_SDICON_SDRESET;
-
 	writel(con, host->base + S3C2410_SDICON);
 }
 
@@ -1086,20 +1080,21 @@ static int s3cmci_probe(struct platform_
 	host = mmc_priv(mmc);
 	host->mmc 	= mmc;
 	host->pdev	= pdev;
+	host->is2440	= is2440;
 
 	spin_lock_init(&host->complete_lock);
 	tasklet_init(&host->pio_tasklet, pio_tasklet, (unsigned long) host);
+
 	if (is2440) {
-		host->is2440	= 1;
 		host->sdiimsk	= S3C2440_SDIIMSK;
 		host->sdidata	= S3C2440_SDIDATA;
 		host->clk_div	= 1;
 	} else {
-		host->is2440	= 0;
 		host->sdiimsk	= S3C2410_SDIIMSK;
 		host->sdidata	= S3C2410_SDIDATA;
 		host->clk_div	= 2;
 	}
+
 	host->dodma		= 0;
 	host->complete_what 	= COMPLETION_NONE;
 	host->pio_active 	= XFER_NONE;
@@ -1153,7 +1148,6 @@ static int s3cmci_probe(struct platform_
 	if (request_irq(host->irq_cd, s3cmci_irq_cd, 0, DRIVER_NAME, host)) {
 		dev_err(&pdev->dev,
 			"failed to request card detect interrupt.\n");
-
 		ret = -ENOENT;
 		goto probe_free_irq;
 	}
@@ -1172,7 +1166,8 @@ static int s3cmci_probe(struct platform_
 		goto probe_free_host;
 	}
 
-	if ((ret = clk_enable(host->clk))) {
+	ret = clk_enable(host->clk);
+	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock source.\n");
 		goto clk_free;
 	}
@@ -1193,18 +1188,20 @@ static int s3cmci_probe(struct platform_
 	mmc->max_phys_segs	= 128;
 	mmc->max_hw_segs	= 128;
 
-	dbg(host, dbg_debug, "probe: mode:%s mapped mci_base:%p irq:%u irq_cd:%u dma:%u.\n",
-		(host->is2440?"2440":""),
-		host->base, host->irq, host->irq_cd, host->dma);
+	dbg(host, dbg_debug,
+	    "probe: mode:%s mapped mci_base:%p irq:%u irq_cd:%u dma:%u.\n",
+	    (host->is2440?"2440":""),
+	    host->base, host->irq, host->irq_cd, host->dma);
 
-	if ((ret = mmc_add_host(mmc))) {
+	ret = mmc_add_host(mmc);
+	if (ret) {
 		dev_err(&pdev->dev, "failed to add mmc host.\n");
 		goto free_dmabuf;
 	}
 
 	platform_set_drvdata(pdev, mmc);
+	dev_info(&pdev->dev, "initialisation done.\n");
 
-	dev_info(&pdev->dev,"initialisation done.\n");
 	return 0;
 
  free_dmabuf:
@@ -1214,10 +1211,10 @@ static int s3cmci_probe(struct platform_
 	clk_put(host->clk);
 
  probe_free_irq_cd:
- 	free_irq(host->irq_cd, host);
+	free_irq(host->irq_cd, host);
 
  probe_free_irq:
- 	free_irq(host->irq, host);
+	free_irq(host->irq, host);
 
  probe_iounmap:
 	iounmap(host->base);
@@ -1237,14 +1234,19 @@ static int s3cmci_remove(struct platform
 	struct s3cmci_host 	*host = mmc_priv(mmc);
 
 	mmc_remove_host(mmc);
+
 	clk_disable(host->clk);
 	clk_put(host->clk);
- 	free_irq(host->irq_cd, host);
- 	free_irq(host->irq, host);
+
+	tasklet_disable(&host->pio_tasklet);
+
+	free_irq(host->irq_cd, host);
+	free_irq(host->irq, host);
+
 	iounmap(host->base);
 	release_mem_region(host->mem->start, RESSIZE(host->mem));
-	mmc_free_host(mmc);
 
+	mmc_free_host(mmc);
 	return 0;
 }
 
@@ -1285,27 +1287,27 @@ static int s3cmci_resume(struct platform
 #endif /* CONFIG_PM */
 
 
-static struct platform_driver s3cmci_driver_2410 =
-{
+static struct platform_driver s3cmci_driver_2410 = {
 	.driver.name	= "s3c2410-sdi",
+	.driver.owner	= THIS_MODULE,
 	.probe		= s3cmci_probe_2410,
 	.remove		= s3cmci_remove,
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
 
-static struct platform_driver s3cmci_driver_2412 =
-{
+static struct platform_driver s3cmci_driver_2412 = {
 	.driver.name	= "s3c2412-sdi",
+	.driver.owner	= THIS_MODULE,
 	.probe		= s3cmci_probe_2412,
 	.remove		= s3cmci_remove,
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
 
-static struct platform_driver s3cmci_driver_2440 =
-{
+static struct platform_driver s3cmci_driver_2440 = {
 	.driver.name	= "s3c2440-sdi",
+	.driver.owner	= THIS_MODULE,
 	.probe		= s3cmci_probe_2440,
 	.remove		= s3cmci_remove,
 	.suspend	= s3cmci_suspend,
@@ -1334,4 +1336,3 @@ module_exit(s3cmci_exit);
 MODULE_DESCRIPTION("Samsung S3C MMC/SD Card Interface driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Thomas Kleffel <tk@maintech.de>");
-
Index: linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.h
===================================================================
--- linux-2.6.26-rc5-q2.orig/drivers/mmc/host/s3cmci.h	2008-06-07 12:25:27.000000000 +0100
+++ linux-2.6.26-rc5-q2/drivers/mmc/host/s3cmci.h	2008-06-16 15:13:28.000000000 +0100
@@ -8,7 +8,7 @@
  * published by the Free Software Foundation.
  */
 
-//FIXME: DMA Resource management ?!
+/* FIXME: DMA Resource management ?! */
 #define S3CMCI_DMA 0
 
 enum s3cmci_waitfor {
@@ -39,32 +39,30 @@ struct s3cmci_host {
 	unsigned		sdiimsk;
 	unsigned		sdidata;
 	int			dodma;
-
-	volatile int		dmatogo;
+	int			dmatogo;
 
 	struct mmc_request	*mrq;
 	int			cmd_is_stop;
 
 	spinlock_t		complete_lock;
-	volatile enum s3cmci_waitfor
-				complete_what;
+	enum s3cmci_waitfor	complete_what;
 
-	volatile int		dma_complete;
+	int			dma_complete;
 
-	volatile u32		pio_sgptr;
-	volatile u32		pio_words;
-	volatile u32		pio_count;
-	volatile u32		*pio_ptr;
+	u32			pio_sgptr;
+	u32			pio_words;
+	u32			pio_count;
+	u32			*pio_ptr;
 #define XFER_NONE 0
 #define XFER_READ 1
 #define XFER_WRITE 2
-	volatile u32		pio_active;
+	u32			pio_active;
 
 	int			bus_width;
 
 	char 			dbgmsg_cmd[301];
 	char 			dbgmsg_dat[301];
-	volatile char		*status;
+	char			*status;
 
 	unsigned int		ccnt, dcnt;
 	struct tasklet_struct	pio_tasklet;

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
