Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXJVSPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXJVSPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbXJVSMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:36 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22189 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbXJVSM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:27 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 04/10] [SG] Update drivers to use sg helpers
Date: Mon, 22 Oct 2007 20:10:58 +0200
Message-Id: <1193076664-13652-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/um/drivers/ubd_kern.c                  |    2 +-
 drivers/ata/libata-core.c                   |   10 ++++----
 drivers/ata/libata-scsi.c                   |    2 +-
 drivers/block/DAC960.c                      |    2 +
 drivers/block/cciss.c                       |    4 +-
 drivers/block/cpqarray.c                    |    3 +-
 drivers/block/cryptoloop.c                  |   12 ++++++---
 drivers/block/sunvdc.c                      |    1 +
 drivers/block/ub.c                          |   11 +++++----
 drivers/block/viodasd.c                     |    2 +
 drivers/ide/cris/ide-cris.c                 |    4 +-
 drivers/ide/ide-probe.c                     |    4 ++-
 drivers/ide/ide-taskfile.c                  |    2 +-
 drivers/ide/mips/au1xxx-ide.c               |    6 +---
 drivers/ieee1394/dma.c                      |    2 +-
 drivers/ieee1394/sbp2.c                     |    2 +-
 drivers/infiniband/core/umem.c              |   11 ++++++---
 drivers/infiniband/hw/ipath/ipath_dma.c     |    4 +-
 drivers/infiniband/hw/ipath/ipath_mr.c      |    2 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c |   24 ++++++++++++-------
 drivers/infiniband/ulp/iser/iser_memory.c   |    8 +++---
 drivers/md/dm-crypt.c                       |   21 +++++++++--------
 drivers/media/common/saa7146_core.c         |    3 +-
 drivers/media/video/ivtv/ivtv-udma.c        |    4 +-
 drivers/media/video/videobuf-dma-sg.c       |    8 ++++--
 drivers/mmc/card/queue.c                    |   15 ++++++------
 drivers/mmc/host/at91_mci.c                 |    8 +++---
 drivers/mmc/host/au1xmmc.c                  |   11 +++------
 drivers/mmc/host/imxmmc.c                   |    2 +-
 drivers/mmc/host/mmc_spi.c                  |    8 +++---
 drivers/mmc/host/omap.c                     |    4 +-
 drivers/mmc/host/sdhci.c                    |    2 +-
 drivers/mmc/host/tifm_sd.c                  |    8 +++---
 drivers/mmc/host/wbsd.c                     |    6 ++--
 drivers/net/mlx4/icm.c                      |   14 +++++++----
 drivers/net/ppp_mppe.c                      |    6 +---
 drivers/scsi/3w-9xxx.c                      |    4 +-
 drivers/scsi/3w-xxxx.c                      |    2 +-
 drivers/scsi/NCR5380.c                      |    6 +---
 drivers/scsi/NCR53c406a.c                   |    6 +---
 drivers/scsi/aacraid/aachba.c               |    2 +-
 drivers/scsi/aha152x.c                      |    2 +-
 drivers/scsi/aha1542.c                      |    8 ++----
 drivers/scsi/arcmsr/arcmsr_hba.c            |    4 +-
 drivers/scsi/fd_mcs.c                       |    6 ++--
 drivers/scsi/fdomain.c                      |    7 ++---
 drivers/scsi/gdth.c                         |    4 +-
 drivers/scsi/ibmmca.c                       |    2 +-
 drivers/scsi/ide-scsi.c                     |   12 +++++-----
 drivers/scsi/imm.c                          |    8 +-----
 drivers/scsi/in2000.c                       |    4 +-
 drivers/scsi/ipr.c                          |   19 ++++++++++------
 drivers/scsi/ips.c                          |    6 ++--
 drivers/scsi/iscsi_tcp.c                    |   15 ++++++------
 drivers/scsi/megaraid.c                     |    8 ++----
 drivers/scsi/megaraid/megaraid_mbox.c       |   12 +++------
 drivers/scsi/osst.c                         |   32 ++++++++++++++------------
 drivers/scsi/pcmcia/nsp_cs.h                |    2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c          |    6 +---
 drivers/scsi/ppa.c                          |    7 +----
 drivers/scsi/qlogicfas408.c                 |    2 +-
 drivers/scsi/scsi_debug.c                   |    4 +-
 drivers/scsi/scsi_lib.c                     |   13 ++++++++--
 drivers/scsi/seagate.c                      |    8 +++---
 drivers/scsi/sg.c                           |   30 ++++++++++++------------
 drivers/scsi/st.c                           |    8 +++---
 drivers/scsi/sym53c416.c                    |    2 +-
 drivers/scsi/tmscsim.c                      |    5 +---
 drivers/scsi/ultrastor.c                    |    2 +-
 drivers/scsi/wd7000.c                       |    2 +-
 drivers/usb/core/message.c                  |    6 +---
 drivers/usb/image/microtek.c                |    5 +--
 drivers/usb/misc/usbtest.c                  |    4 +-
 drivers/usb/storage/protocol.c              |    2 +-
 74 files changed, 262 insertions(+), 253 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 25b248a..3a8cd3d 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1115,7 +1115,7 @@ static void do_ubd_request(struct request_queue *q)
 			}
 			prepare_request(req, io_req,
 					(unsigned long long) req->sector << 9,
-					sg->offset, sg->length, sg->page);
+					sg->offset, sg->length, sg_page(sg));
 
 			last_sectors = sg->length >> 9;
 			n = os_write_file(thread_fd, &io_req,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 629eadb..69092bc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4296,7 +4296,7 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 		sg_last(sg, qc->orig_n_elem)->length += qc->pad_len;
 		if (pad_buf) {
 			struct scatterlist *psg = &qc->pad_sgent;
-			void *addr = kmap_atomic(psg->page, KM_IRQ0);
+			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
 			memcpy(addr + psg->offset, pad_buf, qc->pad_len);
 			kunmap_atomic(addr, KM_IRQ0);
 		}
@@ -4686,11 +4686,11 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 		 * data in this function or read data in ata_sg_clean.
 		 */
 		offset = lsg->offset + lsg->length - qc->pad_len;
-		psg->page = nth_page(lsg->page, offset >> PAGE_SHIFT);
+		sg_set_page(psg, nth_page(sg_page(lsg), offset >> PAGE_SHIFT));
 		psg->offset = offset_in_page(offset);
 
 		if (qc->tf.flags & ATA_TFLAG_WRITE) {
-			void *addr = kmap_atomic(psg->page, KM_IRQ0);
+			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
 			memcpy(pad_buf, addr + psg->offset, qc->pad_len);
 			kunmap_atomic(addr, KM_IRQ0);
 		}
@@ -4836,7 +4836,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	if (qc->curbytes == qc->nbytes - qc->sect_size)
 		ap->hsm_task_state = HSM_ST_LAST;
 
-	page = qc->cursg->page;
+	page = sg_page(qc->cursg);
 	offset = qc->cursg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
@@ -4988,7 +4988,7 @@ next_sg:
 
 	sg = qc->cursg;
 
-	page = sg->page;
+	page = sg_page(sg);
 	offset = sg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9fbb39c..5b758b9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1544,7 +1544,7 @@ static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
 	struct scatterlist *sg = scsi_sglist(cmd);
 
 	if (sg) {
-		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+		buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 		buflen = sg->length;
 	} else {
 		buf = NULL;
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 84d6aa5..5350542 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -345,6 +345,7 @@ static bool DAC960_CreateAuxiliaryStructures(DAC960_Controller_T *Controller)
 	Command->V1.ScatterGatherList =
 		(DAC960_V1_ScatterGatherSegment_T *)ScatterGatherCPU;
 	Command->V1.ScatterGatherListDMA = ScatterGatherDMA;
+	sg_init_table(Command->cmd_sglist, DAC960_V1_ScatterGatherLimit);
       } else {
         Command->cmd_sglist = Command->V2.ScatterList;
 	Command->V2.ScatterGatherList =
@@ -353,6 +354,7 @@ static bool DAC960_CreateAuxiliaryStructures(DAC960_Controller_T *Controller)
 	Command->V2.RequestSense =
 				(DAC960_SCSI_RequestSense_T *)RequestSenseCPU;
 	Command->V2.RequestSenseDMA = RequestSenseDMA;
+	sg_init_table(Command->cmd_sglist, DAC960_V2_ScatterGatherLimit);
       }
     }
   return true;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 7c2cfde..5a6fe17 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2610,7 +2610,7 @@ static void do_cciss_request(struct request_queue *q)
 	       (int)creq->nr_sectors);
 #endif				/* CCISS_DEBUG */
 
-	memset(tmp_sg, 0, sizeof(tmp_sg));
+	sg_init_table(tmp_sg, MAXSGENTRIES);
 	seg = blk_rq_map_sg(q, creq, tmp_sg);
 
 	/* get the DMA records for the setup */
@@ -2621,7 +2621,7 @@ static void do_cciss_request(struct request_queue *q)
 
 	for (i = 0; i < seg; i++) {
 		c->SG[i].Len = tmp_sg[i].length;
-		temp64.val = (__u64) pci_map_page(h->pdev, tmp_sg[i].page,
+		temp64.val = (__u64) pci_map_page(h->pdev, sg_page(&tmp_sg[i]),
 						  tmp_sg[i].offset,
 						  tmp_sg[i].length, dir);
 		c->SG[i].Addr.lower = temp64.val32.lower;
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 568603d..efab27f 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -918,6 +918,7 @@ queue_next:
 DBGPX(
 	printk("sector=%d, nr_sectors=%d\n", creq->sector, creq->nr_sectors);
 );
+	sg_init_table(tmp_sg, SG_MAX);
 	seg = blk_rq_map_sg(q, creq, tmp_sg);
 
 	/* Now do all the DMA Mappings */
@@ -929,7 +930,7 @@ DBGPX(
 	{
 		c->req.sg[i].size = tmp_sg[i].length;
 		c->req.sg[i].addr = (__u32) pci_map_page(h->pci_dev,
-						 tmp_sg[i].page,
+						 sg_page(&tmp_sg[i]),
 						 tmp_sg[i].offset,
 						 tmp_sg[i].length, dir);
 	}
diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 4053503..1b58b01 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -26,6 +26,7 @@
 #include <linux/crypto.h>
 #include <linux/blkdev.h>
 #include <linux/loop.h>
+#include <linux/scatterlist.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
@@ -119,14 +120,17 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
 		.tfm = tfm,
 		.flags = CRYPTO_TFM_REQ_MAY_SLEEP,
 	};
-	struct scatterlist sg_out = { NULL, };
-	struct scatterlist sg_in = { NULL, };
+	struct scatterlist sg_out;
+	struct scatterlist sg_in;
 
 	encdec_cbc_t encdecfunc;
 	struct page *in_page, *out_page;
 	unsigned in_offs, out_offs;
 	int err;
 
+	sg_init_table(&sg_out, 1);
+	sg_init_table(&sg_in, 1);
+
 	if (cmd == READ) {
 		in_page = raw_page;
 		in_offs = raw_off;
@@ -146,11 +150,11 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
 		u32 iv[4] = { 0, };
 		iv[0] = cpu_to_le32(IV & 0xffffffff);
 
-		sg_in.page = in_page;
+		sg_set_page(&sg_in, in_page);
 		sg_in.offset = in_offs;
 		sg_in.length = sz;
 
-		sg_out.page = out_page;
+		sg_set_page(&sg_out, out_page);
 		sg_out.offset = out_offs;
 		sg_out.length = sz;
 
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 317a790..7276f7d 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -388,6 +388,7 @@ static int __send_request(struct request *req)
 		op = VD_OP_BWRITE;
 	}
 
+	sg_init_table(sg, port->ring_cookies);
 	nsg = blk_rq_map_sg(req->q, req, sg);
 
 	len = 0;
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index c57dd2b..14143f2 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -25,6 +25,7 @@
 #include <linux/usb_usual.h>
 #include <linux/blkdev.h>
 #include <linux/timer.h>
+#include <linux/scatterlist.h>
 #include <scsi/scsi.h>
 
 #define DRV_NAME "ub"
@@ -656,6 +657,7 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 	if ((cmd = ub_get_cmd(lun)) == NULL)
 		return -1;
 	memset(cmd, 0, sizeof(struct ub_scsi_cmd));
+	sg_init_table(cmd->sgv, UB_MAX_REQ_SG);
 
 	blkdev_dequeue_request(rq);
 
@@ -1309,9 +1311,8 @@ static void ub_data_start(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 	else
 		pipe = sc->send_bulk_pipe;
 	sc->last_pipe = pipe;
-	usb_fill_bulk_urb(&sc->work_urb, sc->dev, pipe,
-	    page_address(sg->page) + sg->offset, sg->length,
-	    ub_urb_complete, sc);
+	usb_fill_bulk_urb(&sc->work_urb, sc->dev, pipe, sg_virt(sg),
+	    sg->length, ub_urb_complete, sc);
 	sc->work_urb.actual_length = 0;
 	sc->work_urb.error_count = 0;
 	sc->work_urb.status = 0;
@@ -1427,7 +1428,7 @@ static void ub_state_sense(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 	scmd->state = UB_CMDST_INIT;
 	scmd->nsg = 1;
 	sg = &scmd->sgv[0];
-	sg->page = virt_to_page(sc->top_sense);
+	sg_set_page(sg, virt_to_page(sc->top_sense));
 	sg->offset = (unsigned long)sc->top_sense & (PAGE_SIZE-1);
 	sg->length = UB_SENSE_SIZE;
 	scmd->len = UB_SENSE_SIZE;
@@ -1863,7 +1864,7 @@ static int ub_sync_read_cap(struct ub_dev *sc, struct ub_lun *lun,
 	cmd->state = UB_CMDST_INIT;
 	cmd->nsg = 1;
 	sg = &cmd->sgv[0];
-	sg->page = virt_to_page(p);
+	sg_set_page(sg, virt_to_page(p));
 	sg->offset = (unsigned long)p & (PAGE_SIZE-1);
 	sg->length = 8;
 	cmd->len = 8;
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index e824b67..ab5d404 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -41,6 +41,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/completion.h>
 #include <linux/device.h>
+#include <linux/scatterlist.h>
 
 #include <asm/uaccess.h>
 #include <asm/vio.h>
@@ -270,6 +271,7 @@ static int send_request(struct request *req)
         d = req->rq_disk->private_data;
 
 	/* Now build the scatter-gather list */
+	sg_init_table(sg, VIOMAXBLOCKDMA);
 	nsg = blk_rq_map_sg(req->q, req, sg);
 	nsg = dma_map_sg(d->dev, sg, nsg, direction);
 
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index ff20377..e196aef 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -935,11 +935,11 @@ static int cris_ide_build_dmatable (ide_drive_t *drive)
 		 * than two possibly non-adjacent physical 4kB pages.
 		 */
 		/* group sequential buffers into one large buffer */
-		addr = page_to_phys(sg->page) + sg->offset;
+		addr = sg_phys(sg);
 		size = sg_dma_len(sg);
 		while (--i) {
 			sg = sg_next(sg);
-			if ((addr + size) != page_to_phys(sg->page) + sg->offset)
+			if ((addr + size) != sg_phys(sg))
 				break;
 			size += sg_dma_len(sg);
 		}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index d5146c5..ec55a17 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1317,12 +1317,14 @@ static int hwif_init(ide_hwif_t *hwif)
 	if (!hwif->sg_max_nents)
 		hwif->sg_max_nents = PRD_ENTRIES;
 
-	hwif->sg_table = kzalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
+	hwif->sg_table = kmalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
 				 GFP_KERNEL);
 	if (!hwif->sg_table) {
 		printk(KERN_ERR "%s: unable to allocate SG table.\n", hwif->name);
 		goto out;
 	}
+
+	sg_init_table(hwif->sg_table, hwif->sg_max_nents);
 	
 	if (init_irq(hwif) == 0)
 		goto done;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 73ef6bf..d066546 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -261,7 +261,7 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 		hwif->cursg = sg;
 	}
 
-	page = cursg->page;
+	page = sg_page(cursg);
 	offset = cursg->offset + hwif->cursg_ofs * SECTOR_SIZE;
 
 	/* get the current page and offset */
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 1de5856..a4ce3ba 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -276,8 +276,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 
 			if (iswrite) {
 				if(!put_source_flags(ahwif->tx_chan, 
-						     (void*)(page_address(sg->page) 
-							     + sg->offset), 
+						     (void*) sg_virt(sg),
 						     tc, flags)) { 
 					printk(KERN_ERR "%s failed %d\n", 
 					       __FUNCTION__, __LINE__);
@@ -285,8 +284,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 			} else 
 			{
 				if(!put_dest_flags(ahwif->rx_chan, 
-						   (void*)(page_address(sg->page) 
-							   + sg->offset), 
+						   (void*) sg_virt(sg),
 						   tc, flags)) { 
 					printk(KERN_ERR "%s failed %d\n", 
 					       __FUNCTION__, __LINE__);
diff --git a/drivers/ieee1394/dma.c b/drivers/ieee1394/dma.c
index 45d6055..25e113b 100644
--- a/drivers/ieee1394/dma.c
+++ b/drivers/ieee1394/dma.c
@@ -111,7 +111,7 @@ int dma_region_alloc(struct dma_region *dma, unsigned long n_bytes,
 		unsigned long va =
 		    (unsigned long)dma->kvirt + (i << PAGE_SHIFT);
 
-		dma->sglist[i].page = vmalloc_to_page((void *)va);
+		sg_set_page(&dma->sglist[i], vmalloc_to_page((void *)va));
 		dma->sglist[i].length = PAGE_SIZE;
 	}
 
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 1b353b9..d5dfe11 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1466,7 +1466,7 @@ static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 		cmd->dma_size = sgpnt[0].length;
 		cmd->dma_type = CMD_DMA_PAGE;
 		cmd->cmd_dma = dma_map_page(hi->host->device.parent,
-					    sgpnt[0].page, sgpnt[0].offset,
+					    sg_page(&sgpnt[0]), sgpnt[0].offset,
 					    cmd->dma_size, cmd->dma_dir);
 
 		orb->data_descriptor_lo = cmd->cmd_dma;
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 2f54e29..14159ff 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -55,9 +55,11 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 		ib_dma_unmap_sg(dev, chunk->page_list,
 				chunk->nents, DMA_BIDIRECTIONAL);
 		for (i = 0; i < chunk->nents; ++i) {
+			struct page *page = sg_page(&chunk->page_list[i]);
+
 			if (umem->writable && dirty)
-				set_page_dirty_lock(chunk->page_list[i].page);
-			put_page(chunk->page_list[i].page);
+				set_page_dirty_lock(page);
+			put_page(page);
 		}
 
 		kfree(chunk);
@@ -164,11 +166,12 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			}
 
 			chunk->nents = min_t(int, ret, IB_UMEM_MAX_PAGE_CHUNK);
+			sg_init_table(chunk->page_list, chunk->nents);
 			for (i = 0; i < chunk->nents; ++i) {
 				if (vma_list &&
 				    !is_vm_hugetlb_page(vma_list[i + off]))
 					umem->hugetlb = 0;
-				chunk->page_list[i].page   = page_list[i + off];
+				sg_set_page(&chunk->page_list[i], page_list[i + off]);
 				chunk->page_list[i].offset = 0;
 				chunk->page_list[i].length = PAGE_SIZE;
 			}
@@ -179,7 +182,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 						    DMA_BIDIRECTIONAL);
 			if (chunk->nmap <= 0) {
 				for (i = 0; i < chunk->nents; ++i)
-					put_page(chunk->page_list[i].page);
+					put_page(sg_page(&chunk->page_list[i]));
 				kfree(chunk);
 
 				ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/ipath/ipath_dma.c b/drivers/infiniband/hw/ipath/ipath_dma.c
index 22709a4..e90a0ea 100644
--- a/drivers/infiniband/hw/ipath/ipath_dma.c
+++ b/drivers/infiniband/hw/ipath/ipath_dma.c
@@ -108,7 +108,7 @@ static int ipath_map_sg(struct ib_device *dev, struct scatterlist *sgl,
 	BUG_ON(!valid_dma_direction(direction));
 
 	for_each_sg(sgl, sg, nents, i) {
-		addr = (u64) page_address(sg->page);
+		addr = (u64) page_address(sg_page(sg));
 		/* TODO: handle highmem pages */
 		if (!addr) {
 			ret = 0;
@@ -127,7 +127,7 @@ static void ipath_unmap_sg(struct ib_device *dev,
 
 static u64 ipath_sg_dma_address(struct ib_device *dev, struct scatterlist *sg)
 {
-	u64 addr = (u64) page_address(sg->page);
+	u64 addr = (u64) page_address(sg_page(sg));
 
 	if (addr)
 		addr += sg->offset;
diff --git a/drivers/infiniband/hw/ipath/ipath_mr.c b/drivers/infiniband/hw/ipath/ipath_mr.c
index e442470..db4ba92 100644
--- a/drivers/infiniband/hw/ipath/ipath_mr.c
+++ b/drivers/infiniband/hw/ipath/ipath_mr.c
@@ -225,7 +225,7 @@ struct ib_mr *ipath_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		for (i = 0; i < chunk->nents; i++) {
 			void *vaddr;
 
-			vaddr = page_address(chunk->page_list[i].page);
+			vaddr = page_address(sg_page(&chunk->page_list[i]));
 			if (!vaddr) {
 				ret = ERR_PTR(-EINVAL);
 				goto bail;
diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index e61f3e6..007b381 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -71,7 +71,7 @@ static void mthca_free_icm_pages(struct mthca_dev *dev, struct mthca_icm_chunk *
 			     PCI_DMA_BIDIRECTIONAL);
 
 	for (i = 0; i < chunk->npages; ++i)
-		__free_pages(chunk->mem[i].page,
+		__free_pages(sg_page(&chunk->mem[i]),
 			     get_order(chunk->mem[i].length));
 }
 
@@ -81,7 +81,7 @@ static void mthca_free_icm_coherent(struct mthca_dev *dev, struct mthca_icm_chun
 
 	for (i = 0; i < chunk->npages; ++i) {
 		dma_free_coherent(&dev->pdev->dev, chunk->mem[i].length,
-				  lowmem_page_address(chunk->mem[i].page),
+				  lowmem_page_address(sg_page(&chunk->mem[i])),
 				  sg_dma_address(&chunk->mem[i]));
 	}
 }
@@ -107,10 +107,13 @@ void mthca_free_icm(struct mthca_dev *dev, struct mthca_icm *icm, int coherent)
 
 static int mthca_alloc_icm_pages(struct scatterlist *mem, int order, gfp_t gfp_mask)
 {
-	mem->page = alloc_pages(gfp_mask, order);
-	if (!mem->page)
+	struct page *page;
+
+	page = alloc_pages(gfp_mask, order);
+	if (!page)
 		return -ENOMEM;
 
+	sg_set_page(mem, page);
 	mem->length = PAGE_SIZE << order;
 	mem->offset = 0;
 	return 0;
@@ -157,6 +160,7 @@ struct mthca_icm *mthca_alloc_icm(struct mthca_dev *dev, int npages,
 			if (!chunk)
 				goto fail;
 
+			sg_init_table(chunk->mem, MTHCA_ICM_CHUNK_LEN);
 			chunk->npages = 0;
 			chunk->nsg    = 0;
 			list_add_tail(&chunk->list, &icm->chunk_list);
@@ -304,7 +308,7 @@ void *mthca_table_find(struct mthca_icm_table *table, int obj, dma_addr_t *dma_h
 			 * so if we found the page, dma_handle has already
 			 * been assigned to. */
 			if (chunk->mem[i].length > offset) {
-				page = chunk->mem[i].page;
+				page = sg_page(&chunk->mem[i]);
 				goto out;
 			}
 			offset -= chunk->mem[i].length;
@@ -445,6 +449,7 @@ static u64 mthca_uarc_virt(struct mthca_dev *dev, struct mthca_uar *uar, int pag
 int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 		      struct mthca_user_db_table *db_tab, int index, u64 uaddr)
 {
+	struct page *pages[1];
 	int ret = 0;
 	u8 status;
 	int i;
@@ -472,16 +477,17 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 	}
 
 	ret = get_user_pages(current, current->mm, uaddr & PAGE_MASK, 1, 1, 0,
-			     &db_tab->page[i].mem.page, NULL);
+			     pages, NULL);
 	if (ret < 0)
 		goto out;
 
+	sg_set_page(&db_tab->page[i].mem, pages[0]);
 	db_tab->page[i].mem.length = MTHCA_ICM_PAGE_SIZE;
 	db_tab->page[i].mem.offset = uaddr & ~PAGE_MASK;
 
 	ret = pci_map_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
 	if (ret < 0) {
-		put_page(db_tab->page[i].mem.page);
+		put_page(pages[0]);
 		goto out;
 	}
 
@@ -491,7 +497,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 		ret = -EINVAL;
 	if (ret) {
 		pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
-		put_page(db_tab->page[i].mem.page);
+		put_page(sg_page(&db_tab->page[i].mem));
 		goto out;
 	}
 
@@ -557,7 +563,7 @@ void mthca_cleanup_user_db_tab(struct mthca_dev *dev, struct mthca_uar *uar,
 		if (db_tab->page[i].uvirt) {
 			mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1, &status);
 			pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
-			put_page(db_tab->page[i].mem.page);
+			put_page(sg_page(&db_tab->page[i].mem));
 		}
 	}
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index f3529b6..d687980 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -131,7 +131,7 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 
 		p = mem;
 		for_each_sg(sgl, sg, data->size, i) {
-			from = kmap_atomic(sg->page, KM_USER0);
+			from = kmap_atomic(sg_page(sg), KM_USER0);
 			memcpy(p,
 			       from + sg->offset,
 			       sg->length);
@@ -191,7 +191,7 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 
 		p = mem;
 		for_each_sg(sgl, sg, sg_size, i) {
-			to = kmap_atomic(sg->page, KM_SOFTIRQ0);
+			to = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
 			memcpy(to + sg->offset,
 			       p,
 			       sg->length);
@@ -300,7 +300,7 @@ static unsigned int iser_data_buf_aligned_len(struct iser_data_buf *data,
 	for_each_sg(sgl, sg, data->dma_nents, i) {
 		/* iser_dbg("Checking sg iobuf [%d]: phys=0x%08lX "
 		   "offset: %ld sz: %ld\n", i,
-		   (unsigned long)page_to_phys(sg->page),
+		   (unsigned long)sg_phys(sg),
 		   (unsigned long)sg->offset,
 		   (unsigned long)sg->length); */
 		end_addr = ib_sg_dma_address(ibdev, sg) +
@@ -336,7 +336,7 @@ static void iser_data_buf_dump(struct iser_data_buf *data,
 		iser_err("sg[%d] dma_addr:0x%lX page:0x%p "
 			 "off:0x%x sz:0x%x dma_len:0x%x\n",
 			 i, (unsigned long)ib_sg_dma_address(ibdev, sg),
-			 sg->page, sg->offset,
+			 sg_page(sg), sg->offset,
 			 sg->length, ib_sg_dma_len(ibdev, sg));
 }
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0eb5416..ac54f69 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -348,16 +348,17 @@ static int crypt_convert(struct crypt_config *cc,
 	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
 		struct bio_vec *bv_in = bio_iovec_idx(ctx->bio_in, ctx->idx_in);
 		struct bio_vec *bv_out = bio_iovec_idx(ctx->bio_out, ctx->idx_out);
-		struct scatterlist sg_in = {
-			.page = bv_in->bv_page,
-			.offset = bv_in->bv_offset + ctx->offset_in,
-			.length = 1 << SECTOR_SHIFT
-		};
-		struct scatterlist sg_out = {
-			.page = bv_out->bv_page,
-			.offset = bv_out->bv_offset + ctx->offset_out,
-			.length = 1 << SECTOR_SHIFT
-		};
+		struct scatterlist sg_in, sg_out;
+
+		sg_init_table(&sg_in, 1);
+		sg_set_page(&sg_in, bv_in->bv_page);
+		sg_in.offset = bv_in->bv_offset + ctx->offset_in;
+		sg_in.length = 1 << SECTOR_SHIFT;
+
+		sg_init_table(&sg_out, 1);
+		sg_set_page(&sg_out, bv_out->bv_page);
+		sg_out.offset = bv_out->bv_offset + ctx->offset_out;
+		sg_out.length = 1 << SECTOR_SHIFT;
 
 		ctx->offset_in += sg_in.length;
 		if (ctx->offset_in >= bv_in->bv_len) {
diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 365a221..2b1f8b4 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -112,12 +112,13 @@ static struct scatterlist* vmalloc_to_sg(unsigned char *virt, int nr_pages)
 	sglist = kcalloc(nr_pages, sizeof(struct scatterlist), GFP_KERNEL);
 	if (NULL == sglist)
 		return NULL;
+	sg_init_table(sglist, nr_pages);
 	for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
 		pg = vmalloc_to_page(virt);
 		if (NULL == pg)
 			goto err;
 		BUG_ON(PageHighMem(pg));
-		sglist[i].page   = pg;
+		sg_set_page(&sglist[i], pg);
 		sglist[i].length = PAGE_SIZE;
 	}
 	return sglist;
diff --git a/drivers/media/video/ivtv/ivtv-udma.c b/drivers/media/video/ivtv/ivtv-udma.c
index c4626d1..912b424 100644
--- a/drivers/media/video/ivtv/ivtv-udma.c
+++ b/drivers/media/video/ivtv/ivtv-udma.c
@@ -63,10 +63,10 @@ int ivtv_udma_fill_sg_list (struct ivtv_user_dma *dma, struct ivtv_dma_page_info
 			memcpy(page_address(dma->bouncemap[map_offset]) + offset, src, len);
 			kunmap_atomic(src, KM_BOUNCE_READ);
 			local_irq_restore(flags);
-			dma->SGlist[map_offset].page = dma->bouncemap[map_offset];
+			sg_set_page(&dma->SGlist[map_offset], dma->bouncemap[map_offset]);
 		}
 		else {
-			dma->SGlist[map_offset].page = dma->map[map_offset];
+			sg_set_page(&dma->SGlist[map_offset], dma->map[map_offset]);
 		}
 		offset = 0;
 		map_offset++;
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 3eb6123..0a18286 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -60,12 +60,13 @@ videobuf_vmalloc_to_sg(unsigned char *virt, int nr_pages)
 	sglist = kcalloc(nr_pages, sizeof(struct scatterlist), GFP_KERNEL);
 	if (NULL == sglist)
 		return NULL;
+	sg_init_table(sglist, nr_pages);
 	for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
 		pg = vmalloc_to_page(virt);
 		if (NULL == pg)
 			goto err;
 		BUG_ON(PageHighMem(pg));
-		sglist[i].page   = pg;
+		sg_set_page(&sglist[i], pg);
 		sglist[i].length = PAGE_SIZE;
 	}
 	return sglist;
@@ -86,13 +87,14 @@ videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
 	sglist = kcalloc(nr_pages, sizeof(*sglist), GFP_KERNEL);
 	if (NULL == sglist)
 		return NULL;
+	sg_init_table(sglist, nr_pages);
 
 	if (NULL == pages[0])
 		goto nopage;
 	if (PageHighMem(pages[0]))
 		/* DMA to highmem pages might not work */
 		goto highmem;
-	sglist[0].page   = pages[0];
+	sg_set_page(&sglist[0], pages[0]);
 	sglist[0].offset = offset;
 	sglist[0].length = PAGE_SIZE - offset;
 	for (i = 1; i < nr_pages; i++) {
@@ -100,7 +102,7 @@ videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
 			goto nopage;
 		if (PageHighMem(pages[i]))
 			goto highmem;
-		sglist[i].page   = pages[i];
+		sg_set_page(&sglist[i], pages[i]);
 		sglist[i].length = PAGE_SIZE;
 	}
 	return sglist;
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index a5d0354..9203a0b 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/scatterlist.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -153,19 +154,21 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 			blk_queue_max_hw_segments(mq->queue, bouncesz / 512);
 			blk_queue_max_segment_size(mq->queue, bouncesz);
 
-			mq->sg = kzalloc(sizeof(struct scatterlist),
+			mq->sg = kmalloc(sizeof(struct scatterlist),
 				GFP_KERNEL);
 			if (!mq->sg) {
 				ret = -ENOMEM;
 				goto cleanup_queue;
 			}
+			sg_init_table(mq->sg, 1);
 
-			mq->bounce_sg = kzalloc(sizeof(struct scatterlist) *
+			mq->bounce_sg = kmalloc(sizeof(struct scatterlist) *
 				bouncesz / 512, GFP_KERNEL);
 			if (!mq->bounce_sg) {
 				ret = -ENOMEM;
 				goto cleanup_queue;
 			}
+			sg_init_table(mq->bounce_sg, bouncesz / 512);
 		}
 	}
 #endif
@@ -302,12 +305,12 @@ static void copy_sg(struct scatterlist *dst, unsigned int dst_len,
 		BUG_ON(dst_len == 0);
 
 		if (dst_size == 0) {
-			dst_buf = page_address(dst->page) + dst->offset;
+			dst_buf = sg_virt(dst);
 			dst_size = dst->length;
 		}
 
 		if (src_size == 0) {
-			src_buf = page_address(src->page) + src->offset;
+			src_buf = sg_virt(dst);
 			src_size = src->length;
 		}
 
@@ -353,9 +356,7 @@ unsigned int mmc_queue_map_sg(struct mmc_queue *mq)
 		return 1;
 	}
 
-	mq->sg[0].page = virt_to_page(mq->bounce_buf);
-	mq->sg[0].offset = offset_in_page(mq->bounce_buf);
-	mq->sg[0].length = 0;
+	sg_init_one(mq->sg, mq->bounce_buf, 0);
 
 	while (sg_len) {
 		mq->sg[0].length += mq->bounce_sg[sg_len - 1].length;
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 7a452c2..b1edcef 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -149,7 +149,7 @@ static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data
 
 		sg = &data->sg[i];
 
-		sgbuffer = kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
+		sgbuffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
 		amount = min(size, sg->length);
 		size -= amount;
 
@@ -226,7 +226,7 @@ static void at91_mci_pre_dma_read(struct at91mci_host *host)
 		sg = &data->sg[host->transfer_index++];
 		pr_debug("sg = %p\n", sg);
 
-		sg->dma_address = dma_map_page(NULL, sg->page, sg->offset, sg->length, DMA_FROM_DEVICE);
+		sg->dma_address = dma_map_page(NULL, sg_page(sg), sg->offset, sg->length, DMA_FROM_DEVICE);
 
 		pr_debug("dma address = %08X, length = %d\n", sg->dma_address, sg->length);
 
@@ -283,7 +283,7 @@ static void at91_mci_post_dma_read(struct at91mci_host *host)
 			int index;
 
 			/* Swap the contents of the buffer */
-			buffer = kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
+			buffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
 			pr_debug("buffer = %p, length = %d\n", buffer, sg->length);
 
 			for (index = 0; index < (sg->length / 4); index++)
@@ -292,7 +292,7 @@ static void at91_mci_post_dma_read(struct at91mci_host *host)
 			kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
 		}
 
-		flush_dcache_page(sg->page);
+		flush_dcache_page(sg_page(sg));
 	}
 
 	/* Is there another transfer to trigger? */
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 92c4d0d..bcbb6d2 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -340,7 +340,7 @@ static void au1xmmc_send_pio(struct au1xmmc_host *host)
 
 	/* This is the pointer to the data buffer */
 	sg = &data->sg[host->pio.index];
-	sg_ptr = page_address(sg->page) + sg->offset + host->pio.offset;
+	sg_ptr = sg_virt(sg) + host->pio.offset;
 
 	/* This is the space left inside the buffer */
 	sg_len = data->sg[host->pio.index].length - host->pio.offset;
@@ -400,7 +400,7 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 
 	if (host->pio.index < host->dma.len) {
 		sg = &data->sg[host->pio.index];
-		sg_ptr = page_address(sg->page) + sg->offset + host->pio.offset;
+		sg_ptr = sg_virt(sg) + host->pio.offset;
 
 		/* This is the space left inside the buffer */
 		sg_len = sg_dma_len(&data->sg[host->pio.index]) - host->pio.offset;
@@ -613,14 +613,11 @@ au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
 
     			if (host->flags & HOST_F_XMIT){
       				ret = au1xxx_dbdma_put_source_flags(channel,
-					(void *) (page_address(sg->page) +
-						  sg->offset),
-					len, flags);
+					(void *) sg_virt(sg), len, flags);
 			}
     			else {
       				ret = au1xxx_dbdma_put_dest_flags(channel,
-					(void *) (page_address(sg->page) +
-						  sg->offset),
+					(void *) sg_virt(sg),
 					len, flags);
 			}
 
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index 6ebc41e..fc72e1f 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -262,7 +262,7 @@ static void imxmci_setup_data(struct imxmci_host *host, struct mmc_data *data)
 		}
 
 		/* Convert back to virtual address */
-		host->data_ptr = (u16*)(page_address(data->sg->page) + data->sg->offset);
+		host->data_ptr = (u16*)sg_virt(sg);
 		host->data_cnt = 0;
 
 		clear_bit(IMXMCI_PEND_DMA_DATA_b, &host->pending_events);
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 7ae18ea..12c2d80 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -813,7 +813,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 					&& dir == DMA_FROM_DEVICE)
 				dir = DMA_BIDIRECTIONAL;
 
-			dma_addr = dma_map_page(dma_dev, sg->page, 0,
+			dma_addr = dma_map_page(dma_dev, sg_page(sg), 0,
 						PAGE_SIZE, dir);
 			if (direction == DMA_TO_DEVICE)
 				t->tx_dma = dma_addr + sg->offset;
@@ -822,7 +822,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 		}
 
 		/* allow pio too; we don't allow highmem */
-		kmap_addr = kmap(sg->page);
+		kmap_addr = kmap(sg_page(sg));
 		if (direction == DMA_TO_DEVICE)
 			t->tx_buf = kmap_addr + sg->offset;
 		else
@@ -855,8 +855,8 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 
 		/* discard mappings */
 		if (direction == DMA_FROM_DEVICE)
-			flush_kernel_dcache_page(sg->page);
-		kunmap(sg->page);
+			flush_kernel_dcache_page(sg_page(sg));
+		kunmap(sg_page(sg));
 		if (dma_dev)
 			dma_unmap_page(dma_dev, dma_addr, PAGE_SIZE, dir);
 
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 60a67df..971e18b 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -24,10 +24,10 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
 #include <linux/clk.h>
+#include <linux/scatterlist.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/scatterlist.h>
 #include <asm/mach-types.h>
 
 #include <asm/arch/board.h>
@@ -383,7 +383,7 @@ mmc_omap_sg_to_buf(struct mmc_omap_host *host)
 
 	sg = host->data->sg + host->sg_idx;
 	host->buffer_bytes_left = sg->length;
-	host->buffer = page_address(sg->page) + sg->offset;
+	host->buffer = sg_virt(sg);
 	if (host->buffer_bytes_left > host->total_bytes_left)
 		host->buffer_bytes_left = host->total_bytes_left;
 }
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index b397121..0db837e 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -231,7 +231,7 @@ static void sdhci_deactivate_led(struct sdhci_host *host)
 
 static inline char* sdhci_sg_to_buffer(struct sdhci_host* host)
 {
-	return page_address(host->cur_sg->page) + host->cur_sg->offset;
+	return sg_virt(host->cur_sg);
 }
 
 static inline int sdhci_next_sg(struct sdhci_host* host)
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 9b90479..c11a3d2 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -192,7 +192,7 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg[host->sg_pos].page, off >> PAGE_SHIFT);
+		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
@@ -241,18 +241,18 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg[host->sg_pos].page, off >> PAGE_SHIFT);
+		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
 		p_cnt = min(p_cnt, t_size);
 
 		if (r_data->flags & MMC_DATA_WRITE)
-			tifm_sd_copy_page(host->bounce_buf.page,
+			tifm_sd_copy_page(sg_page(&host->bounce_buf),
 					  r_data->blksz - t_size,
 					  pg, p_off, p_cnt);
 		else if (r_data->flags & MMC_DATA_READ)
-			tifm_sd_copy_page(pg, p_off, host->bounce_buf.page,
+			tifm_sd_copy_page(pg, p_off, sg_page(&host->bounce_buf),
 					  r_data->blksz - t_size, p_cnt);
 
 		t_size -= p_cnt;
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 80db11c..fa4c8c5 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -269,7 +269,7 @@ static inline int wbsd_next_sg(struct wbsd_host *host)
 
 static inline char *wbsd_sg_to_buffer(struct wbsd_host *host)
 {
-	return page_address(host->cur_sg->page) + host->cur_sg->offset;
+	return sg_virt(host->cur_sg);
 }
 
 static inline void wbsd_sg_to_dma(struct wbsd_host *host, struct mmc_data *data)
@@ -283,7 +283,7 @@ static inline void wbsd_sg_to_dma(struct wbsd_host *host, struct mmc_data *data)
 	len = data->sg_len;
 
 	for (i = 0; i < len; i++) {
-		sgbuf = page_address(sg[i].page) + sg[i].offset;
+		sgbuf = sg_virt(&sg[i]);
 		memcpy(dmabuf, sgbuf, sg[i].length);
 		dmabuf += sg[i].length;
 	}
@@ -300,7 +300,7 @@ static inline void wbsd_dma_to_sg(struct wbsd_host *host, struct mmc_data *data)
 	len = data->sg_len;
 
 	for (i = 0; i < len; i++) {
-		sgbuf = page_address(sg[i].page) + sg[i].offset;
+		sgbuf = sg_virt(&sg[i]);
 		memcpy(sgbuf, dmabuf, sg[i].length);
 		dmabuf += sg[i].length;
 	}
diff --git a/drivers/net/mlx4/icm.c b/drivers/net/mlx4/icm.c
index 4b3c109..887633b 100644
--- a/drivers/net/mlx4/icm.c
+++ b/drivers/net/mlx4/icm.c
@@ -60,7 +60,7 @@ static void mlx4_free_icm_pages(struct mlx4_dev *dev, struct mlx4_icm_chunk *chu
 			     PCI_DMA_BIDIRECTIONAL);
 
 	for (i = 0; i < chunk->npages; ++i)
-		__free_pages(chunk->mem[i].page,
+		__free_pages(sg_page(&chunk->mem[i]),
 			     get_order(chunk->mem[i].length));
 }
 
@@ -70,7 +70,7 @@ static void mlx4_free_icm_coherent(struct mlx4_dev *dev, struct mlx4_icm_chunk *
 
 	for (i = 0; i < chunk->npages; ++i)
 		dma_free_coherent(&dev->pdev->dev, chunk->mem[i].length,
-				  lowmem_page_address(chunk->mem[i].page),
+				  lowmem_page_address(sg_page(&chunk->mem[i])),
 				  sg_dma_address(&chunk->mem[i]));
 }
 
@@ -95,10 +95,13 @@ void mlx4_free_icm(struct mlx4_dev *dev, struct mlx4_icm *icm, int coherent)
 
 static int mlx4_alloc_icm_pages(struct scatterlist *mem, int order, gfp_t gfp_mask)
 {
-	mem->page = alloc_pages(gfp_mask, order);
-	if (!mem->page)
+	struct page *page;
+
+	page = alloc_pages(gfp_mask, order);
+	if (!page)
 		return -ENOMEM;
 
+	sg_set_page(mem, page);
 	mem->length = PAGE_SIZE << order;
 	mem->offset = 0;
 	return 0;
@@ -145,6 +148,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 			if (!chunk)
 				goto fail;
 
+			sg_init_table(chunk->mem, MLX4_ICM_CHUNK_LEN);
 			chunk->npages = 0;
 			chunk->nsg    = 0;
 			list_add_tail(&chunk->list, &icm->chunk_list);
@@ -334,7 +338,7 @@ void *mlx4_table_find(struct mlx4_icm_table *table, int obj, dma_addr_t *dma_han
 			 * been assigned to.
 			 */
 			if (chunk->mem[i].length > offset) {
-				page = chunk->mem[i].page;
+				page = sg_page(&chunk->mem[i]);
 				goto out;
 			}
 			offset -= chunk->mem[i].length;
diff --git a/drivers/net/ppp_mppe.c b/drivers/net/ppp_mppe.c
index c0b6d19..bcb0885 100644
--- a/drivers/net/ppp_mppe.c
+++ b/drivers/net/ppp_mppe.c
@@ -55,7 +55,7 @@
 #include <linux/mm.h>
 #include <linux/ppp_defs.h>
 #include <linux/ppp-comp.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 
 #include "ppp_mppe.h"
 
@@ -68,9 +68,7 @@ MODULE_VERSION("1.0.2");
 static unsigned int
 setup_sg(struct scatterlist *sg, const void *address, unsigned int length)
 {
-	sg[0].page = virt_to_page(address);
-	sg[0].offset = offset_in_page(address);
-	sg[0].length = length;
+	sg_init_one(sg, address, length);
 	return length;
 }
 
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index fb14014..afb262b 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1840,7 +1840,7 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 			    (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH)) {
 				if (srb->sc_data_direction == DMA_TO_DEVICE || srb->sc_data_direction == DMA_BIDIRECTIONAL) {
 					struct scatterlist *sg = scsi_sglist(srb);
-					char *buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+					char *buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 					memcpy(tw_dev->generic_buffer_virt[request_id], buf, sg->length);
 					kunmap_atomic(buf - sg->offset, KM_IRQ0);
 				}
@@ -1919,7 +1919,7 @@ static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
 			char *buf;
 			unsigned long flags = 0;
 			local_irq_save(flags);
-			buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 			memcpy(buf, tw_dev->generic_buffer_virt[request_id], sg->length);
 			kunmap_atomic(buf - sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index a64153b..59716eb 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1469,7 +1469,7 @@ static void tw_transfer_internal(TW_Device_Extension *tw_dev, int request_id,
 	struct scatterlist *sg = scsi_sglist(cmd);
 
 	local_irq_save(flags);
-	buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+	buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 	transfer_len = min(sg->length, len);
 
 	memcpy(buf, data, transfer_len);
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 988f0bc..2597209 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -298,8 +298,7 @@ static __inline__ void initialize_SCp(Scsi_Cmnd * cmd)
 	if (cmd->use_sg) {
 		cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
 		cmd->SCp.buffers_residual = cmd->use_sg - 1;
-		cmd->SCp.ptr = page_address(cmd->SCp.buffer->page)+
-			       cmd->SCp.buffer->offset;
+		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	} else {
 		cmd->SCp.buffer = NULL;
@@ -2143,8 +2142,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					++cmd->SCp.buffer;
 					--cmd->SCp.buffers_residual;
 					cmd->SCp.this_residual = cmd->SCp.buffer->length;
-					cmd->SCp.ptr = page_address(cmd->SCp.buffer->page)+
-						       cmd->SCp.buffer->offset;
+					cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 					dprintk(NDEBUG_INFORMATION, ("scsi%d : %d bytes and %d buffers left\n", instance->host_no, cmd->SCp.this_residual, cmd->SCp.buffers_residual));
 				}
 				/*
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 3168a17..137d065 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -875,8 +875,7 @@ static void NCR53c406a_intr(void *dev_id)
 			outb(TRANSFER_INFO | DMA_OP, CMD_REG);
 #if USE_PIO
                         scsi_for_each_sg(current_SC, sg, scsi_sg_count(current_SC), i) {
-                                NCR53c406a_pio_write(page_address(sg->page) + sg->offset,
-                                                     sg->length);
+                                NCR53c406a_pio_write(sg_virt(sg), sg->length);
                         }
 			REG0;
 #endif				/* USE_PIO */
@@ -897,8 +896,7 @@ static void NCR53c406a_intr(void *dev_id)
 			outb(TRANSFER_INFO | DMA_OP, CMD_REG);
 #if USE_PIO
                         scsi_for_each_sg(current_SC, sg, scsi_sg_count(current_SC), i) {
-                                NCR53c406a_pio_read(page_address(sg->page) + sg->offset,
-                                                    sg->length);
+                                NCR53c406a_pio_read(sg_virt(sg), sg->length);
                         }
 			REG0;
 #endif				/* USE_PIO */
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 80e448d..a77ab8d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -356,7 +356,7 @@ static void aac_internal_transfer(struct scsi_cmnd *scsicmd, void *data, unsigne
 	int transfer_len;
 	struct scatterlist *sg = scsi_sglist(scsicmd);
 
-	buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+	buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 	transfer_len = min(sg->length, len + offset);
 
 	transfer_len -= offset;
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index a58c265..ea8c699 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -613,7 +613,7 @@ struct aha152x_scdata {
 #define SCNEXT(SCpnt)		SCDATA(SCpnt)->next
 #define SCSEM(SCpnt)		SCDATA(SCpnt)->done
 
-#define SG_ADDRESS(buffer)	((char *) (page_address((buffer)->page)+(buffer)->offset))
+#define SG_ADDRESS(buffer)	((char *) sg_virt((buffer)))
 
 /* state handling */
 static void seldi_run(struct Scsi_Host *shpnt);
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 961a188..bbcc2c5 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -49,7 +49,7 @@
 #include "aha1542.h"
 
 #define SCSI_BUF_PA(address)	isa_virt_to_bus(address)
-#define SCSI_SG_PA(sgent)	(isa_page_to_bus((sgent)->page) + (sgent)->offset)
+#define SCSI_SG_PA(sgent)	(isa_page_to_bus(sg_page((sgent))) + (sgent)->offset)
 
 static void BAD_DMA(void *address, unsigned int length)
 {
@@ -66,8 +66,7 @@ static void BAD_SG_DMA(Scsi_Cmnd * SCpnt,
 		       int badseg)
 {
 	printk(KERN_CRIT "sgpnt[%d:%d] page %p/0x%llx length %u\n",
-	       badseg, nseg,
-	       page_address(sgp->page) + sgp->offset,
+	       badseg, nseg, sg_virt(sgp),
 	       (unsigned long long)SCSI_SG_PA(sgp),
 	       sgp->length);
 
@@ -712,8 +711,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 				printk(KERN_CRIT "Bad segment list supplied to aha1542.c (%d, %d)\n", SCpnt->use_sg, i);
 				scsi_for_each_sg(SCpnt, sg, SCpnt->use_sg, i) {
 					printk(KERN_CRIT "%d: %p %d\n", i,
-					       (page_address(sg->page) +
-						sg->offset), sg->length);
+					       sg_virt(sg), sg->length);
 				};
 				printk(KERN_CRIT "cptr %x: ", (unsigned int) cptr);
 				ptr = (unsigned char *) &cptr[i];
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f817775..f7a2528 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1343,7 +1343,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 						/* 4 bytes: Areca io control code */
 
 	sg = scsi_sglist(cmd);
-	buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+	buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 	if (scsi_sg_count(cmd) > 1) {
 		retvalue = ARCMSR_MESSAGE_FAIL;
 		goto message_out;
@@ -1593,7 +1593,7 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */
 
 		sg = scsi_sglist(cmd);
-		buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+		buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 
 		memcpy(buffer, inqdata, sizeof(inqdata));
 		sg = scsi_sglist(cmd);
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index 668569e..8335b60 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -973,7 +973,7 @@ static irqreturn_t fd_mcs_intr(int irq, void *dev_id)
 				if (current_SC->SCp.buffers_residual) {
 					--current_SC->SCp.buffers_residual;
 					++current_SC->SCp.buffer;
-					current_SC->SCp.ptr = page_address(current_SC->SCp.buffer->page) + current_SC->SCp.buffer->offset;
+					current_SC->SCp.ptr = sg_virt(current_SC->SCp.buffer);
 					current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
 				} else
 					break;
@@ -1006,7 +1006,7 @@ static irqreturn_t fd_mcs_intr(int irq, void *dev_id)
 			if (!current_SC->SCp.this_residual && current_SC->SCp.buffers_residual) {
 				--current_SC->SCp.buffers_residual;
 				++current_SC->SCp.buffer;
-				current_SC->SCp.ptr = page_address(current_SC->SCp.buffer->page) + current_SC->SCp.buffer->offset;
+				current_SC->SCp.ptr = sg_virt(current_SC->SCp.buffer);
 				current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
 			}
 		}
@@ -1109,7 +1109,7 @@ static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 
 	if (current_SC->use_sg) {
 		current_SC->SCp.buffer = (struct scatterlist *) current_SC->request_buffer;
-		current_SC->SCp.ptr = page_address(current_SC->SCp.buffer->page) + current_SC->SCp.buffer->offset;
+		current_SC->SCp.ptr = sg_virt(current_SC->SCp.buffer);
 		current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
 		current_SC->SCp.buffers_residual = current_SC->use_sg - 1;
 	} else {
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 5d282e6..2cd6b49 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1321,7 +1321,7 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
 	    if (current_SC->SCp.buffers_residual) {
 	       --current_SC->SCp.buffers_residual;
 	       ++current_SC->SCp.buffer;
-	       current_SC->SCp.ptr = page_address(current_SC->SCp.buffer->page) + current_SC->SCp.buffer->offset;
+	       current_SC->SCp.ptr = sg_virt(current_SC->SCp.buffer);
 	       current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
 	    } else
 		  break;
@@ -1354,7 +1354,7 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
 	     && current_SC->SCp.buffers_residual) {
 	    --current_SC->SCp.buffers_residual;
 	    ++current_SC->SCp.buffer;
-	    current_SC->SCp.ptr = page_address(current_SC->SCp.buffer->page) + current_SC->SCp.buffer->offset;
+	    current_SC->SCp.ptr = sg_virt(current_SC->SCp.buffer);
 	    current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
 	 }
       }
@@ -1439,8 +1439,7 @@ static int fdomain_16x0_queue(struct scsi_cmnd *SCpnt,
 
    if (scsi_sg_count(current_SC)) {
 	   current_SC->SCp.buffer = scsi_sglist(current_SC);
-	   current_SC->SCp.ptr = page_address(current_SC->SCp.buffer->page)
-		   + current_SC->SCp.buffer->offset;
+	   current_SC->SCp.ptr = sg_virt(current_SC->SCp.buffer);
 	   current_SC->SCp.this_residual    = current_SC->SCp.buffer->length;
 	   current_SC->SCp.buffers_residual = scsi_sg_count(current_SC) - 1;
    } else {
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3ac080e..ac6c57a 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2374,13 +2374,13 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
             if (cpsum+cpnow > cpcount) 
                 cpnow = cpcount - cpsum;
             cpsum += cpnow;
-            if (!sl->page) {
+            if (!sg_page(sl)) {
                 printk("GDT-HA %d: invalid sc/gt element in gdth_copy_internal_data()\n",
                        ha->hanum);
                 return;
             }
             local_irq_save(flags);
-            address = kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
+            address = kmap_atomic(sg_page(sl), KM_BIO_SRC_IRQ) + sl->offset;
             if (to_buffer)
                 memcpy(buffer, address, cpnow);
             else
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 714e627..db004a4 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1828,7 +1828,7 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		BUG_ON(scsi_sg_count(cmd) > 16);
 
 		scsi_for_each_sg(cmd, sg, scsi_sg_count(cmd), i) {
-			ld(shpnt)[ldn].sge[i].address = (void *) (isa_page_to_bus(sg->page) + sg->offset);
+			ld(shpnt)[ldn].sge[i].address = (void *) (isa_page_to_bus(sg_page(sg)) + sg->offset);
 			ld(shpnt)[ldn].sge[i].byte_length = sg->length;
 		}
 		scb->enable |= IM_POINTER_TO_LIST;
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 252d180..8d0244c 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -175,18 +175,18 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 
 	while (bcount) {
 		count = min(pc->sg->length - pc->b_count, bcount);
-		if (PageHighMem(pc->sg->page)) {
+		if (PageHighMem(sg_page(pc->sg))) {
 			unsigned long flags;
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pc->sg->page, KM_IRQ0) +
+			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
 					pc->sg->offset;
 			drive->hwif->atapi_input_bytes(drive,
 						buf + pc->b_count, count);
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
-			buf = page_address(pc->sg->page) + pc->sg->offset;
+			buf = sg_virt(pc->sg);
 			drive->hwif->atapi_input_bytes(drive,
 						buf + pc->b_count, count);
 		}
@@ -212,18 +212,18 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 
 	while (bcount) {
 		count = min(pc->sg->length - pc->b_count, bcount);
-		if (PageHighMem(pc->sg->page)) {
+		if (PageHighMem(sg_page(pc->sg))) {
 			unsigned long flags;
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pc->sg->page, KM_IRQ0) +
+			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
 						pc->sg->offset;
 			drive->hwif->atapi_output_bytes(drive,
 						buf + pc->b_count, count);
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
-			buf = page_address(pc->sg->page) + pc->sg->offset;
+			buf = sg_virt(pc->sg);
 			drive->hwif->atapi_output_bytes(drive,
 						buf + pc->b_count, count);
 		}
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 74cdc1f..a3d0c6b 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -705,9 +705,7 @@ static int imm_completion(struct scsi_cmnd *cmd)
 				cmd->SCp.buffer++;
 				cmd->SCp.this_residual =
 				    cmd->SCp.buffer->length;
-				cmd->SCp.ptr =
-				    page_address(cmd->SCp.buffer->page) +
-				    cmd->SCp.buffer->offset;
+				cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 
 				/*
 				 * Make sure that we transfer even number of bytes
@@ -844,9 +842,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 			cmd->SCp.buffer =
 			    (struct scatterlist *) cmd->request_buffer;
 			cmd->SCp.this_residual = cmd->SCp.buffer->length;
-			cmd->SCp.ptr =
-			    page_address(cmd->SCp.buffer->page) +
-			    cmd->SCp.buffer->offset;
+			cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		} else {
 			/* else fill the only available buffer */
 			cmd->SCp.buffer = NULL;
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index ab7cbf3..c8b452f 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -372,7 +372,7 @@ static int in2000_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	if (cmd->use_sg) {
 		cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
 		cmd->SCp.buffers_residual = cmd->use_sg - 1;
-		cmd->SCp.ptr = (char *) page_address(cmd->SCp.buffer->page) + cmd->SCp.buffer->offset;
+		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	} else {
 		cmd->SCp.buffer = NULL;
@@ -764,7 +764,7 @@ static void transfer_bytes(Scsi_Cmnd * cmd, int data_in_dir)
 		++cmd->SCp.buffer;
 		--cmd->SCp.buffers_residual;
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
-		cmd->SCp.ptr = page_address(cmd->SCp.buffer->page) + cmd->SCp.buffer->offset;
+		cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 	}
 
 /* Set up hardware registers */
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index c316a0b..439b97a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -2872,6 +2872,7 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
 	}
 
 	scatterlist = sglist->scatterlist;
+	sg_init_table(scatterlist, num_elem);
 
 	sglist->order = order;
 	sglist->num_sg = num_elem;
@@ -2884,12 +2885,12 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
 
 			/* Free up what we already allocated */
 			for (j = i - 1; j >= 0; j--)
-				__free_pages(scatterlist[j].page, order);
+				__free_pages(sg_page(&scatterlist[j]), order);
 			kfree(sglist);
 			return NULL;
 		}
 
-		scatterlist[i].page = page;
+		sg_set_page(&scatterlist[i], page);
 	}
 
 	return sglist;
@@ -2910,7 +2911,7 @@ static void ipr_free_ucode_buffer(struct ipr_sglist *sglist)
 	int i;
 
 	for (i = 0; i < sglist->num_sg; i++)
-		__free_pages(sglist->scatterlist[i].page, sglist->order);
+		__free_pages(sg_page(&sglist->scatterlist[i]), sglist->order);
 
 	kfree(sglist);
 }
@@ -2940,9 +2941,11 @@ static int ipr_copy_ucode_buffer(struct ipr_sglist *sglist,
 	scatterlist = sglist->scatterlist;
 
 	for (i = 0; i < (len / bsize_elem); i++, buffer += bsize_elem) {
-		kaddr = kmap(scatterlist[i].page);
+		struct page *page = sg_page(&scatterlist[i]);
+
+		kaddr = kmap(page);
 		memcpy(kaddr, buffer, bsize_elem);
-		kunmap(scatterlist[i].page);
+		kunmap(page);
 
 		scatterlist[i].length = bsize_elem;
 
@@ -2953,9 +2956,11 @@ static int ipr_copy_ucode_buffer(struct ipr_sglist *sglist,
 	}
 
 	if (len % bsize_elem) {
-		kaddr = kmap(scatterlist[i].page);
+		struct page *page = sg_page(&scatterlist[i]);
+
+		kaddr = kmap(page);
 		memcpy(kaddr, buffer, len % bsize_elem);
-		kunmap(scatterlist[i].page);
+		kunmap(page);
 
 		scatterlist[i].length = len % bsize_elem;
 	}
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index edaac27..5c5a9b2 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1515,7 +1515,7 @@ static int ips_is_passthru(struct scsi_cmnd *SC)
                 /* kmap_atomic() ensures addressability of the user buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+                buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
                 if (buffer && buffer[0] == 'C' && buffer[1] == 'O' &&
                     buffer[2] == 'P' && buffer[3] == 'P') {
                         kunmap_atomic(buffer - sg->offset, KM_IRQ0);
@@ -3523,7 +3523,7 @@ ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
                 /* kmap_atomic() ensures addressability of the data buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
+                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
                 memcpy(buffer, &cdata[xfer_cnt], min_cnt);
                 kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
                 local_irq_restore(flags);
@@ -3556,7 +3556,7 @@ ips_scmd_buf_read(struct scsi_cmnd *scmd, void *data, unsigned int count)
                 /* kmap_atomic() ensures addressability of the data buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
+                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
                 memcpy(&cdata[xfer_cnt], buffer, min_cnt);
                 kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
                 local_irq_restore(flags);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index a21455d..6ce4109 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -70,9 +70,7 @@ module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 static inline void
 iscsi_buf_init_iov(struct iscsi_buf *ibuf, char *vbuf, int size)
 {
-	ibuf->sg.page = virt_to_page(vbuf);
-	ibuf->sg.offset = offset_in_page(vbuf);
-	ibuf->sg.length = size;
+	sg_init_one(&ibuf->sg, vbuf, size);
 	ibuf->sent = 0;
 	ibuf->use_sendmsg = 1;
 }
@@ -80,13 +78,14 @@ iscsi_buf_init_iov(struct iscsi_buf *ibuf, char *vbuf, int size)
 static inline void
 iscsi_buf_init_sg(struct iscsi_buf *ibuf, struct scatterlist *sg)
 {
-	ibuf->sg.page = sg->page;
+	sg_init_table(&ibuf->sg, 1);
+	sg_set_page(&ibuf->sg, sg_page(sg));
 	ibuf->sg.offset = sg->offset;
 	ibuf->sg.length = sg->length;
 	/*
 	 * Fastpath: sg element fits into single page
 	 */
-	if (sg->length + sg->offset <= PAGE_SIZE && !PageSlab(sg->page))
+	if (sg->length + sg->offset <= PAGE_SIZE && !PageSlab(sg_page(sg)))
 		ibuf->use_sendmsg = 0;
 	else
 		ibuf->use_sendmsg = 1;
@@ -716,7 +715,7 @@ static int iscsi_scsi_data_in(struct iscsi_conn *conn)
 	for (i = tcp_ctask->sg_count; i < scsi_sg_count(sc); i++) {
 		char *dest;
 
-		dest = kmap_atomic(sg[i].page, KM_SOFTIRQ0);
+		dest = kmap_atomic(sg_page(&sg[i]), KM_SOFTIRQ0);
 		rc = iscsi_ctask_copy(tcp_conn, ctask, dest + sg[i].offset,
 				      sg[i].length, offset);
 		kunmap_atomic(dest, KM_SOFTIRQ0);
@@ -1103,9 +1102,9 @@ iscsi_send(struct iscsi_conn *conn, struct iscsi_buf *buf, int size, int flags)
 	 * slab case.
 	 */
 	if (buf->use_sendmsg)
-		res = sock_no_sendpage(sk, buf->sg.page, offset, size, flags);
+		res = sock_no_sendpage(sk, sg_page(&buf->sg), offset, size, flags);
 	else
-		res = tcp_conn->sendpage(sk, buf->sg.page, offset, size, flags);
+		res = tcp_conn->sendpage(sk, sg_page(&buf->sg), offset, size, flags);
 
 	if (res >= 0) {
 		conn->txdata_octets += res;
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 10d1aff..66c6520 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -658,7 +658,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 			struct scatterlist *sg;
 
 			sg = scsi_sglist(cmd);
-			buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 
 			memset(buf, 0, cmd->cmnd[4]);
 			kunmap_atomic(buf - sg->offset, KM_IRQ0);
@@ -1542,10 +1542,8 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 		if( cmd->cmnd[0] == INQUIRY && !islogical ) {
 
 			sgl = scsi_sglist(cmd);
-			if( sgl->page ) {
-				c = *(unsigned char *)
-					page_address((&sgl[0])->page) +
-					(&sgl[0])->offset; 
+			if( sg_page(sgl) ) {
+				c = *(unsigned char *) sg_virt(&sgl[0]);
 			} else {
 				printk(KERN_WARNING
 				       "megaraid: invalid sg.\n");
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 7877920..c892310 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1584,10 +1584,8 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			caddr_t			vaddr;
 
 			sgl = scsi_sglist(scp);
-			if (sgl->page) {
-				vaddr = (caddr_t)
-					(page_address((&sgl[0])->page)
-					 + (&sgl[0])->offset);
+			if (sg_page(sgl)) {
+				vaddr = (caddr_t) sg_virt(&sgl[0]);
 
 				memset(vaddr, 0, scp->cmnd[4]);
 			}
@@ -2328,10 +2326,8 @@ megaraid_mbox_dpc(unsigned long devp)
 				&& IS_RAID_CH(raid_dev, scb->dev_channel)) {
 
 			sgl = scsi_sglist(scp);
-			if (sgl->page) {
-				c = *(unsigned char *)
-					(page_address((&sgl[0])->page) +
-					 (&sgl[0])->offset);
+			if (sg_page(sgl)) {
+				c = *(unsigned char *) sg_virt(&sgl[0]);
 			} else {
 				con_log(CL_ANN, (KERN_WARNING
 						 "megaraid mailbox: invalid sg:%d\n",
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 331b789..1c5c4b6 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -542,7 +542,7 @@ static int osst_verify_frame(struct osst_tape * STp, int frame_seq_number, int q
 	if (STp->raw) {
 		if (STp->buffer->syscall_result) {
 			for (i=0; i < STp->buffer->sg_segs; i++)
-				memset(page_address(STp->buffer->sg[i].page),
+				memset(page_address(sg_page(&STp->buffer->sg[i])),
 				       0, STp->buffer->sg[i].length);
 			strcpy(STp->buffer->b_data, "READ ERROR ON FRAME");
                 } else
@@ -4437,7 +4437,7 @@ static int os_scsi_tape_open(struct inode * inode, struct file * filp)
 		for (i = 0, b_size = 0; 
 		     (i < STp->buffer->sg_segs) && ((b_size + STp->buffer->sg[i].length) <= OS_DATA_SIZE); 
 		     b_size += STp->buffer->sg[i++].length);
-		STp->buffer->aux = (os_aux_t *) (page_address(STp->buffer->sg[i].page) + OS_DATA_SIZE - b_size);
+		STp->buffer->aux = (os_aux_t *) (page_address(sg_page(&STp->buffer->sg[i])) + OS_DATA_SIZE - b_size);
 #if DEBUG
 		printk(OSST_DEB_MSG "%s:D: b_data points to %p in segment 0 at %p\n", name,
 			STp->buffer->b_data, page_address(STp->buffer->sg[0].page));
@@ -5252,25 +5252,26 @@ static int enlarge_buffer(struct osst_buffer *STbuffer, int need_dma)
 	/* Try to allocate the first segment up to OS_DATA_SIZE and the others
 	   big enough to reach the goal (code assumes no segments in place) */
 	for (b_size = OS_DATA_SIZE, order = OSST_FIRST_ORDER; b_size >= PAGE_SIZE; order--, b_size /= 2) {
-		STbuffer->sg[0].page = alloc_pages(priority, order);
+		struct page *page = alloc_pages(priority, order);
+
 		STbuffer->sg[0].offset = 0;
-		if (STbuffer->sg[0].page != NULL) {
+		if (page != NULL) {
+		    sg_set_page(&STbuffer->sg[0], page);
 		    STbuffer->sg[0].length = b_size;
-		    STbuffer->b_data = page_address(STbuffer->sg[0].page);
+		    STbuffer->b_data = page_address(page);
 		    break;
 		}
 	}
-	if (STbuffer->sg[0].page == NULL) {
+	if (sg_page(&STbuffer->sg[0]) == NULL) {
 		printk(KERN_NOTICE "osst :I: Can't allocate tape buffer main segment.\n");
 		return 0;
 	}
 	/* Got initial segment of 'bsize,order', continue with same size if possible, except for AUX */
 	for (segs=STbuffer->sg_segs=1, got=b_size;
 	     segs < max_segs && got < OS_FRAME_SIZE; ) {
-		STbuffer->sg[segs].page =
-				alloc_pages(priority, (OS_FRAME_SIZE - got <= PAGE_SIZE) ? 0 : order);
+		struct page *page = alloc_pages(priority, (OS_FRAME_SIZE - got <= PAGE_SIZE) ? 0 : order);
 		STbuffer->sg[segs].offset = 0;
-		if (STbuffer->sg[segs].page == NULL) {
+		if (page == NULL) {
 			if (OS_FRAME_SIZE - got <= (max_segs - segs) * b_size / 2 && order) {
 				b_size /= 2;  /* Large enough for the rest of the buffers */
 				order--;
@@ -5284,6 +5285,7 @@ static int enlarge_buffer(struct osst_buffer *STbuffer, int need_dma)
 			normalize_buffer(STbuffer);
 			return 0;
 		}
+		sg_set_page(&STbuffer->sg[segs], page);
 		STbuffer->sg[segs].length = (OS_FRAME_SIZE - got <= PAGE_SIZE / 2) ? (OS_FRAME_SIZE - got) : b_size;
 		got += STbuffer->sg[segs].length;
 		STbuffer->buffer_size = got;
@@ -5316,7 +5318,7 @@ static void normalize_buffer(struct osst_buffer *STbuffer)
 		     b_size < STbuffer->sg[i].length;
 		     b_size *= 2, order++);
 
-		__free_pages(STbuffer->sg[i].page, order);
+		__free_pages(sg_page(&STbuffer->sg[i]), order);
 		STbuffer->buffer_size -= STbuffer->sg[i].length;
 	}
 #if DEBUG
@@ -5344,7 +5346,7 @@ static int append_to_buffer(const char __user *ubp, struct osst_buffer *st_bp, i
 	for ( ; i < st_bp->sg_segs && do_count > 0; i++) {
 		cnt = st_bp->sg[i].length - offset < do_count ?
 		      st_bp->sg[i].length - offset : do_count;
-		res = copy_from_user(page_address(st_bp->sg[i].page) + offset, ubp, cnt);
+		res = copy_from_user(page_address(sg_page(&st_bp->sg[i])) + offset, ubp, cnt);
 		if (res)
 			return (-EFAULT);
 		do_count -= cnt;
@@ -5377,7 +5379,7 @@ static int from_buffer(struct osst_buffer *st_bp, char __user *ubp, int do_count
 	for ( ; i < st_bp->sg_segs && do_count > 0; i++) {
 		cnt = st_bp->sg[i].length - offset < do_count ?
 		      st_bp->sg[i].length - offset : do_count;
-		res = copy_to_user(ubp, page_address(st_bp->sg[i].page) + offset, cnt);
+		res = copy_to_user(ubp, page_address(sg_page(&st_bp->sg[i])) + offset, cnt);
 		if (res)
 			return (-EFAULT);
 		do_count -= cnt;
@@ -5410,7 +5412,7 @@ static int osst_zero_buffer_tail(struct osst_buffer *st_bp)
 	     i < st_bp->sg_segs && do_count > 0; i++) {
 		cnt = st_bp->sg[i].length - offset < do_count ?
 		      st_bp->sg[i].length - offset : do_count ;
-		memset(page_address(st_bp->sg[i].page) + offset, 0, cnt);
+		memset(page_address(sg_page(&st_bp->sg[i])) + offset, 0, cnt);
 		do_count -= cnt;
 		offset = 0;
 	}
@@ -5430,7 +5432,7 @@ static int osst_copy_to_buffer(struct osst_buffer *st_bp, unsigned char *ptr)
 	for (i = 0; i < st_bp->sg_segs && do_count > 0; i++) {
 		cnt = st_bp->sg[i].length < do_count ?
 		      st_bp->sg[i].length : do_count ;
-		memcpy(page_address(st_bp->sg[i].page), ptr, cnt);
+		memcpy(page_address(sg_page(&st_bp->sg[i])), ptr, cnt);
 		do_count -= cnt;
 		ptr      += cnt;
 	}
@@ -5451,7 +5453,7 @@ static int osst_copy_from_buffer(struct osst_buffer *st_bp, unsigned char *ptr)
 	for (i = 0; i < st_bp->sg_segs && do_count > 0; i++) {
 		cnt = st_bp->sg[i].length < do_count ?
 		      st_bp->sg[i].length : do_count ;
-		memcpy(ptr, page_address(st_bp->sg[i].page), cnt);
+		memcpy(ptr, page_address(sg_page(&st_bp->sg[i])), cnt);
 		do_count -= cnt;
 		ptr      += cnt;
 	}
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 9839755..7db28cd 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -393,7 +393,7 @@ enum _burst_mode {
 #define MSG_EXT_SDTR         0x01
 
 /* scatter-gather table */
-#  define BUFFER_ADDR ((char *)((unsigned int)(SCpnt->SCp.buffer->page) + SCpnt->SCp.buffer->offset))
+#  define BUFFER_ADDR ((char *)((sg_virt(SCpnt->SCp.buffer))))
 
 #endif  /*__nsp_cs__*/
 /* end */
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 190e2a7..969b938 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -443,8 +443,7 @@ SYM53C500_intr(int irq, void *dev_id)
 
 			scsi_for_each_sg(curSC, sg, scsi_sg_count(curSC), i) {
 				SYM53C500_pio_write(fast_pio, port_base,
-						    page_address(sg->page) + sg->offset,
-						    sg->length);
+				    sg_virt(sg), sg->length);
 			}
 			REG0(port_base);
 		}
@@ -463,8 +462,7 @@ SYM53C500_intr(int irq, void *dev_id)
 
 			scsi_for_each_sg(curSC, sg, scsi_sg_count(curSC), i) {
 				SYM53C500_pio_read(fast_pio, port_base,
-						   page_address(sg->page) + sg->offset,
-						   sg->length);
+					sg_virt(sg), sg->length);
 			}
 			REG0(port_base);
 		}
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 67b6d76..67ee51a 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -608,9 +608,7 @@ static int ppa_completion(struct scsi_cmnd *cmd)
 				cmd->SCp.buffer++;
 				cmd->SCp.this_residual =
 				    cmd->SCp.buffer->length;
-				cmd->SCp.ptr =
-				    page_address(cmd->SCp.buffer->page) +
-				    cmd->SCp.buffer->offset;
+				cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 			}
 		}
 		/* Now check to see if the drive is ready to comunicate */
@@ -756,8 +754,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 			/* if many buffers are available, start filling the first */
 			cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
 			cmd->SCp.this_residual = cmd->SCp.buffer->length;
-			cmd->SCp.ptr = page_address(cmd->SCp.buffer->page) +
-			    cmd->SCp.buffer->offset;
+			cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
 		} else {
 			/* else fill the only available buffer */
 			cmd->SCp.buffer = NULL;
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 2bfbf26..de7b3bc 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -317,7 +317,7 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 				return ((priv->qabort == 1 ?
 					 DID_ABORT : DID_RESET) << 16);
 			}
-			buf = page_address(sg->page) + sg->offset;
+			buf = sg_virt(sg);
 			if (ql_pdma(priv, phase, buf, sg->length))
 				break;
 		}
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 72ee4c9..46cae5a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -625,7 +625,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 	scsi_for_each_sg(scp, sg, scp->use_sg, k) {
 		if (active) {
 			kaddr = (unsigned char *)
-				kmap_atomic(sg->page, KM_USER0);
+				kmap_atomic(sg_page(sg), KM_USER0);
 			if (NULL == kaddr)
 				return (DID_ERROR << 16);
 			kaddr_off = (unsigned char *)kaddr + sg->offset;
@@ -672,7 +672,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 	sg = scsi_sglist(scp);
 	req_len = fin = 0;
 	for (k = 0; k < scp->use_sg; ++k, sg = sg_next(sg)) {
-		kaddr = (unsigned char *)kmap_atomic(sg->page, KM_USER0);
+		kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
 		if (NULL == kaddr)
 			return -1;
 		kaddr_off = (unsigned char *)kaddr + sg->offset;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index aac8a02..61fdaf0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -295,7 +295,7 @@ static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
 	int i, err, nr_vecs = 0;
 
 	for_each_sg(sgl, sg, nsegs, i) {
-		page = sg->page;
+		page = sg_page(sg);
 		off = sg->offset;
 		len = sg->length;
  		data_len += len;
@@ -764,7 +764,7 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		if (unlikely(!sgl))
 			goto enomem;
 
-		memset(sgl, 0, sizeof(*sgl) * sgp->size);
+		sg_init_table(sgl, sgp->size);
 
 		/*
 		 * first loop through, set initial index and return value
@@ -781,6 +781,13 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
 
 		/*
+		 * if we have nothing left, mark the last segment as
+		 * end-of-list
+		 */
+		if (!left)
+			sg_mark_end(sgl, this);
+
+		/*
 		 * don't allow subsequent mempool allocs to sleep, it would
 		 * violate the mempool principle.
 		 */
@@ -2353,7 +2360,7 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 	*offset = *offset - len_complete + sg->offset;
 
 	/* Assumption: contiguous pages can be accessed as "page + i" */
-	page = nth_page(sg->page, (*offset >> PAGE_SHIFT));
+	page = nth_page(sg_page(sg), (*offset >> PAGE_SHIFT));
 	*offset &= ~PAGE_MASK;
 
 	/* Bytes in this sg-entry from *offset to the end of the page */
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
index ce80fa9..b113244 100644
--- a/drivers/scsi/seagate.c
+++ b/drivers/scsi/seagate.c
@@ -999,14 +999,14 @@ connect_loop:
 				for (i = 0; i < nobuffs; ++i)
 					printk("scsi%d : buffer %d address = %p length = %d\n",
 					     hostno, i,
-					     page_address(buffer[i].page) + buffer[i].offset,
+					     sg_virt(&buffer[i]),
 					     buffer[i].length);
 			}
 #endif
 
 			buffer = (struct scatterlist *) SCint->request_buffer;
 			len = buffer->length;
-			data = page_address(buffer->page) + buffer->offset;
+			data = sg_virt(buffer);
 		} else {
 			DPRINTK (DEBUG_SG, "scsi%d : scatter gather not requested.\n", hostno);
 			buffer = NULL;
@@ -1239,7 +1239,7 @@ connect_loop:
 					--nobuffs;
 					++buffer;
 					len = buffer->length;
-					data = page_address(buffer->page) + buffer->offset;
+					data = sg_virt(buffer);
 					DPRINTK (DEBUG_SG,
 						 "scsi%d : next scatter-gather buffer len = %d address = %08x\n",
 						 hostno, len, data);
@@ -1396,7 +1396,7 @@ connect_loop:
 					--nobuffs;
 					++buffer;
 					len = buffer->length;
-					data = page_address(buffer->page) + buffer->offset;
+					data = sg_virt(buffer);
 					DPRINTK (DEBUG_SG, "scsi%d : next scatter-gather buffer len = %d address = %08x\n", hostno, len, data);
 				}
 				break;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7238b2d..cc19710 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1169,7 +1169,7 @@ sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
 		len = vma->vm_end - sa;
 		len = (len < sg->length) ? len : sg->length;
 		if (offset < len) {
-			page = virt_to_page(page_address(sg->page) + offset);
+			page = virt_to_page(page_address(sg_page(sg)) + offset);
 			get_page(page);	/* increment page count */
 			break;
 		}
@@ -1717,13 +1717,13 @@ st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages,
 		   goto out_unlock; */
         }
 
-	sgl[0].page = pages[0];
+	sg_set_page(sgl, pages[0]);
 	sgl[0].offset = uaddr & ~PAGE_MASK;
 	if (nr_pages > 1) {
 		sgl[0].length = PAGE_SIZE - sgl[0].offset;
 		count -= sgl[0].length;
 		for (i=1; i < nr_pages ; i++) {
-			sgl[i].page = pages[i]; 
+			sg_set_page(&sgl[i], pages[i]);
 			sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
 			count -= PAGE_SIZE;
 		}
@@ -1754,7 +1754,7 @@ st_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_pages,
 	int i;
 
 	for (i=0; i < nr_pages; i++) {
-		struct page *page = sgl[i].page;
+		struct page *page = sg_page(&sgl[i]);
 
 		if (dirtied)
 			SetPageDirty(page);
@@ -1854,7 +1854,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 				scatter_elem_sz_prev = ret_sz;
 			}
 		}
-		sg->page = p;
+		sg_set_page(sg, p);
 		sg->length = (ret_sz > num) ? num : ret_sz;
 
 		SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k=%d, num=%d, "
@@ -1907,14 +1907,14 @@ sg_write_xfer(Sg_request * srp)
 		onum = 1;
 
 	ksglen = sg->length;
-	p = page_address(sg->page);
+	p = page_address(sg_page(sg));
 	for (j = 0, k = 0; j < onum; ++j) {
 		res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
 		if (res)
 			return res;
 
 		for (; p; sg = sg_next(sg), ksglen = sg->length,
-		     p = page_address(sg->page)) {
+		     p = page_address(sg_page(sg))) {
 			if (usglen <= 0)
 				break;
 			if (ksglen > usglen) {
@@ -1991,12 +1991,12 @@ sg_remove_scat(Sg_scatter_hold * schp)
 		} else {
 			int k;
 
-			for (k = 0; (k < schp->k_use_sg) && sg->page;
+			for (k = 0; (k < schp->k_use_sg) && sg_page(sg);
 			     ++k, sg = sg_next(sg)) {
 				SCSI_LOG_TIMEOUT(5, printk(
 				    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
-				    k, sg->page, sg->length));
-				sg_page_free(sg->page, sg->length);
+				    k, sg_page(sg), sg->length));
+				sg_page_free(sg_page(sg), sg->length);
 			}
 		}
 		kfree(schp->buffer);
@@ -2038,7 +2038,7 @@ sg_read_xfer(Sg_request * srp)
 	} else
 		onum = 1;
 
-	p = page_address(sg->page);
+	p = page_address(sg_page(sg));
 	ksglen = sg->length;
 	for (j = 0, k = 0; j < onum; ++j) {
 		res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
@@ -2046,7 +2046,7 @@ sg_read_xfer(Sg_request * srp)
 			return res;
 
 		for (; p; sg = sg_next(sg), ksglen = sg->length,
-		     p = page_address(sg->page)) {
+		     p = page_address(sg_page(sg))) {
 			if (usglen <= 0)
 				break;
 			if (ksglen > usglen) {
@@ -2092,15 +2092,15 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 	if ((!outp) || (num_read_xfer <= 0))
 		return 0;
 
-	for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, sg = sg_next(sg)) {
+	for (k = 0; (k < schp->k_use_sg) && sg_page(sg); ++k, sg = sg_next(sg)) {
 		num = sg->length;
 		if (num > num_read_xfer) {
-			if (__copy_to_user(outp, page_address(sg->page),
+			if (__copy_to_user(outp, page_address(sg_page(sg)),
 					   num_read_xfer))
 				return -EFAULT;
 			break;
 		} else {
-			if (__copy_to_user(outp, page_address(sg->page),
+			if (__copy_to_user(outp, page_address(sg_page(sg)),
 					   num))
 				return -EFAULT;
 			num_read_xfer -= num;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 73c44cb..ce69b9e 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3797,7 +3797,7 @@ static void buf_to_sg(struct st_buffer *STbp, unsigned int length)
 	sg = &(STbp->sg[0]);
 	frp = STbp->frp;
 	for (i=count=0; count < length; i++) {
-		sg[i].page = frp[i].page;
+		sg_set_page(&sg[i], frp[i].page);
 		if (length - count > frp[i].length)
 			sg[i].length = frp[i].length;
 		else
@@ -4446,14 +4446,14 @@ static int sgl_map_user_pages(struct scatterlist *sgl, const unsigned int max_pa
         }
 
 	/* Populate the scatter/gather list */
-	sgl[0].page = pages[0]; 
+	sg_set_page(&sgl[0], pages[0]);
 	sgl[0].offset = uaddr & ~PAGE_MASK;
 	if (nr_pages > 1) {
 		sgl[0].length = PAGE_SIZE - sgl[0].offset;
 		count -= sgl[0].length;
 		for (i=1; i < nr_pages ; i++) {
+			sg_set_page(&sgl[i], pages[i]);;
 			sgl[i].offset = 0;
-			sgl[i].page = pages[i]; 
 			sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
 			count -= PAGE_SIZE;
 		}
@@ -4483,7 +4483,7 @@ static int sgl_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_p
 	int i;
 
 	for (i=0; i < nr_pages; i++) {
-		struct page *page = sgl[i].page;
+		struct page *page = sg_page(&sgl[i]);
 
 		if (dirtied)
 			SetPageDirty(page);
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 8befab7..90cee94 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -196,7 +196,7 @@ static unsigned int sym53c416_base_3[2] = {0,0};
 
 #define MAXHOSTS 4
 
-#define SG_ADDRESS(buffer)     ((char *) (page_address((buffer)->page)+(buffer)->offset))
+#define SG_ADDRESS(buffer)     ((char *) sg_virt((buffer)))
 
 enum phases
 {
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 5c72ca3..4419304 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -430,10 +430,7 @@ static __inline__ void dc390_Going_remove (struct dc390_dcb* pDCB, struct dc390_
 
 static struct scatterlist* dc390_sg_build_single(struct scatterlist *sg, void *addr, unsigned int length)
 {
-	memset(sg, 0, sizeof(struct scatterlist));
-	sg->page	= virt_to_page(addr);
-	sg->length	= length;
-	sg->offset	= (unsigned long)addr & ~PAGE_MASK;
+	sg_init_one(sg, addr, length);
 	return sg;
 }
 
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index ea72bbe..6d1f0ed 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -681,7 +681,7 @@ static inline void build_sg_list(struct mscp *mscp, struct scsi_cmnd *SCpnt)
 
 	max = scsi_sg_count(SCpnt);
 	scsi_for_each_sg(SCpnt, sg, max, i) {
-		mscp->sglist[i].address = isa_page_to_bus(sg->page) + sg->offset;
+		mscp->sglist[i].address = isa_page_to_bus(sg_page(sg)) + sg->offset;
 		mscp->sglist[i].num_bytes = sg->length;
 		transfer_length += sg->length;
 	}
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 255c611..03cd44f 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1123,7 +1123,7 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 		any2scsi(scb->maxlen, nseg * sizeof(Sgb));
 
 		scsi_for_each_sg(SCpnt, sg, nseg, i) {
-			any2scsi(sgb[i].ptr, isa_page_to_bus(sg->page) + sg->offset);
+			any2scsi(sgb[i].ptr, isa_page_to_bus(sg_page(sg)) + sg->offset);
 			any2scsi(sgb[i].len, sg->length);
 		}
 	} else {
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 8dd5a6a..90d64a8 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -437,13 +437,11 @@ int usb_sg_init (
 #if defined(CONFIG_HIGHMEM) || defined(CONFIG_IOMMU)
 			io->urbs[i]->transfer_buffer = NULL;
 #else
-			io->urbs[i]->transfer_buffer =
-				page_address(sg[i].page) + sg[i].offset;
+			io->urbs[i]->transfer_buffer = sg_virt(&sg[i]);
 #endif
 		} else {
 			/* hc may use _only_ transfer_buffer */
-			io->urbs [i]->transfer_buffer =
-				page_address (sg [i].page) + sg [i].offset;
+			io->urbs [i]->transfer_buffer = sg_virt(&sg[i]);
 			len = sg [i].length;
 		}
 
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index e7d982a..91e999c 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -519,8 +519,7 @@ static void mts_do_sg (struct urb* transfer)
 	context->fragment++;
 	mts_int_submit_urb(transfer,
 			   context->data_pipe,
-			   page_address(sg[context->fragment].page) +
-			   sg[context->fragment].offset,
+			   sg_virt(&sg[context->fragment]),
 			   sg[context->fragment].length,
 			   context->fragment + 1 == scsi_sg_count(context->srb) ?
 			   mts_data_done : mts_do_sg);
@@ -557,7 +556,7 @@ mts_build_transfer_context(struct scsi_cmnd *srb, struct mts_desc* desc)
 		return;
 	} else {
 		sg = scsi_sglist(srb);
-		desc->context.data = page_address(sg[0].page) + sg[0].offset;
+		desc->context.data = sg_virt(&sg[0]);
 		desc->context.data_length = sg[0].length;
 	}
 
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index e901d31..ea31621 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -360,9 +360,9 @@ static void free_sglist (struct scatterlist *sg, int nents)
 	if (!sg)
 		return;
 	for (i = 0; i < nents; i++) {
-		if (!sg [i].page)
+		if (!sg_page(&sg[i]))
 			continue;
-		kfree (page_address (sg [i].page) + sg [i].offset);
+		kfree (sg_virt(&sg[i]));
 	}
 	kfree (sg);
 }
diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index cc8f7c5..889622b 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -195,7 +195,7 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 		 * the *offset and *index values for the next loop. */
 		cnt = 0;
 		while (cnt < buflen) {
-			struct page *page = sg->page +
+			struct page *page = sg_page(sg) +
 					((sg->offset + *offset) >> PAGE_SHIFT);
 			unsigned int poff =
 					(sg->offset + *offset) & (PAGE_SIZE-1);
-- 
1.5.3.GIT

