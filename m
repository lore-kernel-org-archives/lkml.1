Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZEIOog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZEIOog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZEIOm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:42:58 -0400
Received: from kroah.org ([198.145.64.141]:54180 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbZEIOm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:42:57 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:33 2009
Message-Id: <20090509143633.519775257@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:07 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 06/13] Driver Core: dvb: add nodename for dvb drivers
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-dvb-add-nodename-for-dvb-drivers.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
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
 1 file changed, 10 insertions(+)

--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -447,6 +447,15 @@ static int dvb_uevent(struct device *dev
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


