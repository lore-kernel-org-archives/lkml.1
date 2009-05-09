Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZEIOpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZEIOpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZEIOnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:43:00 -0400
Received: from kroah.org ([198.145.64.141]:54186 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbZEIOm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:42:59 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:34 2009
Message-Id: <20090509143634.418705561@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:09 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 08/13] Driver Core: sound: add nodename for sound drivers
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-sound-add-nodename-for-sound-drivers.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the sound core to report the proper device name to
userspace for their devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/sound_core.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -27,6 +27,11 @@ MODULE_DESCRIPTION("Core sound module");
 MODULE_AUTHOR("Alan Cox");
 MODULE_LICENSE("GPL");
 
+static char *sound_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "snd/%s", dev_name(dev));
+}
+
 static int __init init_soundcore(void)
 {
 	int rc;
@@ -41,6 +46,8 @@ static int __init init_soundcore(void)
 		return PTR_ERR(sound_class);
 	}
 
+	sound_class->nodename = sound_nodename;
+
 	return 0;
 }
 


