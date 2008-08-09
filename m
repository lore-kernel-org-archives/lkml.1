Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYHIHOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYHIHOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 03:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYHIHOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 03:14:07 -0400
Received: from server78.greatnet.de ([83.133.96.102]:39451 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYHIHOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 03:14:06 -0400
X-Greylist: delayed 1172 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Aug 2008 03:14:06 EDT
Message-ID: <489D3F20.6000203@nachtwindheim.de>
Date: Sat, 09 Aug 2008 08:54:24 +0200
From: Henne <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: mchehab@infradead.org
CC: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] V4L: fix return value of register video func
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

If a wrong device type is used with video_register_device_index() it should
better return an error number, instead of a constant.

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 6f36006..0320fb8 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -281,7 +281,7 @@ int video_register_device_index(struct video_device *vfd, int type, int nr,
 	default:
 		printk(KERN_ERR "%s called with unknown type: %d\n",
 		       __func__, type);
-		return -1;
+		return -EINVAL;
 	}
 
 	/* pick a minor number */


