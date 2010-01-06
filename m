Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770Ab0AFLuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0AFLuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 06:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722Ab0AFLuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 06:50:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62262 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab0AFLuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 06:50:16 -0500
Message-ID: <4B447882.2090806@cn.fujitsu.com>
Date: Wed, 06 Jan 2010 19:48:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Yan Zheng <zheng.yan@oracle.com>, Julia Lawall <julia@diku.dk>,
       Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] btrfs: using btrfs_stack_device_id() get devid
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use btrfs_stack_device_id() to get dev_item->devid

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 198cff2..3b8b2b9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -592,7 +592,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			goto error_close;
 
 		disk_super = (struct btrfs_super_block *)bh->b_data;
-		devid = le64_to_cpu(disk_super->dev_item.devid);
+		devid = btrfs_stack_device_id(&disk_super->dev_item);
 		if (devid != device->devid)
 			goto error_brelse;
 
@@ -694,7 +694,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 		goto error_close;
 	}
 	disk_super = (struct btrfs_super_block *)bh->b_data;
-	devid = le64_to_cpu(disk_super->dev_item.devid);
+	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	transid = btrfs_super_generation(disk_super);
 	if (disk_super->label[0])
 		printk(KERN_INFO "device label %s ", disk_super->label);
@@ -1187,7 +1187,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 			goto error_close;
 		}
 		disk_super = (struct btrfs_super_block *)bh->b_data;
-		devid = le64_to_cpu(disk_super->dev_item.devid);
+		devid = btrfs_stack_device_id(&disk_super->dev_item);
 		dev_uuid = disk_super->dev_item.uuid;
 		device = btrfs_find_device(root, devid, dev_uuid,
 					   disk_super->fsid);
-- 
1.6.1.2

