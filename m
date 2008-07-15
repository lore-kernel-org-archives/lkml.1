Return-Path: <linux-kernel-owner+w=401wt.eu-S1761553AbYGOVlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761553AbYGOVlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYGOVk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:40:56 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:52737 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYGOVk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:40:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=GHzu8VjPZp52mwEwxIGtpxTDbO7HO/axGK5uvHFi7mU60Fe/W9RkfnICU+kGNwQQ0uXvP/1kp4tKE4TFiZt7eEyv2sE9ECMciYgHNB/8+pCVqBr/HK71JUpqyI1any73;
Message-ID: <487D1964.7050607@simon.arlott.org.uk>
Date: Tue, 15 Jul 2008 22:40:52 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080706)
MIME-Version: 1.0
To: v4l-dvb-maintainer@linuxtv.org
CC: hermann pitton <hermann-pitton@arcor.de>,
       Linux DVB <linux-dvb@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] V4L: Link tuner before saa7134
References: <4878F314.6090608@simon.arlott.org.uk> <1215919227.2662.3.camel@pc10.localdom.local>
In-Reply-To: <1215919227.2662.3.camel@pc10.localdom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If saa7134_init is run before v4l2_i2c_drv_init (tuner),
then saa7134_board_init2 will try to set the tuner type
for devices that don't exist yet. This moves tuner to
before all of the device-specific drivers so that it's
loaded early enough on boot.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
Resend... I accidentally left the git-send-email headers in.

Mailman appears to be easily confused too: 
http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027205.html

 drivers/media/video/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ecbbfaa..6b0af12 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -18,6 +18,8 @@ ifeq ($(CONFIG_VIDEO_V4L1_COMPAT),y)
   obj-$(CONFIG_VIDEO_DEV) += v4l1-compat.o
 endif
 
+obj-$(CONFIG_VIDEO_TUNER) += tuner.o
+
 obj-$(CONFIG_VIDEO_BT848) += bt8xx/
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
@@ -84,8 +86,6 @@ obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
 obj-$(CONFIG_VIDEO_DPC) += dpc7146.o
 obj-$(CONFIG_TUNER_3036) += tuner-3036.o
 
-obj-$(CONFIG_VIDEO_TUNER) += tuner.o
-
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
 obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
-- 
1.5.6.2

-- 
Simon Arlott

