Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbYBOC02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbYBOC02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 21:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758852AbYBOC0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 21:26:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53366 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758419AbYBOC0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 21:26:16 -0500
Message-ID: <47B4F7F1.1090002@cn.fujitsu.com>
Date: Fri, 15 Feb 2008 10:24:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: rdreier@cisco.com
CC: sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix return value in ib_device_register_sysfs()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set ret to -ENOMEM when kobject_create_and_add() returns NULL.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/infiniband/core/sysfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c864ef7..5a4b2e6 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -686,8 +686,10 @@ int ib_device_register_sysfs(struct ib_device *device)
 
 	device->ports_parent = kobject_create_and_add("ports",
 					kobject_get(&class_dev->kobj));
-	if (!device->ports_parent)
+	if (!device->ports_parent) {
+		ret = -ENOMEM;
 		goto err_put;
+	}
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
 		ret = add_port(device, 0);
-- 
1.5.4.rc3

