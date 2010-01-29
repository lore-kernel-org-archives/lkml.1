Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689Ab0A2VqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab0A2VqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970Ab0A2Vp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:45:27 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:8344 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab0A2VpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:45:20 -0500
Subject: [PATCH 4/7] IB/uverbs: use stack variable 'base' in ib_uverbs_add_one
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 14:45:18 -0700
Message-ID: <20100129214518.17745.15314.stgit@bob.kio>
In-Reply-To: <20100129214039.17745.38679.stgit@bob.kio>
References: <20100129214039.17745.38679.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is not useful by itself, but sets us up for a future change
that allows us to support more than IB_UVERBS_MAX_DEVICES in a system.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/uverbs_main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index acae9ed..a5d441d 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -730,7 +730,7 @@ static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
 
 static void ib_uverbs_add_one(struct ib_device *device)
 {
-	int devnum;
+	int devnum, base;
 	struct ib_uverbs_device *uverbs_dev;
 
 	if (!device->alloc_ucontext)
@@ -750,6 +750,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 		goto err;
 	}
 	uverbs_dev->devnum = devnum;
+	base = devnum + IB_UVERBS_BASE_DEV;
 	set_bit(devnum, dev_map);
 	spin_unlock(&map_lock);
 
@@ -760,7 +761,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	uverbs_dev->cdev.owner = THIS_MODULE;
 	uverbs_dev->cdev.ops = device->mmap ? &uverbs_mmap_fops : &uverbs_fops;
 	kobject_set_name(&uverbs_dev->cdev.kobj, "uverbs%d", uverbs_dev->devnum);
-	if (cdev_add(&uverbs_dev->cdev, IB_UVERBS_BASE_DEV + devnum, 1))
+	if (cdev_add(&uverbs_dev->cdev, base, 1))
 		goto err_cdev;
 
 	uverbs_dev->dev = device_create(uverbs_class, device->dma_device,

