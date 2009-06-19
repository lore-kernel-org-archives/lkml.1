Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZFSUac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZFSUac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZFSUaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:30:18 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:40503 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZFSUaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:30:17 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/4] V4L: em28xx, fix lock imbalance
Date: Fri, 19 Jun 2009 22:30:05 +0200
Message-Id: <1245443407-17410-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245443407-17410-1-git-send-email-jirislaby@gmail.com>
References: <1245443407-17410-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one omitted unlock in em28xx_usb_probe. Fix that.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 36abb35..922d21d 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2445,6 +2445,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	retval = em28xx_init_dev(&dev, udev, interface, nr);
 	if (retval) {
 		em28xx_devused &= ~(1<<dev->devno);
+		mutex_unlock(&dev->lock);
 		kfree(dev);
 		goto err;
 	}
-- 
1.6.3.2

