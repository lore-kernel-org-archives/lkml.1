Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbYCJVTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbYCJVTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYCJVTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:19:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:29032 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbYCJVTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CutXwcm12ZutQDn/W8M+w1mSweDXaYvMY5ZPWTnFD2hsrzJGQ44k8JmCFaZT6f2LNMW9G/lpLnzHA8EFz6O4gGXenjPOGnT+7GfdwXgg1YIb1bqFE3QgCxAlwY+a0yD1vFaQ5fDx987y/cGDn7g3olfNYuIFwppZHvo8ioAe2wQ=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH 1/3 v4l-dvb] v4l: fix coding style violations in v4l1-compat.c
Date: Mon, 10 Mar 2008 22:19:02 +0100
Message-Id: <1205183942-28007-1-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: 20080310145707.6815fbf0@gaivota
References: 20080310145707.6815fbf0@gaivota
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix most coding style violations found by checkpatch

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/video/v4l1-compat.c |  184 ++++++++++++++++++-------------------
 1 files changed, 90 insertions(+), 94 deletions(-)

diff --git a/drivers/media/video/v4l1-compat.c b/drivers/media/video/v4l1-compat.c
index ffd3f10..6455b2f 100644
--- a/drivers/media/video/v4l1-compat.c
+++ b/drivers/media/video/v4l1-compat.c
@@ -41,13 +41,16 @@
 
 static unsigned int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug,"enable debug messages");
+MODULE_PARM_DESC(debug, "enable debug messages");
 MODULE_AUTHOR("Bill Dirks");
 MODULE_DESCRIPTION("v4l(1) compatibility layer for v4l2 drivers.");
 MODULE_LICENSE("GPL");
 
-#define dprintk(fmt, arg...)	if (debug) \
-	printk(KERN_DEBUG "v4l1-compat: " fmt , ## arg)
+#define dprintk(fmt, arg...) \
+	do { \
+		if (debug) \
+			printk(KERN_DEBUG "v4l1-compat: " fmt , ## arg);\
+	} while (0)
 
 /*
  *	I O C T L   T R A N S L A T I O N
@@ -69,14 +72,12 @@ get_v4l_control(struct inode            *inode,
 	qctrl2.id = cid;
 	err = drv(inode, file, VIDIOC_QUERYCTRL, &qctrl2);
 	if (err < 0)
-		dprintk("VIDIOC_QUERYCTRL: %d\n",err);
-	if (err == 0 &&
-	    !(qctrl2.flags & V4L2_CTRL_FLAG_DISABLED))
-	{
+		dprintk("VIDIOC_QUERYCTRL: %d\n", err);
+	if (err == 0 && !(qctrl2.flags & V4L2_CTRL_FLAG_DISABLED)) {
 		ctrl2.id = qctrl2.id;
 		err = drv(inode, file, VIDIOC_G_CTRL, &ctrl2);
 		if (err < 0) {
-			dprintk("VIDIOC_G_CTRL: %d\n",err);
+			dprintk("VIDIOC_G_CTRL: %d\n", err);
 			return 0;
 		}
 		return ((ctrl2.value - qctrl2.minimum) * 65535
@@ -100,11 +101,10 @@ set_v4l_control(struct inode            *inode,
 	qctrl2.id = cid;
 	err = drv(inode, file, VIDIOC_QUERYCTRL, &qctrl2);
 	if (err < 0)
-		dprintk("VIDIOC_QUERYCTRL: %d\n",err);
+		dprintk("VIDIOC_QUERYCTRL: %d\n", err);
 	if (err == 0 &&
 	    !(qctrl2.flags & V4L2_CTRL_FLAG_DISABLED) &&
-	    !(qctrl2.flags & V4L2_CTRL_FLAG_GRABBED))
-	{
+	    !(qctrl2.flags & V4L2_CTRL_FLAG_GRABBED)) {
 		if (value < 0)
 			value = 0;
 		if (value > 65535)
@@ -119,7 +119,7 @@ set_v4l_control(struct inode            *inode,
 		ctrl2.value += qctrl2.minimum;
 		err = drv(inode, file, VIDIOC_S_CTRL, &ctrl2);
 		if (err < 0)
-			dprintk("VIDIOC_S_CTRL: %d\n",err);
+			dprintk("VIDIOC_S_CTRL: %d\n", err);
 	}
 	return 0;
 }
@@ -157,8 +157,7 @@ static unsigned int __attribute_const__
 pixelformat_to_palette(unsigned int pixelformat)
 {
 	int	palette = 0;
-	switch (pixelformat)
-	{
+	switch (pixelformat) {
 	case V4L2_PIX_FMT_GREY:
 		palette = VIDEO_PALETTE_GREY;
 		break;
@@ -234,9 +233,9 @@ static int count_inputs(struct inode         *inode,
 	int i;
 
 	for (i = 0;; i++) {
-		memset(&input2,0,sizeof(input2));
+		memset(&input2, 0, sizeof(input2));
 		input2.index = i;
-		if (0 != drv(inode,file,VIDIOC_ENUMINPUT, &input2))
+		if (0 != drv(inode, file, VIDIOC_ENUMINPUT, &input2))
 			break;
 	}
 	return i;
@@ -250,18 +249,18 @@ static int check_size(struct inode         *inode,
 	struct v4l2_fmtdesc desc2;
 	struct v4l2_format  fmt2;
 
-	memset(&desc2,0,sizeof(desc2));
-	memset(&fmt2,0,sizeof(fmt2));
+	memset(&desc2, 0, sizeof(desc2));
+	memset(&fmt2, 0, sizeof(fmt2));
 
 	desc2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	if (0 != drv(inode,file,VIDIOC_ENUM_FMT, &desc2))
+	if (0 != drv(inode, file, VIDIOC_ENUM_FMT, &desc2))
 		goto done;
 
 	fmt2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	fmt2.fmt.pix.width       = 10000;
 	fmt2.fmt.pix.height      = 10000;
 	fmt2.fmt.pix.pixelformat = desc2.pixelformat;
-	if (0 != drv(inode,file,VIDIOC_TRY_FMT, &fmt2))
+	if (0 != drv(inode, file, VIDIOC_TRY_FMT, &fmt2))
 		goto done;
 
 	*maxw = fmt2.fmt.pix.width;
@@ -313,13 +312,13 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 
 		err = drv(inode, file, VIDIOC_QUERYCAP, cap2);
 		if (err < 0) {
-			dprintk("VIDIOCGCAP / VIDIOC_QUERYCAP: %d\n",err);
+			dprintk("VIDIOCGCAP / VIDIOC_QUERYCAP: %d\n", err);
 			break;
 		}
 		if (cap2->capabilities & V4L2_CAP_VIDEO_OVERLAY) {
 			err = drv(inode, file, VIDIOC_G_FBUF, &fbuf2);
 			if (err < 0) {
-				dprintk("VIDIOCGCAP / VIDIOC_G_FBUF: %d\n",err);
+				dprintk("VIDIOCGCAP / VIDIOC_G_FBUF: %d\n", err);
 				memset(&fbuf2, 0, sizeof(fbuf2));
 			}
 			err = 0;
@@ -339,9 +338,9 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		if (fbuf2.capability & V4L2_FBUF_CAP_LIST_CLIPPING)
 			cap->type |= VID_TYPE_CLIPPING;
 
-		cap->channels  = count_inputs(inode,file,drv);
-		check_size(inode,file,drv,
-			   &cap->maxwidth,&cap->maxheight);
+		cap->channels  = count_inputs(inode, file, drv);
+		check_size(inode, file, drv,
+			   &cap->maxwidth, &cap->maxheight);
 		cap->audios    =  0; /* FIXME */
 		cap->minwidth  = 48; /* FIXME */
 		cap->minheight = 32; /* FIXME */
@@ -356,7 +355,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 
 		err = drv(inode, file, VIDIOC_G_FBUF, &fbuf2);
 		if (err < 0) {
-			dprintk("VIDIOCGFBUF / VIDIOC_G_FBUF: %d\n",err);
+			dprintk("VIDIOCGFBUF / VIDIOC_G_FBUF: %d\n", err);
 			break;
 		}
 		buffer->base   = fbuf2.base;
@@ -386,8 +385,8 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 			buffer->bytesperline = fbuf2.fmt.bytesperline;
 			if (!buffer->depth && buffer->width)
 				buffer->depth   = ((fbuf2.fmt.bytesperline<<3)
-						  + (buffer->width-1) )
-						  /buffer->width;
+						  + (buffer->width-1))
+						  / buffer->width;
 		} else {
 			buffer->bytesperline =
 				(buffer->width * buffer->depth + 7) & 7;
@@ -423,7 +422,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		fbuf2.fmt.bytesperline = buffer->bytesperline;
 		err = drv(inode, file, VIDIOC_S_FBUF, &fbuf2);
 		if (err < 0)
-			dprintk("VIDIOCSFBUF / VIDIOC_S_FBUF: %d\n",err);
+			dprintk("VIDIOCSFBUF / VIDIOC_S_FBUF: %d\n", err);
 		break;
 	}
 	case VIDIOCGWIN: /*  get window or capture dimensions  */
@@ -435,12 +434,12 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 			err = -ENOMEM;
 			break;
 		}
-		memset(win,0,sizeof(*win));
+		memset(win, 0, sizeof(*win));
 
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
 		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
 		if (err < 0)
-			dprintk("VIDIOCGWIN / VIDIOC_G_WIN: %d\n",err);
+			dprintk("VIDIOCGWIN / VIDIOC_G_WIN: %d\n", err);
 		if (err == 0) {
 			win->x         = fmt2->fmt.win.w.left;
 			win->y         = fmt2->fmt.win.w.top;
@@ -455,7 +454,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
 		if (err < 0) {
-			dprintk("VIDIOCGWIN / VIDIOC_G_FMT: %d\n",err);
+			dprintk("VIDIOCGWIN / VIDIOC_G_FMT: %d\n", err);
 			break;
 		}
 		win->x         = 0;
@@ -470,7 +469,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 	case VIDIOCSWIN: /*  set window and/or capture dimensions  */
 	{
 		struct video_window	*win = arg;
-		int err1,err2;
+		int err1, err2;
 
 		fmt2 = kzalloc(sizeof(*fmt2), GFP_KERNEL);
 		if (!fmt2) {
@@ -481,7 +480,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		drv(inode, file, VIDIOC_STREAMOFF, &fmt2->type);
 		err1 = drv(inode, file, VIDIOC_G_FMT, fmt2);
 		if (err1 < 0)
-			dprintk("VIDIOCSWIN / VIDIOC_G_FMT: %d\n",err);
+			dprintk("VIDIOCSWIN / VIDIOC_G_FMT: %d\n", err);
 		if (err1 == 0) {
 			fmt2->fmt.pix.width  = win->width;
 			fmt2->fmt.pix.height = win->height;
@@ -495,7 +494,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 			win->height = fmt2->fmt.pix.height;
 		}
 
-		memset(fmt2,0,sizeof(*fmt2));
+		memset(fmt2, 0, sizeof(*fmt2));
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_OVERLAY;
 		fmt2->fmt.win.w.left    = win->x;
 		fmt2->fmt.win.w.top     = win->y;
@@ -506,7 +505,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		fmt2->fmt.win.clipcount = win->clipcount;
 		err2 = drv(inode, file, VIDIOC_S_FMT, fmt2);
 		if (err2 < 0)
-			dprintk("VIDIOCSWIN / VIDIOC_S_FMT #2: %d\n",err);
+			dprintk("VIDIOCSWIN / VIDIOC_S_FMT #2: %d\n", err);
 
 		if (err1 != 0 && err2 != 0)
 			err = err1;
@@ -524,19 +523,19 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		}
 		err = drv(inode, file, VIDIOC_OVERLAY, arg);
 		if (err < 0)
-			dprintk("VIDIOCCAPTURE / VIDIOC_PREVIEW: %d\n",err);
+			dprintk("VIDIOCCAPTURE / VIDIOC_PREVIEW: %d\n", err);
 		break;
 	}
 	case VIDIOCGCHAN: /*  get input information  */
 	{
 		struct video_channel	*chan = arg;
 
-		memset(&input2,0,sizeof(input2));
+		memset(&input2, 0, sizeof(input2));
 		input2.index = chan->channel;
 		err = drv(inode, file, VIDIOC_ENUMINPUT, &input2);
 		if (err < 0) {
 			dprintk("VIDIOCGCHAN / VIDIOC_ENUMINPUT: "
-				"channel=%d err=%d\n",chan->channel,err);
+				"channel=%d err=%d\n", chan->channel, err);
 			break;
 		}
 		chan->channel = input2.index;
@@ -557,7 +556,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		chan->norm = 0;
 		err = drv(inode, file, VIDIOC_G_STD, &sid);
 		if (err < 0)
-			dprintk("VIDIOCGCHAN / VIDIOC_G_STD: %d\n",err);
+			dprintk("VIDIOCGCHAN / VIDIOC_G_STD: %d\n", err);
 		if (err == 0) {
 			if (sid & V4L2_STD_PAL)
 				chan->norm = VIDEO_MODE_PAL;
@@ -575,7 +574,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		sid = 0;
 		err = drv(inode, file, VIDIOC_S_INPUT, &chan->channel);
 		if (err < 0)
-			dprintk("VIDIOCSCHAN / VIDIOC_S_INPUT: %d\n",err);
+			dprintk("VIDIOCSCHAN / VIDIOC_S_INPUT: %d\n", err);
 		switch (chan->norm) {
 		case VIDEO_MODE_PAL:
 			sid = V4L2_STD_PAL;
@@ -590,7 +589,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		if (0 != sid) {
 			err = drv(inode, file, VIDIOC_S_STD, &sid);
 			if (err < 0)
-				dprintk("VIDIOCSCHAN / VIDIOC_S_STD: %d\n",err);
+				dprintk("VIDIOCSCHAN / VIDIOC_S_STD: %d\n", err);
 		}
 		break;
 	}
@@ -605,7 +604,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		}
 
 		pict->brightness = get_v4l_control(inode, file,
-						   V4L2_CID_BRIGHTNESS,drv);
+						   V4L2_CID_BRIGHTNESS, drv);
 		pict->hue = get_v4l_control(inode, file,
 					    V4L2_CID_HUE, drv);
 		pict->contrast = get_v4l_control(inode, file,
@@ -618,13 +617,13 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
 		if (err < 0) {
-			dprintk("VIDIOCGPICT / VIDIOC_G_FMT: %d\n",err);
+			dprintk("VIDIOCGPICT / VIDIOC_G_FMT: %d\n", err);
 			break;
 		}
 
-		pict->depth   = ((fmt2->fmt.pix.bytesperline<<3)
-				 + (fmt2->fmt.pix.width-1) )
-				 /fmt2->fmt.pix.width;
+		pict->depth   = ((fmt2->fmt.pix.bytesperline << 3)
+				 + (fmt2->fmt.pix.width - 1))
+				 / fmt2->fmt.pix.width;
 		pict->palette = pixelformat_to_palette(
 			fmt2->fmt.pix.pixelformat);
 		break;
@@ -664,7 +663,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		   support memory capture.  Trying to set the memory capture
 		   parameters would be pointless.  */
 		if (err < 0) {
-			dprintk("VIDIOCSPICT / VIDIOC_G_FMT: %d\n",err);
+			dprintk("VIDIOCSPICT / VIDIOC_G_FMT: %d\n", err);
 			mem_err = -1000;  /* didn't even try */
 		} else if (fmt2->fmt.pix.pixelformat !=
 			 palette_to_pixelformat(pict->palette)) {
@@ -681,7 +680,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		   support overlay.  Trying to set the overlay parameters
 		   would be quite pointless.  */
 		if (err < 0) {
-			dprintk("VIDIOCSPICT / VIDIOC_G_FBUF: %d\n",err);
+			dprintk("VIDIOCSPICT / VIDIOC_G_FBUF: %d\n", err);
 			ovl_err = -1000;  /* didn't even try */
 		} else if (fbuf2.fmt.pixelformat !=
 			 palette_to_pixelformat(pict->palette)) {
@@ -692,16 +691,15 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 				dprintk("VIDIOCSPICT / VIDIOC_S_FBUF: %d\n",
 					ovl_err);
 		}
-		if (ovl_err < 0 && mem_err < 0)
+		if (ovl_err < 0 && mem_err < 0) {
 			/* ioctl failed, couldn't set either parameter */
-			if (mem_err != -1000) {
-			    err = mem_err;
-			} else if (ovl_err == -EPERM) {
-			    err = 0;
-			} else {
-			    err = ovl_err;
-			}
-		else
+			if (mem_err != -1000)
+				err = mem_err;
+			else if (ovl_err == -EPERM)
+				err = 0;
+			else
+				err = ovl_err;
+		} else
 			err = 0;
 		break;
 	}
@@ -709,10 +707,10 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 	{
 		struct video_tuner	*tun = arg;
 
-		memset(&tun2,0,sizeof(tun2));
+		memset(&tun2, 0, sizeof(tun2));
 		err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
 		if (err < 0) {
-			dprintk("VIDIOCGTUNER / VIDIOC_G_TUNER: %d\n",err);
+			dprintk("VIDIOCGTUNER / VIDIOC_G_TUNER: %d\n", err);
 			break;
 		}
 		memcpy(tun->name, tun2.name,
@@ -724,7 +722,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		tun->mode = VIDEO_MODE_AUTO;
 
 		for (i = 0; i < 64; i++) {
-			memset(&std2,0,sizeof(std2));
+			memset(&std2, 0, sizeof(std2));
 			std2.index = i;
 			if (0 != drv(inode, file, VIDIOC_ENUMSTD, &std2))
 				break;
@@ -738,7 +736,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 
 		err = drv(inode, file, VIDIOC_G_STD, &sid);
 		if (err < 0)
-			dprintk("VIDIOCGTUNER / VIDIOC_G_STD: %d\n",err);
+			dprintk("VIDIOCGTUNER / VIDIOC_G_STD: %d\n", err);
 		if (err == 0) {
 			if (sid & V4L2_STD_PAL)
 				tun->mode = VIDEO_MODE_PAL;
@@ -759,25 +757,25 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 	{
 		struct video_tuner	*tun = arg;
 		struct v4l2_tuner	t;
-		memset(&t,0,sizeof(t));
+		memset(&t, 0, sizeof(t));
 
-		t.index=tun->tuner;
+		t.index = tun->tuner;
 
 		err = drv(inode, file, VIDIOC_S_INPUT, &t);
 		if (err < 0)
-			dprintk("VIDIOCSTUNER / VIDIOC_S_INPUT: %d\n",err);
+			dprintk("VIDIOCSTUNER / VIDIOC_S_INPUT: %d\n", err);
 
 		break;
 	}
 	case VIDIOCGFREQ: /*  get frequency  */
 	{
 		unsigned long *freq = arg;
-		memset(&freq2,0,sizeof(freq2));
+		memset(&freq2, 0, sizeof(freq2));
 
 		freq2.tuner = 0;
 		err = drv(inode, file, VIDIOC_G_FREQUENCY, &freq2);
 		if (err < 0)
-			dprintk("VIDIOCGFREQ / VIDIOC_G_FREQUENCY: %d\n",err);
+			dprintk("VIDIOCGFREQ / VIDIOC_G_FREQUENCY: %d\n", err);
 		if (0 == err)
 			*freq = freq2.frequency;
 		break;
@@ -785,23 +783,23 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 	case VIDIOCSFREQ: /*  set frequency  */
 	{
 		unsigned long *freq = arg;
-		memset(&freq2,0,sizeof(freq2));
+		memset(&freq2, 0, sizeof(freq2));
 
 		drv(inode, file, VIDIOC_G_FREQUENCY, &freq2);
 		freq2.frequency = *freq;
 		err = drv(inode, file, VIDIOC_S_FREQUENCY, &freq2);
 		if (err < 0)
-			dprintk("VIDIOCSFREQ / VIDIOC_S_FREQUENCY: %d\n",err);
+			dprintk("VIDIOCSFREQ / VIDIOC_S_FREQUENCY: %d\n", err);
 		break;
 	}
 	case VIDIOCGAUDIO: /*  get audio properties/controls  */
 	{
 		struct video_audio	*aud = arg;
-		memset(&aud2,0,sizeof(aud2));
+		memset(&aud2, 0, sizeof(aud2));
 
 		err = drv(inode, file, VIDIOC_G_AUDIO, &aud2);
 		if (err < 0) {
-			dprintk("VIDIOCGAUDIO / VIDIOC_G_AUDIO: %d\n",err);
+			dprintk("VIDIOCGAUDIO / VIDIOC_G_AUDIO: %d\n", err);
 			break;
 		}
 		memcpy(aud->name, aud2.name,
@@ -842,10 +840,10 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 			aud->step = qctrl2.step;
 		aud->mode = 0;
 
-		memset(&tun2,0,sizeof(tun2));
+		memset(&tun2, 0, sizeof(tun2));
 		err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
 		if (err < 0) {
-			dprintk("VIDIOCGAUDIO / VIDIOC_G_TUNER: %d\n",err);
+			dprintk("VIDIOCGAUDIO / VIDIOC_G_TUNER: %d\n", err);
 			err = 0;
 			break;
 		}
@@ -862,13 +860,13 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 	{
 		struct video_audio	*aud = arg;
 
-		memset(&aud2,0,sizeof(aud2));
-		memset(&tun2,0,sizeof(tun2));
+		memset(&aud2, 0, sizeof(aud2));
+		memset(&tun2, 0, sizeof(tun2));
 
 		aud2.index = aud->audio;
 		err = drv(inode, file, VIDIOC_S_AUDIO, &aud2);
 		if (err < 0) {
-			dprintk("VIDIOCSAUDIO / VIDIOC_S_AUDIO: %d\n",err);
+			dprintk("VIDIOCSAUDIO / VIDIOC_S_AUDIO: %d\n", err);
 			break;
 		}
 
@@ -885,7 +883,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 
 		err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
 		if (err < 0)
-			dprintk("VIDIOCSAUDIO / VIDIOC_G_TUNER: %d\n",err);
+			dprintk("VIDIOCSAUDIO / VIDIOC_G_TUNER: %d\n", err);
 		if (err == 0) {
 			switch (aud->mode) {
 			default:
@@ -902,7 +900,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 			}
 			err = drv(inode, file, VIDIOC_S_TUNER, &tun2);
 			if (err < 0)
-				dprintk("VIDIOCSAUDIO / VIDIOC_S_TUNER: %d\n",err);
+				dprintk("VIDIOCSAUDIO / VIDIOC_S_TUNER: %d\n", err);
 		}
 		err = 0;
 		break;
@@ -916,19 +914,19 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 			err = -ENOMEM;
 			break;
 		}
-		memset(&buf2,0,sizeof(buf2));
+		memset(&buf2, 0, sizeof(buf2));
 
 		fmt2->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		err = drv(inode, file, VIDIOC_G_FMT, fmt2);
 		if (err < 0) {
-			dprintk("VIDIOCMCAPTURE / VIDIOC_G_FMT: %d\n",err);
+			dprintk("VIDIOCMCAPTURE / VIDIOC_G_FMT: %d\n", err);
 			break;
 		}
 		if (mm->width   != fmt2->fmt.pix.width  ||
 		    mm->height  != fmt2->fmt.pix.height ||
 		    palette_to_pixelformat(mm->format) !=
-		    fmt2->fmt.pix.pixelformat)
-		{/* New capture format...  */
+		    fmt2->fmt.pix.pixelformat) {
+			/* New capture format...  */
 			fmt2->fmt.pix.width = mm->width;
 			fmt2->fmt.pix.height = mm->height;
 			fmt2->fmt.pix.pixelformat =
@@ -937,7 +935,7 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 			fmt2->fmt.pix.bytesperline = 0;
 			err = drv(inode, file, VIDIOC_S_FMT, fmt2);
 			if (err < 0) {
-				dprintk("VIDIOCMCAPTURE / VIDIOC_S_FMT: %d\n",err);
+				dprintk("VIDIOCMCAPTURE / VIDIOC_S_FMT: %d\n", err);
 				break;
 			}
 		}
@@ -945,30 +943,30 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		buf2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		err = drv(inode, file, VIDIOC_QUERYBUF, &buf2);
 		if (err < 0) {
-			dprintk("VIDIOCMCAPTURE / VIDIOC_QUERYBUF: %d\n",err);
+			dprintk("VIDIOCMCAPTURE / VIDIOC_QUERYBUF: %d\n", err);
 			break;
 		}
 		err = drv(inode, file, VIDIOC_QBUF, &buf2);
 		if (err < 0) {
-			dprintk("VIDIOCMCAPTURE / VIDIOC_QBUF: %d\n",err);
+			dprintk("VIDIOCMCAPTURE / VIDIOC_QBUF: %d\n", err);
 			break;
 		}
 		err = drv(inode, file, VIDIOC_STREAMON, &captype);
 		if (err < 0)
-			dprintk("VIDIOCMCAPTURE / VIDIOC_STREAMON: %d\n",err);
+			dprintk("VIDIOCMCAPTURE / VIDIOC_STREAMON: %d\n", err);
 		break;
 	}
 	case VIDIOCSYNC: /*  wait for a frame  */
 	{
 		int			*i = arg;
 
-		memset(&buf2,0,sizeof(buf2));
+		memset(&buf2, 0, sizeof(buf2));
 		buf2.index = *i;
 		buf2.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		err = drv(inode, file, VIDIOC_QUERYBUF, &buf2);
 		if (err < 0) {
 			/*  No such buffer */
-			dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n",err);
+			dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n", err);
 			break;
 		}
 		if (!(buf2.flags & V4L2_BUF_FLAG_MAPPED)) {
@@ -980,29 +978,28 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 		/* make sure capture actually runs so we don't block forever */
 		err = drv(inode, file, VIDIOC_STREAMON, &captype);
 		if (err < 0) {
-			dprintk("VIDIOCSYNC / VIDIOC_STREAMON: %d\n",err);
+			dprintk("VIDIOCSYNC / VIDIOC_STREAMON: %d\n", err);
 			break;
 		}
 
 		/*  Loop as long as the buffer is queued, but not done  */
 		while ((buf2.flags &
 			(V4L2_BUF_FLAG_QUEUED | V4L2_BUF_FLAG_DONE))
-		       == V4L2_BUF_FLAG_QUEUED)
-		{
+		       == V4L2_BUF_FLAG_QUEUED) {
 			err = poll_one(file);
 			if (err < 0 ||	/* error or sleep was interrupted  */
 			    err == 0)	/* timeout? Shouldn't occur.  */
 				break;
 			err = drv(inode, file, VIDIOC_QUERYBUF, &buf2);
 			if (err < 0)
-				dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n",err);
+				dprintk("VIDIOCSYNC / VIDIOC_QUERYBUF: %d\n", err);
 		}
 		if (!(buf2.flags & V4L2_BUF_FLAG_DONE)) /* not done */
 			break;
 		do {
 			err = drv(inode, file, VIDIOC_DQBUF, &buf2);
 			if (err < 0)
-				dprintk("VIDIOCSYNC / VIDIOC_DQBUF: %d\n",err);
+				dprintk("VIDIOCSYNC / VIDIOC_DQBUF: %d\n", err);
 		} while (err == 0 && buf2.index != *i);
 		break;
 	}
@@ -1093,7 +1090,6 @@ v4l_compat_translate_ioctl(struct inode         *inode,
 	kfree(fmt2);
 	return err;
 }
-
 EXPORT_SYMBOL(v4l_compat_translate_ioctl);
 
 /*
-- 
1.5.3.7

