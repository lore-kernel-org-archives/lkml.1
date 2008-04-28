Return-Path: <linux-kernel-owner+w=401wt.eu-S935437AbYD1Xus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935437AbYD1Xus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934906AbYD1Xt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:49:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:6972 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628AbYD1Xt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YkGQWhXnXRU0WoibN3RZhzzELjkvoY7UNYjE2SveQxZsl+c5aqpUqX4JBTU3WR4cVC5L+i5Os6ZgY2mdONQSMCntXMCnFRn50BVlFYAVBHaVVqVoPT12gZe3LdOkByze/+/wdbCZs1/vf8Fe2ygHjy2lFMNxjSvAqRSaoxTr+oY=
Subject: [PATCH 2/3] media: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 16:50:03 -0700
Message-Id: <1209426603.24729.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/video/v4l2-common.c:719:16: warning: Using plain integer as NULL pointer
drivers/media/video/au0828/au0828-dvb.c:122:19: warning: Using plain integer as NULL pointer
drivers/media/video/ivtv/ivtv-yuv.c:1101:22: warning: Using plain integer as NULL pointer
drivers/media/video/ivtv/ivtv-yuv.c:1102:23: warning: Using plain integer as NULL pointer
drivers/media/video/pvrusb2/pvrusb2-audio.c:78:39: warning: Using plain integer as NULL pointer
drivers/media/video/pvrusb2/pvrusb2-video-v4l.c:84:39: warning: Using plain integer as NULL pointer
drivers/media/video/pvrusb2/pvrusb2-v4l2.c:1264:9: warning: Using plain integer as NULL pointer
drivers/media/video/pvrusb2/pvrusb2-context.c:197:28: warning: Using plain integer as NULL pointer
drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c:126:39: warning: Using plain integer as NULL pointer
drivers/media/video/pvrusb2/pvrusb2-dvb.c:133:32: warning: Using plain integer as NULL pointer
drivers/media/video/pvrusb2/pvrusb2-dvb.c:145:31: warning: Using plain integer as NULL pointer
drivers/media/video/pvrusb2/pvrusb2-dvb.c:177:55: warning: Using plain integer as NULL pointer
drivers/media/video/videobuf-core.c:100:9: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/video/au0828/au0828-dvb.c           |    2 +-
 drivers/media/video/ivtv/ivtv-yuv.c               |    4 ++--
 drivers/media/video/pvrusb2/pvrusb2-audio.c       |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-context.c     |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-dvb.c         |    6 +++---
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c        |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.c   |    2 +-
 drivers/media/video/v4l2-common.c                 |    2 +-
 drivers/media/video/videobuf-core.c               |    5 ++++-
 10 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-dvb.c b/drivers/media/video/au0828/au0828-dvb.c
index 5040d7f..1371b4e 100644
--- a/drivers/media/video/au0828/au0828-dvb.c
+++ b/drivers/media/video/au0828/au0828-dvb.c
@@ -119,7 +119,7 @@ static int start_urb_transfer(struct au0828_dev *dev)
 		purb->transfer_buffer = kzalloc(URB_BUFSIZE, GFP_KERNEL);
 		if (!purb->transfer_buffer) {
 			usb_free_urb(purb);
-			dev->urbs[i] = 0;
+			dev->urbs[i] = NULL;
 			goto err;
 		}
 
diff --git a/drivers/media/video/ivtv/ivtv-yuv.c b/drivers/media/video/ivtv/ivtv-yuv.c
index 393d917..62f70bd 100644
--- a/drivers/media/video/ivtv/ivtv-yuv.c
+++ b/drivers/media/video/ivtv/ivtv-yuv.c
@@ -1098,8 +1098,8 @@ void ivtv_yuv_setup_stream_frame(struct ivtv *itv)
 	ivtv_yuv_next_free(itv);
 
 	/* Copy V4L2 parameters to an ivtv_dma_frame struct... */
-	dma_args.y_source = 0L;
-	dma_args.uv_source = 0L;
+	dma_args.y_source = NULL;
+	dma_args.uv_source = NULL;
 	dma_args.src.left = 0;
 	dma_args.src.top = 0;
 	dma_args.src.width = yi->v4l2_src_w;
diff --git a/drivers/media/video/pvrusb2/pvrusb2-audio.c b/drivers/media/video/pvrusb2/pvrusb2-audio.c
index 9a7c8e9..8d859cc 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-audio.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-audio.c
@@ -75,7 +75,7 @@ static void set_stereo(struct pvr2_msp3400_handler *ctxt)
 	pvr2_trace(PVR2_TRACE_CHIPS,"i2c msp3400 v4l2 set_stereo");
 
 	if ((sid < ARRAY_SIZE(routing_schemes)) &&
-	    ((sp = routing_schemes + sid) != 0) &&
+	    ((sp = routing_schemes + sid) != NULL) &&
 	    (hdw->input_val >= 0) &&
 	    (hdw->input_val < sp->cnt)) {
 		route.input = sp->def[hdw->input_val];
diff --git a/drivers/media/video/pvrusb2/pvrusb2-context.c b/drivers/media/video/pvrusb2/pvrusb2-context.c
index b5db6a5..73dcb1c 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-context.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-context.c
@@ -195,7 +195,7 @@ static int pvr2_context_thread_func(void *foo)
 int pvr2_context_global_init(void)
 {
 	pvr2_context_thread_ptr = kthread_run(pvr2_context_thread_func,
-					      0,
+					      NULL,
 					      "pvrusb2-context");
 	return (pvr2_context_thread_ptr ? 0 : -ENOMEM);
 }
diff --git a/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c b/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
index 97350b0..29d5059 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
@@ -123,7 +123,7 @@ static void set_input(struct pvr2_v4l_cx2584x *ctxt)
 	memset(&route,0,sizeof(route));
 
 	if ((sid < ARRAY_SIZE(routing_schemes)) &&
-	    ((sp = routing_schemes + sid) != 0) &&
+	    ((sp = routing_schemes + sid) != NULL) &&
 	    (hdw->input_val >= 0) &&
 	    (hdw->input_val < sp->cnt)) {
 		vid_input = sp->def[hdw->input_val].vid;
diff --git a/drivers/media/video/pvrusb2/pvrusb2-dvb.c b/drivers/media/video/pvrusb2/pvrusb2-dvb.c
index 2e64f98..6504c97 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-dvb.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-dvb.c
@@ -130,7 +130,7 @@ static void pvr2_dvb_stream_end(struct pvr2_dvb_adapter *adap)
 		for (idx = 0; idx < PVR2_DVB_BUFFER_COUNT; idx++) {
 			if (!(adap->buffer_storage[idx])) continue;
 			kfree(adap->buffer_storage[idx]);
-			adap->buffer_storage[idx] = 0;
+			adap->buffer_storage[idx] = NULL;
 		}
 		adap->stream_run = 0;
 	}
@@ -142,7 +142,7 @@ static int pvr2_dvb_stream_do_start(struct pvr2_dvb_adapter *adap)
 	unsigned int idx;
 	int ret;
 	struct pvr2_buffer *bp;
-	struct pvr2_stream *stream = 0;
+	struct pvr2_stream *stream = NULL;
 
 	if (adap->stream_run) return -EIO;
 
@@ -174,7 +174,7 @@ static int pvr2_dvb_stream_do_start(struct pvr2_dvb_adapter *adap)
 	ret = pvr2_hdw_set_streaming(adap->channel.hdw, 1);
 	if (ret < 0) return ret;
 
-	while ((bp = pvr2_stream_get_idle_buffer(stream)) != 0) {
+	while ((bp = pvr2_stream_get_idle_buffer(stream)) != NULL) {
 		ret = pvr2_buffer_queue(bp);
 		if (ret < 0) return ret;
 	}
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 087a182..e9b5d4e 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -1261,7 +1261,7 @@ struct pvr2_v4l2 *pvr2_v4l2_create(struct pvr2_context *mnp)
  fail:
 	pvr2_trace(PVR2_TRACE_STRUCT,"Failure creating pvr2_v4l2 id=%p",vp);
 	pvr2_v4l2_destroy_no_lock(vp);
-	return 0;
+	return NULL;
 }
 
 /*
diff --git a/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c b/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c
index 7c47345..2433a31 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c
@@ -81,7 +81,7 @@ static void set_input(struct pvr2_v4l_decoder *ctxt)
 	pvr2_trace(PVR2_TRACE_CHIPS,"i2c v4l2 set_input(%d)",hdw->input_val);
 
 	if ((sid < ARRAY_SIZE(routing_schemes)) &&
-	    ((sp = routing_schemes + sid) != 0) &&
+	    ((sp = routing_schemes + sid) != NULL) &&
 	    (hdw->input_val >= 0) &&
 	    (hdw->input_val < sp->cnt)) {
 		route.input = sp->def[hdw->input_val];
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 34deb68..7cc42c1 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -716,7 +716,7 @@ int v4l2_i2c_attach(struct i2c_adapter *adapter, int address, struct i2c_driver
 	int err;
 
 	client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
-	if (client == 0)
+	if (!client)
 		return -ENOMEM;
 
 	client->addr = address;
diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index fc51e49..982f446 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -97,7 +97,10 @@ int videobuf_iolock(struct videobuf_queue *q, struct videobuf_buffer *vb,
 void *videobuf_queue_to_vmalloc (struct videobuf_queue *q,
 			   struct videobuf_buffer *buf)
 {
-	return CALL(q, vmalloc, buf);
+	if (q->int_ops->vmalloc)
+		return q->int_ops->vmalloc(buf);
+	else
+		return NULL;
 }
 EXPORT_SYMBOL_GPL(videobuf_queue_to_vmalloc);
 
-- 
1.5.5.1.270.g89765


