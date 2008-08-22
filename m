Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYHVTl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYHVTl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYHVTlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:41:20 -0400
Received: from server78.greatnet.de ([83.133.96.102]:40451 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYHVTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:41:20 -0400
Message-ID: <48AF164F.308@nachtwindheim.de>
Date: Fri, 22 Aug 2008 21:41:03 +0200
From: Henne <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: mchehab@infradead.org
CC: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] V4L: check inval in video_register_device_index()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

Better check the video_device pointer before using it.


diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 6f36006..ef153ff 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -257,6 +257,9 @@ int video_register_device_index(struct video_device *vfd, int type, int nr,
 	int ret;
 	char *name_base;
 
+	if (vfd == NULL)
+		return -EINVAL;
+
 	switch (type) {
 	case VFL_TYPE_GRABBER:
 		base = MINOR_VFL_TYPE_GRABBER_MIN;


