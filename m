Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbYC0Xv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbYC0Xv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYC0XvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:51:21 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59955 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYC0XvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:51:20 -0400
Message-ID: <47EC32E9.7060400@tiscali.nl>
Date: Fri, 28 Mar 2008 00:51:05 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org
CC: video4linux-list@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] video: Test cmd, not definition in decoder_command(),
 drivers/media/video/zoran_device.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/video_decoder.h:
34:#define DECODER_SET_NORM	_IOW('d', 3, int)
35:#define DECODER_SET_INPUT	_IOW('d', 4, int)

untested, please confirm it's right.
--
Test cmd value, not definition of DECODER_SET_INPUT

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/video/zoran_device.c b/drivers/media/video/zoran_device.c
index 68c7c50..adf3f41 100644
--- a/drivers/media/video/zoran_device.c
+++ b/drivers/media/video/zoran_device.c
@@ -1726,7 +1726,7 @@ decoder_command (struct zoran *zr,
 		return -EIO;
 
 	if (zr->card.type == LML33 &&
-	    (cmd == DECODER_SET_NORM || DECODER_SET_INPUT)) {
+	    (cmd == DECODER_SET_NORM || cmd == DECODER_SET_INPUT)) {
 		int res;
 
 		// Bt819 needs to reset its FIFO buffer using #FRST pin and



