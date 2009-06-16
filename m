Return-Path: <linux-kernel-owner+w=401wt.eu-S937507AbZFPGIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937507AbZFPGIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935483AbZFPFwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:52:24 -0400
Received: from kroah.org ([198.145.64.141]:48382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934949AbZFPFvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/64] Driver Core: dvb: add nodename for dvb drivers
Date: Mon, 15 Jun 2009 22:46:19 -0700
Message-Id: <1245131213-24168-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the dvb core to report the proper device name to
userspace for their devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/dvb/dvb-core/dvbdev.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index a454ee8..479dd05 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -447,6 +447,15 @@ static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+static char *dvb_nodename(struct device *dev)
+{
+	struct dvb_device *dvbdev = dev_get_drvdata(dev);
+
+	return kasprintf(GFP_KERNEL, "dvb/adapter%d/%s%d",
+		dvbdev->adapter->num, dnames[dvbdev->type], dvbdev->id);
+}
+
+
 static int __init init_dvbdev(void)
 {
 	int retval;
@@ -469,6 +478,7 @@ static int __init init_dvbdev(void)
 		goto error;
 	}
 	dvb_class->dev_uevent = dvb_uevent;
+	dvb_class->nodename = dvb_nodename;
 	return 0;
 
 error:
-- 
1.6.3.2

