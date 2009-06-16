Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZFPGD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZFPGD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935905AbZFPFvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:40 -0400
Received: from kroah.org ([198.145.64.141]:48453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935901AbZFPFvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Sean Hefty <sean.hefty@intel.com>,
       Roland Dreier <rolandd@cisco.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       general@lists.openfabrics.org, Christoph Raisch <raisch@de.ibm.com>
Subject: [PATCH 52/64] infiniband: ehca: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:41 -0700
Message-Id: <1245131213-24168-52-git-send-email-gregkh@suse.de>
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

Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: general@lists.openfabrics.org
Cc: Christoph Raisch <raisch@de.ibm.com>
Acked-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/infiniband/hw/ehca/ehca_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 85905ab..ce4e6ef 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -636,7 +636,7 @@ static ssize_t  ehca_show_##name(struct device *dev,                       \
 	struct hipz_query_hca *rblock;				           \
 	int data;                                                          \
 									   \
-	shca = dev->driver_data;					   \
+	shca = dev_get_drvdata(dev);					   \
 									   \
 	rblock = ehca_alloc_fw_ctrlblock(GFP_KERNEL);			   \
 	if (!rblock) {						           \
@@ -680,7 +680,7 @@ static ssize_t ehca_show_adapter_handle(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct ehca_shca *shca = dev->driver_data;
+	struct ehca_shca *shca = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%llx\n", shca->ipz_hca_handle.handle);
 
@@ -749,7 +749,7 @@ static int __devinit ehca_probe(struct of_device *dev,
 
 	shca->ofdev = dev;
 	shca->ipz_hca_handle.handle = *handle;
-	dev->dev.driver_data = shca;
+	dev_set_drvdata(&dev->dev, shca);
 
 	ret = ehca_sense_attributes(shca);
 	if (ret < 0) {
@@ -878,7 +878,7 @@ probe1:
 
 static int __devexit ehca_remove(struct of_device *dev)
 {
-	struct ehca_shca *shca = dev->dev.driver_data;
+	struct ehca_shca *shca = dev_get_drvdata(&dev->dev);
 	unsigned long flags;
 	int ret;
 
-- 
1.6.3.2

