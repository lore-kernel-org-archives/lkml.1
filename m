Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbYHVUQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbYHVUQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbYHVUQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:16:21 -0400
Received: from server78.greatnet.de ([83.133.96.102]:44072 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYHVUQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:16:20 -0400
Message-ID: <48AF1E83.4000102@nachtwindheim.de>
Date: Fri, 22 Aug 2008 22:16:03 +0200
From: Henne <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: mchehab@infradead.org
CC: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] V4L: fix retval in vivi driver for more than one device
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

The variable ret should be set for each device to -ENOMEM, not only the first.

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 3518af0..d739b59 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1106,11 +1106,12 @@ static struct video_device vivi_template = {
 
 static int __init vivi_init(void)
 {
-	int ret = -ENOMEM, i;
+	int ret, i;
 	struct vivi_dev *dev;
 	struct video_device *vfd;
 
 	for (i = 0; i < n_devs; i++) {
+		ret = -ENOMEM;
 		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 		if (NULL == dev)
 			break;


