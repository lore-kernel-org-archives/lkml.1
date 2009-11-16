Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbZKPESh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbZKPESh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZKPESg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:18:36 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:52096 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZKPESd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:18:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lamoHBNllDPC9R9oqiUaIdVdK8upjIPDONcQ16UdQJ4dvgnMjqRl1nqwVsDw1qxdpU
         dHEmnVEFgKYjlvkRGVIheYYaAinrAulrInmRGZnmhBjEq4xi1q6hvNa55mh+ek8FECNQ
         Sdh6PcSp3RezmWOGgWD+c3YHS5nNzqMoU2F1g=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 01/13] staging: line6: Lindent and fix checkpatch warnings in playback.c
Date: Sun, 15 Nov 2009 22:17:50 -0600
Message-Id: <1258345082-11811-2-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/playback.c |   95 ++++++++++++++++++++++++-------------
 1 files changed, 61 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/line6/playback.c b/drivers/staging/line6/playback.c
index acb0612..4192cd9 100644
--- a/drivers/staging/line6/playback.c
+++ b/drivers/staging/line6/playback.c
@@ -20,7 +20,6 @@
 #include "pod.h"
 #include "playback.h"
 
-
 /*
 	Software stereo volume control.
 */
@@ -30,7 +29,7 @@ static void change_volume(struct urb *urb_out, int volume[],
 	int chn = 0;
 
 	if (volume[0] == 256 && volume[1] == 256)
-		return;  /* maximum volume - no change */
+		return;		/* maximum volume - no change */
 
 	if (bytes_per_frame == 4) {
 		short *p, *buf_end;
@@ -68,13 +67,17 @@ static int submit_audio_out_urb(struct snd_pcm_substream *substream)
 	int i, urb_size, urb_frames;
 	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
 	const int bytes_per_frame = line6pcm->properties->bytes_per_frame;
-	const int frame_increment = line6pcm->properties->snd_line6_rates.rats[0].num_min;
-	const int frame_factor = line6pcm->properties->snd_line6_rates.rats[0].den * (USB_INTERVALS_PER_SECOND / LINE6_ISO_INTERVAL);
+	const int frame_increment =
+	    line6pcm->properties->snd_line6_rates.rats[0].num_min;
+	const int frame_factor =
+	    line6pcm->properties->snd_line6_rates.rats[0].den *
+	    (USB_INTERVALS_PER_SECOND / LINE6_ISO_INTERVAL);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct urb *urb_out;
 
 	spin_lock_irqsave(&line6pcm->lock_audio_out, flags);
-	index = find_first_zero_bit(&line6pcm->active_urb_out, LINE6_ISO_BUFFERS);
+	index =
+	    find_first_zero_bit(&line6pcm->active_urb_out, LINE6_ISO_BUFFERS);
 
 	if (index < 0 || index >= LINE6_ISO_BUFFERS) {
 		spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
@@ -88,7 +91,8 @@ static int submit_audio_out_urb(struct snd_pcm_substream *substream)
 	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
 		/* compute frame size for given sampling rate */
 		int n, fs;
-		struct usb_iso_packet_descriptor *fout = &urb_out->iso_frame_desc[i];
+		struct usb_iso_packet_descriptor *fout =
+		    &urb_out->iso_frame_desc[i];
 		line6pcm->count_out += frame_increment;
 		n = line6pcm->count_out / frame_factor;
 		line6pcm->count_out -= n * frame_factor;
@@ -106,21 +110,31 @@ static int submit_audio_out_urb(struct snd_pcm_substream *substream)
 	} else {
 		if (line6pcm->pos_out + urb_frames > runtime->buffer_size) {
 			/*
-				The transferred area goes over buffer boundary,
-				copy the data to the temp buffer.
-			*/
+			   The transferred area goes over buffer boundary,
+			   copy the data to the temp buffer.
+			 */
 			int len;
 			len = runtime->buffer_size - line6pcm->pos_out;
 			urb_out->transfer_buffer = line6pcm->wrap_out;
 
 			if (len > 0) {
-				memcpy(line6pcm->wrap_out, runtime->dma_area + line6pcm->pos_out * bytes_per_frame, len * bytes_per_frame);
-				memcpy(line6pcm->wrap_out + len * bytes_per_frame, runtime->dma_area, (urb_frames - len) * bytes_per_frame);
-			} else
-				dev_err(s2m(substream), "driver bug: len = %d\n", len);  /* this is somewhat paranoid */
+				memcpy(line6pcm->wrap_out,
+				       runtime->dma_area +
+				       line6pcm->pos_out * bytes_per_frame,
+				       len * bytes_per_frame);
+				memcpy(line6pcm->wrap_out +
+				       len * bytes_per_frame, runtime->dma_area,
+				       (urb_frames - len) * bytes_per_frame);
+			} else {
+				/* this is somewhat paranoid */
+				dev_err(s2m(substream),
+					"driver bug: len = %d\n", len);
+			}
 		} else {
 			/* set the buffer pointer */
-			urb_out->transfer_buffer = runtime->dma_area + line6pcm->pos_out * bytes_per_frame;
+			urb_out->transfer_buffer =
+			    runtime->dma_area +
+			    line6pcm->pos_out * bytes_per_frame;
 		}
 	}
 
@@ -133,15 +147,19 @@ static int submit_audio_out_urb(struct snd_pcm_substream *substream)
 
 #if DO_DUMP_PCM_SEND
 	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
-		struct usb_iso_packet_descriptor *fout = &urb_out->iso_frame_desc[i];
-		line6_write_hexdump(line6pcm->line6, 'P', urb_out->transfer_buffer + fout->offset, fout->length);
+		struct usb_iso_packet_descriptor *fout =
+		    &urb_out->iso_frame_desc[i];
+		line6_write_hexdump(line6pcm->line6, 'P',
+				    urb_out->transfer_buffer + fout->offset,
+				    fout->length);
 	}
 #endif
 
 	if (usb_submit_urb(urb_out, GFP_ATOMIC) == 0)
 		set_bit(index, &line6pcm->active_urb_out);
 	else
-		dev_err(s2m(substream), "URB out #%d submission failed\n", index);
+		dev_err(s2m(substream), "URB out #%d submission failed\n",
+			index);
 
 	spin_unlock_irqrestore(&line6pcm->lock_audio_out, flags);
 	return 0;
@@ -181,7 +199,7 @@ static void unlink_audio_out_urbs(struct snd_line6_pcm *line6pcm)
 }
 
 /*
-	Wait until unlinking of all currently active playback URBs has been finished.
+   Wait until unlinking of all currently active playback URBs has been finished.
 */
 static void wait_clear_audio_out_urbs(struct snd_line6_pcm *line6pcm)
 {
@@ -224,7 +242,8 @@ static void audio_out_callback(struct urb *urb)
 	int i, index, length = 0, shutdown = 0;
 	unsigned long flags;
 
-	struct snd_pcm_substream *substream = (struct snd_pcm_substream *)urb->context;
+	struct snd_pcm_substream *substream =
+	    (struct snd_pcm_substream *)urb->context;
 	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
 
@@ -234,13 +253,14 @@ static void audio_out_callback(struct urb *urb)
 			break;
 
 	if (index < 0)
-		return;  /* URB has been unlinked asynchronously */
+		return;		/* URB has been unlinked asynchronously */
 
 	for (i = LINE6_ISO_PACKETS; i--;)
 		length += urb->iso_frame_desc[i].length;
 
 	spin_lock_irqsave(&line6pcm->lock_audio_out, flags);
-	line6pcm->pos_out_done += length / line6pcm->properties->bytes_per_frame;
+	line6pcm->pos_out_done +=
+	    length / line6pcm->properties->bytes_per_frame;
 
 	if (line6pcm->pos_out_done >= runtime->buffer_size)
 		line6pcm->pos_out_done -= runtime->buffer_size;
@@ -276,7 +296,8 @@ static int snd_line6_playback_open(struct snd_pcm_substream *substream)
 	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
 
 	err = snd_pcm_hw_constraint_ratdens(runtime, 0, SNDRV_PCM_HW_PARAM_RATE,
-					    (&line6pcm->properties->snd_line6_rates));
+					    (&line6pcm->properties->
+					     snd_line6_rates));
 	if (err < 0)
 		return err;
 
@@ -291,7 +312,8 @@ static int snd_line6_playback_close(struct snd_pcm_substream *substream)
 }
 
 /* hw_params playback callback */
-static int snd_line6_playback_hw_params(struct snd_pcm_substream *substream, struct snd_pcm_hw_params *hw_params)
+static int snd_line6_playback_hw_params(struct snd_pcm_substream *substream,
+					struct snd_pcm_hw_params *hw_params)
 {
 	int ret;
 	struct snd_line6_pcm *line6pcm = snd_pcm_substream_chip(substream);
@@ -349,7 +371,8 @@ int snd_line6_playback_trigger(struct snd_pcm_substream *substream, int cmd)
 			err = submit_audio_out_all_urbs(substream);
 
 			if (err < 0) {
-				clear_bit(BIT_RUNNING_PLAYBACK, &line6pcm->flags);
+				clear_bit(BIT_RUNNING_PLAYBACK,
+					  &line6pcm->flags);
 				return err;
 			}
 		}
@@ -387,14 +410,14 @@ snd_line6_playback_pointer(struct snd_pcm_substream *substream)
 
 /* playback operators */
 struct snd_pcm_ops snd_line6_playback_ops = {
-	.open =        snd_line6_playback_open,
-	.close =       snd_line6_playback_close,
-	.ioctl =       snd_pcm_lib_ioctl,
-	.hw_params =   snd_line6_playback_hw_params,
-	.hw_free =     snd_line6_playback_hw_free,
-	.prepare =     snd_line6_prepare,
-	.trigger =     snd_line6_trigger,
-	.pointer =     snd_line6_playback_pointer,
+	.open = snd_line6_playback_open,
+	.close = snd_line6_playback_close,
+	.ioctl = snd_pcm_lib_ioctl,
+	.hw_params = snd_line6_playback_hw_params,
+	.hw_free = snd_line6_playback_hw_free,
+	.prepare = snd_line6_prepare,
+	.trigger = snd_line6_trigger,
+	.pointer = snd_line6_playback_pointer,
 };
 
 int create_audio_out_urbs(struct snd_line6_pcm *line6pcm)
@@ -406,7 +429,8 @@ int create_audio_out_urbs(struct snd_line6_pcm *line6pcm)
 		struct urb *urb;
 
 		/* URB for audio out: */
-		urb = line6pcm->urb_audio_out[i] = usb_alloc_urb(LINE6_ISO_PACKETS, GFP_KERNEL);
+		urb = line6pcm->urb_audio_out[i] =
+		    usb_alloc_urb(LINE6_ISO_PACKETS, GFP_KERNEL);
 
 		if (urb == NULL) {
 			dev_err(line6pcm->line6->ifcdev, "Out of memory\n");
@@ -414,7 +438,10 @@ int create_audio_out_urbs(struct snd_line6_pcm *line6pcm)
 		}
 
 		urb->dev = line6pcm->line6->usbdev;
-		urb->pipe = usb_sndisocpipe(line6pcm->line6->usbdev, line6pcm->ep_audio_write & USB_ENDPOINT_NUMBER_MASK);
+		urb->pipe =
+		    usb_sndisocpipe(line6pcm->line6->usbdev,
+				    line6pcm->
+				    ep_audio_write & USB_ENDPOINT_NUMBER_MASK);
 		urb->transfer_flags = URB_ISO_ASAP;
 		urb->start_frame = -1;
 		urb->number_of_packets = LINE6_ISO_PACKETS;
-- 
1.6.5

