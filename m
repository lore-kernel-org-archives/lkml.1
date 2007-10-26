Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbXJ0Gcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbXJ0Gcy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 02:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXJ0Gce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 02:32:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:57192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbXJ0Gcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 02:32:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,336,1188802800"; 
   d="scan'208";a="306437326"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH] DCA: Convert struct class_device to struct device.
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: shannon.nelson@intel.com, greg@kroah.com, kay.sievers@vrfy.org,
       tonyj@suse.de, dan.j.williams@intel.com
Date: Fri, 26 Oct 2007 16:54:12 -0700
Message-ID: <20071026235411.5691.24867.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Thanks to Kay for keeping us honest.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dca/dca-sysfs.c |   15 +++++++--------
 include/linux/dca.h     |    2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/dca/dca-sysfs.c b/drivers/dca/dca-sysfs.c
index 24a263b..011328f 100644
--- a/drivers/dca/dca-sysfs.c
+++ b/drivers/dca/dca-sysfs.c
@@ -12,10 +12,10 @@ static spinlock_t dca_idr_lock;
 
 int dca_sysfs_add_req(struct dca_provider *dca, struct device *dev, int slot)
 {
-	struct class_device *cd;
+	struct device *cd;
 
-	cd = class_device_create(dca_class, dca->cd, MKDEV(0, slot + 1),
-				 dev, "requester%d", slot);
+	cd = device_create(dca_class, dca->cd, MKDEV(0, slot + 1),
+			   "requester%d", slot);
 	if (IS_ERR(cd))
 		return PTR_ERR(cd);
 	return 0;
@@ -23,12 +23,12 @@ int dca_sysfs_add_req(struct dca_provider *dca, struct device *dev, int slot)
 
 void dca_sysfs_remove_req(struct dca_provider *dca, int slot)
 {
-	class_device_destroy(dca_class, MKDEV(0, slot + 1));
+	device_destroy(dca_class, MKDEV(0, slot + 1));
 }
 
 int dca_sysfs_add_provider(struct dca_provider *dca, struct device *dev)
 {
-	struct class_device *cd;
+	struct device *cd;
 	int err = 0;
 
 idr_try_again:
@@ -46,8 +46,7 @@ idr_try_again:
 		return err;
 	}
 
-	cd = class_device_create(dca_class, NULL, MKDEV(0, 0),
-				 dev, "dca%d", dca->id);
+	cd = device_create(dca_class, dev, MKDEV(0, 0), "dca%d", dca->id);
 	if (IS_ERR(cd)) {
 		spin_lock(&dca_idr_lock);
 		idr_remove(&dca_idr, dca->id);
@@ -60,7 +59,7 @@ idr_try_again:
 
 void dca_sysfs_remove_provider(struct dca_provider *dca)
 {
-	class_device_unregister(dca->cd);
+	device_unregister(dca->cd);
 	dca->cd = NULL;
 	spin_lock(&dca_idr_lock);
 	idr_remove(&dca_idr, dca->id);
diff --git a/include/linux/dca.h b/include/linux/dca.h
index 83eaecc..af61cd1 100644
--- a/include/linux/dca.h
+++ b/include/linux/dca.h
@@ -11,7 +11,7 @@ void dca_unregister_notify(struct notifier_block *nb);
 
 struct dca_provider {
 	struct dca_ops		*ops;
-	struct class_device 	*cd;
+	struct device 		*cd;
 	int			 id;
 };
 
