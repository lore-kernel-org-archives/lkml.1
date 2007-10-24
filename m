Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbXJXQYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbXJXQYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbXJXQWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:22:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33290 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754532AbXJXQWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:22:44 -0400
Date: Wed, 24 Oct 2007 18:23:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] video/saa7134/: make 2 functions static
Message-ID: <20071024162314.GI30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

saa7134_buffer_requeue() and set_tvnorm() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/saa7134/saa7134-core.c  |    4 ++--
 drivers/media/video/saa7134/saa7134-video.c |    2 +-
 drivers/media/video/saa7134/saa7134.h       |    4 ----
 3 files changed, 3 insertions(+), 7 deletions(-)

47fd0eba0eadebc28eac13b320e8f72879dc785a 
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 1a4a244..81ad03b 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -395,8 +395,8 @@ void saa7134_buffer_timeout(unsigned long data)
 
 /* resends a current buffer in queue after resume */
 
-int saa7134_buffer_requeue(struct saa7134_dev *dev,
-			 struct saa7134_dmaqueue *q)
+static int saa7134_buffer_requeue(struct saa7134_dev *dev,
+				  struct saa7134_dmaqueue *q)
 {
 	struct saa7134_buf *buf, *next;
 
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 471b927..bd3b303 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -540,7 +540,7 @@ void res_free(struct saa7134_dev *dev, struct saa7134_fh *fh, unsigned int bits)
 
 /* ------------------------------------------------------------------ */
 
-void set_tvnorm(struct saa7134_dev *dev, struct saa7134_tvnorm *norm)
+static void set_tvnorm(struct saa7134_dev *dev, struct saa7134_tvnorm *norm)
 {
 
 	dprintk("set tv norm = %s\n",norm->name);
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 28ec680..ac3ce77 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -595,9 +595,6 @@ void saa7134_buffer_next(struct saa7134_dev *dev, struct saa7134_dmaqueue *q);
 void saa7134_buffer_timeout(unsigned long data);
 void saa7134_dma_free(struct videobuf_queue *q,struct saa7134_buf *buf);
 
-int saa7134_buffer_requeue(struct saa7134_dev *dev,
-			 struct saa7134_dmaqueue *q);
-
 int saa7134_set_dmabits(struct saa7134_dev *dev);
 
 extern int (*saa7134_dmasound_init)(struct saa7134_dev *dev);
@@ -630,7 +627,6 @@ void saa7134_i2c_call_clients(struct saa7134_dev *dev,
 extern struct video_device saa7134_video_template;
 extern struct video_device saa7134_radio_template;
 
-void set_tvnorm(struct saa7134_dev *dev, struct saa7134_tvnorm *norm);
 int saa7134_videoport_init(struct saa7134_dev *dev);
 void saa7134_set_decoder(struct saa7134_dev *dev);
 

