Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYLJPCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYLJPCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 10:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYLJPCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 10:02:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:52341 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYLJPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 10:02:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=xPXXI/y88MGxz5XFBvpEyvSFndIjJkdqeSaudq+liaLvin3/4mk97rIRQAZ47PbKf7
         iDg97IAGIthfFoCNwiqeZYegWfDkfPF71FI95+syU35iBbRl6PRYyPMAvtJKct7JDunX
         dgF9SiLyQUp0pDnfgHkT4Zzi1EAqXQNojibhY=
Message-ID: <f6ca9fed0812100702o51ed6176i9147da3e055306b1@mail.gmail.com>
Date: Wed, 10 Dec 2008 16:02:36 +0100
From: drago01 <drago01@gmail.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: [PATCH] make usbaudio less noisy when CONFIG_SND_DEBUG_VERBOSE is not set
Cc: "Chuck Ebbert" <cebbert@redhat.com>, "Takashi Iwai" <tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This puts changes the usbaudio debug messages to be less noisy, when
CONFIG_SND_DEBUG_VERBOSE is not set.

Some distrubutions (ex: fedora) enable CONFIG_SND_DEBUG to get more debug
information from their users, but some messages can be triggered very
frequently and therefore flood the logs.

This patch fixes this by only print them when CONFIG_SND_DEBUG_VERBOSE is set.

Cc: Takashi Iwai <tiwai@suse.de>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index bbd70d5..6ddaa86 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -351,7 +351,7 @@ static int retire_capture_urb(struct
snd_usb_substream *subs,
     for (i = 0; i < urb->number_of_packets; i++) {
         cp = (unsigned char *)urb->transfer_buffer +
urb->iso_frame_desc[i].offset;
         if (urb->iso_frame_desc[i].status) {
-            snd_printd(KERN_ERR "frame %d active: %d\n", i,
urb->iso_frame_desc[i].status);
+            snd_printdd(KERN_ERR "frame %d active: %d\n", i,
urb->iso_frame_desc[i].status);
             // continue;
         }
         len = urb->iso_frame_desc[i].actual_length / stride;
@@ -1299,7 +1299,7 @@ static int init_usb_sample_rate(struct
usb_device *dev, int iface,
         if ((err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0), GET_CUR,
                        USB_TYPE_CLASS|USB_RECIP_ENDPOINT|USB_DIR_IN,
                        SAMPLING_FREQ_CONTROL << 8, ep, data, 3, 1000)) < 0) {
-            snd_printk(KERN_WARNING "%d:%d:%d: cannot get freq at ep 0x%x\n",
+            snd_printdd(KERN_WARNING "%d:%d:%d: cannot get freq at ep 0x%x\n",
                    dev->devnum, iface, fmt->altsetting, ep);
             return 0; /* some devices don't support reading */
         }
