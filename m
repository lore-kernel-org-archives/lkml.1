Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZFPGCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZFPGCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935868AbZFPFvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:39 -0400
Received: from kroah.org ([198.145.64.141]:48442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935908AbZFPFvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Paul Mackerras <paulus@samba.org>,
       Roel Kluin <roel.kluin@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 50/64] hvcs: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:39 -0700
Message-Id: <1245131213-24168-50-git-send-email-gregkh@suse.de>
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

Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/hvcs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hvcs.c b/drivers/char/hvcs.c
index c76bccf..7d64e42 100644
--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -347,7 +347,7 @@ static void __exit hvcs_module_exit(void);
 
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
 
-- 
1.6.3.2

