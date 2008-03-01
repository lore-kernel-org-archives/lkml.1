Return-Path: <linux-kernel-owner+w=401wt.eu-S1763475AbYCAQ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763475AbYCAQ0d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762763AbYCAQVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:21:48 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57257 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762756AbYCAQVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:21:46 -0500
Date: Sat, 1 Mar 2008 18:20:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] libata-core.c: possible cleanups
Message-ID: <20080301162021.GU25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- make the following needlessly global functions static:
  - ata_exec_internal_sg()
  - ata_sg_clean()
- #if 0 the following no longer used global functions:
  - ata_do_simple_cmd()
  - ata_flush_cache()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ata/libata-core.c |   15 ++++++++++-----
 drivers/ata/libata.h      |    7 -------
 2 files changed, 10 insertions(+), 12 deletions(-)

362fd6b3a8398b5104b6346f996b0a27b4790c05 foobar
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 05c865f..2a73d11 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1751,10 +1751,11 @@ static void ata_qc_complete_internal(struct ata_queued_cmd *qc)
  *	RETURNS:
  *	Zero on success, AC_ERR_* mask on failure
  */
-unsigned ata_exec_internal_sg(struct ata_device *dev,
-			      struct ata_taskfile *tf, const u8 *cdb,
-			      int dma_dir, struct scatterlist *sgl,
-			      unsigned int n_elem, unsigned long timeout)
+static unsigned ata_exec_internal_sg(struct ata_device *dev,
+				     struct ata_taskfile *tf, const u8 *cdb,
+				     int dma_dir, struct scatterlist *sgl,
+				     unsigned int n_elem,
+				     unsigned long timeout)
 {
 	struct ata_link *link = dev->link;
 	struct ata_port *ap = link->ap;
@@ -1949,6 +1950,7 @@ unsigned ata_exec_internal(struct ata_device *dev,
 				    timeout);
 }
 
+#if 0
 /**
  *	ata_do_simple_cmd - execute simple internal command
  *	@dev: Device to which the command is sent
@@ -1975,6 +1977,7 @@ unsigned int ata_do_simple_cmd(struct ata_device *dev, u8 cmd)
 
 	return ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 }
+#endif  /*  0  */
 
 /**
  *	ata_pio_need_iordy	-	check if iordy needed
@@ -4692,7 +4695,7 @@ static unsigned int ata_dev_init_params(struct ata_device *dev,
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-void ata_sg_clean(struct ata_queued_cmd *qc)
+static void ata_sg_clean(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg = qc->sg;
@@ -6464,6 +6467,7 @@ int ata_link_offline(struct ata_link *link)
 	return 0;
 }
 
+#if 0
 int ata_flush_cache(struct ata_device *dev)
 {
 	unsigned int err_mask;
@@ -6489,6 +6493,7 @@ int ata_flush_cache(struct ata_device *dev)
 
 	return 0;
 }
+#endif  /*  0  */
 
 #ifdef CONFIG_PM
 static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 165cb49..13cb98a 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -72,11 +72,6 @@ extern unsigned ata_exec_internal(struct ata_device *dev,
 				  struct ata_taskfile *tf, const u8 *cdb,
 				  int dma_dir, void *buf, unsigned int buflen,
 				  unsigned long timeout);
-extern unsigned ata_exec_internal_sg(struct ata_device *dev,
-				     struct ata_taskfile *tf, const u8 *cdb,
-				     int dma_dir, struct scatterlist *sg,
-				     unsigned int n_elem, unsigned long timeout);
-extern unsigned int ata_do_simple_cmd(struct ata_device *dev, u8 cmd);
 extern int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 			   unsigned int flags, u16 *id);
 extern int ata_dev_reread_id(struct ata_device *dev, unsigned int readid_flags);
@@ -86,7 +81,6 @@ extern int ata_dev_configure(struct ata_device *dev);
 extern int sata_down_spd_limit(struct ata_link *link);
 extern int sata_set_spd_needed(struct ata_link *link);
 extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
-extern void ata_sg_clean(struct ata_queued_cmd *qc);
 extern void ata_qc_free(struct ata_queued_cmd *qc);
 extern void ata_qc_issue(struct ata_queued_cmd *qc);
 extern void __ata_qc_complete(struct ata_queued_cmd *qc);
@@ -94,7 +88,6 @@ extern int ata_check_atapi_dma(struct ata_queued_cmd *qc);
 extern void ata_dev_select(struct ata_port *ap, unsigned int device,
                            unsigned int wait, unsigned int can_sleep);
 extern void swap_buf_le16(u16 *buf, unsigned int buf_words);
-extern int ata_flush_cache(struct ata_device *dev);
 extern void ata_dev_init(struct ata_device *dev);
 extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
 extern int sata_link_init_spd(struct ata_link *link);

