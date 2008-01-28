Return-Path: <linux-kernel-owner+w=401wt.eu-S1762869AbYA1WNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762869AbYA1WNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760185AbYA1WK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:10:29 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46435 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677AbYA1WK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:10:27 -0500
Date: Tue, 29 Jan 2008 00:10:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ian Armstrong <ian@iarmst.demon.co.uk>, Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: ivtv-devel@ivtvdriver.org, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org
Subject: [2.6 patch] ivtv-yuv.c: make 3 functions static
Message-ID: <20080128221053.GS8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- ivtv_yuv_next_free()
- ivtv_yuv_setup_frame()
- ivtv_yuv_udma_frame()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/ivtv/ivtv-yuv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

d73b9df5534f05010ef1c46db1ed2fe28874cfc1 
diff --git a/drivers/media/video/ivtv/ivtv-yuv.c b/drivers/media/video/ivtv/ivtv-yuv.c
index 8518348..8fdd67c 100644
--- a/drivers/media/video/ivtv/ivtv-yuv.c
+++ b/drivers/media/video/ivtv/ivtv-yuv.c
@@ -914,7 +914,7 @@ static void ivtv_yuv_init(struct ivtv *itv)
 }
 
 /* Get next available yuv buffer on PVR350 */
-void ivtv_yuv_next_free(struct ivtv *itv)
+static void ivtv_yuv_next_free(struct ivtv *itv)
 {
 	int draw, display;
 	struct yuv_playback_info *yi = &itv->yuv_info;
@@ -937,7 +937,7 @@ void ivtv_yuv_next_free(struct ivtv *itv)
 }
 
 /* Set up frame according to ivtv_dma_frame parameters */
-void ivtv_yuv_setup_frame(struct ivtv *itv, struct ivtv_dma_frame *args)
+static void ivtv_yuv_setup_frame(struct ivtv *itv, struct ivtv_dma_frame *args)
 {
 	struct yuv_playback_info *yi = &itv->yuv_info;
 	u8 frame = yi->draw_frame;
@@ -1042,7 +1042,7 @@ void ivtv_yuv_frame_complete(struct ivtv *itv)
 			(itv->yuv_info.draw_frame + 1) % IVTV_YUV_BUFFERS);
 }
 
-int ivtv_yuv_udma_frame(struct ivtv *itv, struct ivtv_dma_frame *args)
+static int ivtv_yuv_udma_frame(struct ivtv *itv, struct ivtv_dma_frame *args)
 {
 	DEFINE_WAIT(wait);
 	int rc = 0;

