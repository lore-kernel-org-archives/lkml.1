Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZEDUFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZEDUFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZEDUFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:05:06 -0400
Received: from kroah.org ([198.145.64.141]:56005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbZEDUFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:05:04 -0400
Date: Mon, 4 May 2009 12:58:01 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: Paul Mackerras <paulus@samba.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Roel Kluin <roel.kluin@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] hvcs: remove driver_data direct access of struct device
Message-ID: <20090504195801.GA22677@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/hvcs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -347,7 +347,7 @@ static void __exit hvcs_module_exit(void
 
 static inline struct hvcs_struct *from_vio_dev(struct vio_dev *viod)
 {
-	return viod->dev.driver_data;
+	return dev_get_drvdata(&viod->dev);
 }
 /* The sysfs interface for the driver and devices */
 
@@ -785,7 +785,7 @@ static int __devinit hvcs_probe(
 	kref_init(&hvcsd->kref);
 
 	hvcsd->vdev = dev;
-	dev->dev.driver_data = hvcsd;
+	dev_set_drvdata(&dev->dev, hvcsd);
 
 	hvcsd->index = index;
 
@@ -831,7 +831,7 @@ static int __devinit hvcs_probe(
 
 static int __devexit hvcs_remove(struct vio_dev *dev)
 {
-	struct hvcs_struct *hvcsd = dev->dev.driver_data;
+	struct hvcs_struct *hvcsd = dev_get_drvdata(&dev->dev);
 	unsigned long flags;
 	struct tty_struct *tty;
 
