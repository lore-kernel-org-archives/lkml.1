Return-Path: <linux-kernel-owner+w=401wt.eu-S937410AbZFPGII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937410AbZFPGII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936030AbZFPFwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:52:16 -0400
Received: from kroah.org ([198.145.64.141]:48412 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935874AbZFPFv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       Sean Hefty <sean.hefty@intel.com>
Subject: [PATCH 41/64] infiniband: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:30 -0700
Message-Id: <1245131213-24168-41-git-send-email-gregkh@suse.de>
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


Cc: general@lists.openfabrics.org
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/core/sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 5c04cfb..158a214 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -760,9 +760,9 @@ int ib_device_register_sysfs(struct ib_device *device)
 	int i;
 
 	class_dev->class      = &ib_class;
-	class_dev->driver_data = device;
 	class_dev->parent     = device->dma_device;
 	dev_set_name(class_dev, device->name);
+	dev_set_drvdata(class_dev, device);
 
 	INIT_LIST_HEAD(&device->port_list);
 
-- 
1.6.3.2

