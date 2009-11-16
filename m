Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbZKPESn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbZKPESn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZKPESl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:18:41 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:64232 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZKPESj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:18:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CtAmQPRXGswszEtGcmLULCqFAajYPdA8e9ZmkcbeY9aumxki3lXH0TzxGy5+OBNKO0
         7ZrBlTRf5g2fReQNO7ePGfW48d+DFySA+g/yitSJfRvG6lWTW/9E7XpQxBx4oCTYEi+p
         Qxc2B5XmbyiHPLYtE2FNEuyKD0HWpqXvn9jRc=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 03/13] staging: line6: Lindent and fix checkpatch warnings in capture.c
Date: Sun, 15 Nov 2009 22:17:52 -0600
Message-Id: <1258345082-11811-4-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/capture.c |   95 ++++++++++++++++++++++++++-------------
 1 files changed, 63 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/line6/capture.c b/drivers/staging/line6/capture.c
index ea2060b..7009f39 100644
--- a/drivers/staging/line6/capture.c
+++ b/drivers/staging/line6/capture.c
@@ -20,7 +20,6 @@
 #include "pod.h"
 #include "capture.h"
 
-
 /*
 	Find a free URB and submit it.
 */
@@ -33,7 +32,8 @@ static int submit_audio_in_urb(struct snd_pcm_substream *substream)
 	struct urb *urb_in;
 
 	spin_lock_irqsave(&line6pcm->lock_audio_in, flags);
-	index = find_first_zero_bit(&line6pcm->active_urb_in, LINE6_ISO_BUFFERS);
+	index =
+	    find_first_zero_bit(&line6pcm->active_urb_in, LINE6_ISO_BUFFERS);
 
 	if (index >= LINE6_ISO_BUFFERS) {
 		spin_unlock_irqrestore(&line6pcm->lock_audio_in, flags);
@@ -45,20 +45,24 @@ static int submit_audio_in_urb(struct snd_pcm_substream *substream)
 	urb_size = 0;
 
 	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
-		struct usb_iso_packet_descriptor *fin = &urb_in->iso_frame_desc[i];
+		struct usb_iso_packet_descriptor *fin =
+		    &urb_in->iso_frame_desc[i];
 		fin->offset = urb_size;
 		fin->length = line6pcm->max_packet_size;
 		urb_size += line6pcm->max_packet_size;
 	}
 
-	urb_in->transfer_buffer = line6pcm->buffer_in + index * LINE6_ISO_PACKETS * line6pcm->max_packet_size;
+	urb_in->transfer_buffer =
+	    line6pcm->buffer_in +
+	    index * LINE6_ISO_PACKETS * line6pcm->max_packet_size;
 	urb_in->transfer_buffer_length = urb_size;
 	urb_in->context = substream;
 
 	if (usb_submit_urb(urb_in, GFP_ATOMIC) == 0)
 		set_bit(index, &line6pcm->active_urb_in);
 	else
-		dev_err(s2m(substream), "URB in #%d submission failed\n", index);
+		dev_err(s2m(substream), "URB in #%d submission failed\n",
+			index);
 
 	spin_unlock_irqrestore(&line6pcm->lock_audio_in, flags);
 	return 0;
@@ -143,7 +147,8 @@ static void audio_in_callback(struct urb *urb)
 	int frames;
 	unsigned long flags;
 
-	struct snd_pcm_substream *substream = (struct snd_pcm_substream *)urb->context;
+	struct snd_pcm_substream *substream =
+	    (struct snd_pcm_substream *)urb->context;
 	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
 	const int bytes_per_frame = line6pcm->properties->bytes_per_frame;
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -155,8 +160,11 @@ static void audio_in_callback(struct urb *urb)
 
 #if DO_DUMP_PCM_RECEIVE
 	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
-		struct usb_iso_packet_descriptor *fout = &urb->iso_frame_desc[i];
-		line6_write_hexdump(line6pcm->line6, 'C', urb->transfer_buffer + fout->offset, fout->length);
+		struct usb_iso_packet_descriptor *fout =
+		    &urb->iso_frame_desc[i];
+		line6_write_hexdump(line6pcm->line6, 'C',
+				    urb->transfer_buffer + fout->offset,
+				    fout->length);
 	}
 #endif
 
@@ -179,25 +187,40 @@ static void audio_in_callback(struct urb *urb)
 		if (fsize > 0) {
 			frames = fsize / bytes_per_frame;
 
-			if (line6pcm->pos_in_done + frames > runtime->buffer_size) {
+			if (line6pcm->pos_in_done + frames >
+			    runtime->buffer_size) {
 				/*
-					The transferred area goes over buffer boundary,
-					copy two separate chunks.
-				*/
+				   The transferred area goes over buffer
+				   boundary, copy two separate chunks.
+				 */
 				int len;
-				len = runtime->buffer_size - line6pcm->pos_in_done;
+				len =
+				    runtime->buffer_size -
+				    line6pcm->pos_in_done;
 
 				if (len > 0) {
-					memcpy(runtime->dma_area + line6pcm->pos_in_done * bytes_per_frame, fbuf, len * bytes_per_frame);
-					memcpy(runtime->dma_area, fbuf + len * bytes_per_frame, (frames - len) * bytes_per_frame);
-				} else
-					dev_err(s2m(substream), "driver bug: len = %d\n", len);  /* this is somewhat paranoid */
+					memcpy(runtime->dma_area +
+					       line6pcm->pos_in_done *
+					       bytes_per_frame, fbuf,
+					       len * bytes_per_frame);
+					memcpy(runtime->dma_area,
+					       fbuf + len * bytes_per_frame,
+					       (frames -
+						len) * bytes_per_frame);
+				} else {
+					/* this is somewhat paranoid */
+					dev_err(s2m(substream),
+						"driver bug: len = %d\n", len);
+				}
 			} else {
 				/* copy single chunk */
-				memcpy(runtime->dma_area + line6pcm->pos_in_done * bytes_per_frame, fbuf, fsize * bytes_per_frame);
+				memcpy(runtime->dma_area +
+				       line6pcm->pos_in_done * bytes_per_frame,
+				       fbuf, fsize * bytes_per_frame);
 			}
 
-			if ((line6pcm->pos_in_done += frames) >= runtime->buffer_size)
+			if ((line6pcm->pos_in_done +=
+			     frames) >= runtime->buffer_size)
 				line6pcm->pos_in_done -= runtime->buffer_size;
 		}
 	}
@@ -228,7 +251,8 @@ static int snd_line6_capture_open(struct snd_pcm_substream *substream)
 
 	err = snd_pcm_hw_constraint_ratdens(runtime, 0,
 					    SNDRV_PCM_HW_PARAM_RATE,
-					    (&line6pcm->properties->snd_line6_rates));
+					    (&line6pcm->properties->
+					     snd_line6_rates));
 	if (err < 0)
 		return err;
 
@@ -267,7 +291,9 @@ static int snd_line6_capture_hw_params(struct snd_pcm_substream *substream,
 		return ret;
 
 	line6pcm->period_in = params_period_bytes(hw_params);
-	line6pcm->buffer_in = kmalloc(LINE6_ISO_BUFFERS * LINE6_ISO_PACKETS * LINE6_ISO_PACKET_SIZE_MAX, GFP_KERNEL);
+	line6pcm->buffer_in =
+	    kmalloc(LINE6_ISO_BUFFERS * LINE6_ISO_PACKETS *
+		    LINE6_ISO_PACKET_SIZE_MAX, GFP_KERNEL);
 
 	if (!line6pcm->buffer_in) {
 		dev_err(s2m(substream), "cannot malloc buffer_in\n");
@@ -302,7 +328,8 @@ int snd_line6_capture_trigger(struct snd_pcm_substream *substream, int cmd)
 			err = submit_audio_in_all_urbs(substream);
 
 			if (err < 0) {
-				clear_bit(BIT_RUNNING_CAPTURE, &line6pcm->flags);
+				clear_bit(BIT_RUNNING_CAPTURE,
+					  &line6pcm->flags);
 				return err;
 			}
 		}
@@ -332,14 +359,14 @@ snd_line6_capture_pointer(struct snd_pcm_substream *substream)
 
 /* capture operators */
 struct snd_pcm_ops snd_line6_capture_ops = {
-	.open =        snd_line6_capture_open,
-	.close =       snd_line6_capture_close,
-	.ioctl =       snd_pcm_lib_ioctl,
-	.hw_params =   snd_line6_capture_hw_params,
-	.hw_free =     snd_line6_capture_hw_free,
-	.prepare =     snd_line6_prepare,
-	.trigger =     snd_line6_trigger,
-	.pointer =     snd_line6_capture_pointer,
+	.open = snd_line6_capture_open,
+	.close = snd_line6_capture_close,
+	.ioctl = snd_pcm_lib_ioctl,
+	.hw_params = snd_line6_capture_hw_params,
+	.hw_free = snd_line6_capture_hw_free,
+	.prepare = snd_line6_prepare,
+	.trigger = snd_line6_trigger,
+	.pointer = snd_line6_capture_pointer,
 };
 
 int create_audio_in_urbs(struct snd_line6_pcm *line6pcm)
@@ -351,7 +378,8 @@ int create_audio_in_urbs(struct snd_line6_pcm *line6pcm)
 		struct urb *urb;
 
 		/* URB for audio in: */
-		urb = line6pcm->urb_audio_in[i] = usb_alloc_urb(LINE6_ISO_PACKETS, GFP_KERNEL);
+		urb = line6pcm->urb_audio_in[i] =
+		    usb_alloc_urb(LINE6_ISO_PACKETS, GFP_KERNEL);
 
 		if (urb == NULL) {
 			dev_err(line6pcm->line6->ifcdev, "Out of memory\n");
@@ -359,7 +387,10 @@ int create_audio_in_urbs(struct snd_line6_pcm *line6pcm)
 		}
 
 		urb->dev = line6pcm->line6->usbdev;
-		urb->pipe = usb_rcvisocpipe(line6pcm->line6->usbdev, line6pcm->ep_audio_read & USB_ENDPOINT_NUMBER_MASK);
+		urb->pipe =
+		    usb_rcvisocpipe(line6pcm->line6->usbdev,
+				    line6pcm->
+				    ep_audio_read & USB_ENDPOINT_NUMBER_MASK);
 		urb->transfer_flags = URB_ISO_ASAP;
 		urb->start_frame = -1;
 		urb->number_of_packets = LINE6_ISO_PACKETS;
-- 
1.6.5

