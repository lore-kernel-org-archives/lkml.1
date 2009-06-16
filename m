Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbZFPGAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbZFPGAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935859AbZFPFvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:31 -0400
Received: from kroah.org ([198.145.64.141]:48418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935840AbZFPFv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: [PATCH 42/64] input: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:31 -0700
Message-Id: <1245131213-24168-42-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/touchscreen/wm97xx-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index 69af838..2957d48 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -569,7 +569,7 @@ static int wm97xx_probe(struct device *dev)
 	mutex_init(&wm->codec_mutex);
 
 	wm->dev = dev;
-	dev->driver_data = wm;
+	dev_set_drvdata(dev, wm);
 	wm->ac97 = to_ac97_t(dev);
 
 	/* check that we have a supported codec */
-- 
1.6.3.2

