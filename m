Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbXLBRrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbXLBRrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 12:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXLBRrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 12:47:12 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:50704 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbXLBRrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 12:47:11 -0500
Date: Sun, 2 Dec 2007 18:47:01 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: hverkuil@xs4all.nl, mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071202173335.15374.10234.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071202173329.15374.4223.sendpatchset@thinktank.campus.ltu.se>
References: <20071202173329.15374.4223.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH 2/2] ivtv: Remove a invalid shadow-variable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the shadowing 'struct v4l2_chip_ident *chip', since it already exists
and makes the if-statement useless.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested on i386 with "allyesconfig" and "allmodconfig".


diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index fd6826f..874aa22 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -660,11 +660,8 @@ static int ivtv_debug_ioctls(struct file *filp, unsigned int cmd, void *arg)
 		chip->ident = V4L2_IDENT_NONE;
 		chip->revision = 0;
 		if (reg->match_type == V4L2_CHIP_MATCH_HOST) {
-			if (v4l2_chip_match_host(reg->match_type, reg->match_chip)) {
-				struct v4l2_chip_ident *chip = arg;
-
+			if (v4l2_chip_match_host(reg->match_type, reg->match_chip))
 				chip->ident = itv->has_cx23415 ? V4L2_IDENT_CX23415 : V4L2_IDENT_CX23416;
-			}
 			return 0;
 		}
 		if (reg->match_type == V4L2_CHIP_MATCH_I2C_DRIVER)
