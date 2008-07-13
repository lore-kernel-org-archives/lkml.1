Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbYGMScp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbYGMScp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 14:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYGMSci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 14:32:38 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:48205 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYGMSch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 14:32:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=gWL2s91Tw8+yOhA3CO8r2Gm6iL5twtz/aJTIW3feFE/7fkr+rJe3Lbtq0FQDIQg0Y54Eo1egyVQ/uDSI/sA+CcM27Fu+x+x5BoufX8kXxVtdva+djlaiP8EMUVpVcE2D;
Message-ID: <487A4A3D.9040809@simon.arlott.org.uk>
Date: Sun, 13 Jul 2008 19:32:29 +0100
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cde790c56ffe76f3d0bf6f38d89f4e671a5218c6 Mon Sep 17 00:00:00 2001
From: Simon Arlott <simon@redrum.invalid>
Date: Sun, 13 Jul 2008 19:24:53 +0100
Subject: [PATCH] V4L: Link tuner before saa7134

If saa7134_init is run before v4l2_i2c_drv_init (tuner),
then saa7134_board_init2 will try to set the tuner type
for devices that don't exist yet. This moves tuner to
before all of the device-specific drivers so that it's
loaded early enough on boot.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
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
