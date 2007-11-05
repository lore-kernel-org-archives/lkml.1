Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbXKERNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbXKERNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbXKERHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:47 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59514 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757562AbXKERHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:07:46 -0500
Date: Mon, 5 Nov 2007 18:07:22 +0100
From: Adrian Bunk <bunk@kernel.org>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] cx88-mpeg.c: make 4 functions static
Message-ID: <20071105170722.GM12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- cx8802_init_common()
- cx8802_fini_common()
- cx8802_suspend_common()
- cx8802_resume_common()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/cx88/cx88-mpeg.c |   14 ++++----------
 drivers/media/video/cx88/cx88.h      |    6 ------
 2 files changed, 4 insertions(+), 16 deletions(-)

cfc675144973c2ae6188929e18194e27da937f43 
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 448c673..60ac423 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -437,10 +437,7 @@ static irqreturn_t cx8802_irq(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-/* ----------------------------------------------------------- */
-/* exported stuff                                              */
-
-int cx8802_init_common(struct cx8802_dev *dev)
+static int cx8802_init_common(struct cx8802_dev *dev)
 {
 	struct cx88_core *core = dev->core;
 	int err;
@@ -488,7 +485,7 @@ int cx8802_init_common(struct cx8802_dev *dev)
 	return 0;
 }
 
-void cx8802_fini_common(struct cx8802_dev *dev)
+static void cx8802_fini_common(struct cx8802_dev *dev)
 {
 	dprintk( 2, "cx8802_fini_common\n" );
 	cx8802_stop_dma(dev);
@@ -504,7 +501,7 @@ void cx8802_fini_common(struct cx8802_dev *dev)
 
 /* ----------------------------------------------------------- */
 
-int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
+static int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
 {
 	struct cx8802_dev *dev = pci_get_drvdata(pci_dev);
 	struct cx88_core *core = dev->core;
@@ -530,7 +527,7 @@ int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
 	return 0;
 }
 
-int cx8802_resume_common(struct pci_dev *pci_dev)
+static int cx8802_resume_common(struct pci_dev *pci_dev)
 {
 	struct cx8802_dev *dev = pci_get_drvdata(pci_dev);
 	struct cx88_core *core = dev->core;
@@ -874,9 +871,6 @@ EXPORT_SYMBOL(cx8802_buf_prepare);
 EXPORT_SYMBOL(cx8802_buf_queue);
 EXPORT_SYMBOL(cx8802_cancel_buffers);
 
-EXPORT_SYMBOL(cx8802_init_common);
-EXPORT_SYMBOL(cx8802_fini_common);
-
 EXPORT_SYMBOL(cx8802_register_driver);
 EXPORT_SYMBOL(cx8802_unregister_driver);
 EXPORT_SYMBOL(cx8802_get_driver);
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index eb296bd..bb1036a 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -633,12 +633,6 @@ int cx8802_buf_prepare(struct videobuf_queue *q,struct cx8802_dev *dev,
 void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf);
 void cx8802_cancel_buffers(struct cx8802_dev *dev);
 
-int cx8802_init_common(struct cx8802_dev *dev);
-void cx8802_fini_common(struct cx8802_dev *dev);
-
-int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state);
-int cx8802_resume_common(struct pci_dev *pci_dev);
-
 /* ----------------------------------------------------------- */
 /* cx88-video.c*/
 extern const u32 cx88_user_ctrls[];

