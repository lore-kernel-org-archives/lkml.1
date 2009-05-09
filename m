Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZEIOox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZEIOox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZEIOm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:42:59 -0400
Received: from kroah.org ([198.145.64.141]:54184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbZEIOm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:42:58 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:34 2009
Message-Id: <20090509143633.947539604@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:08 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 07/13] Driver Core: input: add nodename for input drivers
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-input-add-nodename-for-input-drivers.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the input core to report the proper device name to
userspace for their devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/input.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1264,8 +1264,14 @@ static struct device_type input_dev_type
 	.uevent		= input_dev_uevent,
 };
 
+static char *input_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "input/%s", dev_name(dev));
+}
+
 struct class input_class = {
 	.name		= "input",
+	.nodename	= input_nodename,
 };
 EXPORT_SYMBOL_GPL(input_class);
 


