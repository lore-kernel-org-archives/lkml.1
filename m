Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYHVUNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYHVUNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYHVUNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:13:36 -0400
Received: from server78.greatnet.de ([83.133.96.102]:44007 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYHVUNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:13:36 -0400
Message-ID: <48AF1DD1.1080800@nachtwindheim.de>
Date: Fri, 22 Aug 2008 22:13:05 +0200
From: Henne <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: mchehab@infradead.org
CC: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] V4L: fix return value of meye probe callback
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

The return vaule of the probe function should return -ENOMEM instead
of -EBUSY if video_device_alloc() fails.

diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
index 7c8ef6a..225714b 100644
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -1774,6 +1774,7 @@ static int __devinit meye_probe(struct pci_dev *pcidev,
 		goto outnotdev;
 	}
 
+	ret = -ENOMEM;
 	meye.mchip_dev = pcidev;
 	meye.video_dev = video_device_alloc();
 	if (!meye.video_dev) {
@@ -1781,7 +1782,6 @@ static int __devinit meye_probe(struct pci_dev *pcidev,
 		goto outnotdev;
 	}
 
-	ret = -ENOMEM;
 	meye.grab_temp = vmalloc(MCHIP_NB_PAGES_MJPEG * PAGE_SIZE);
 	if (!meye.grab_temp) {
 		printk(KERN_ERR "meye: grab buffer allocation failed\n");


