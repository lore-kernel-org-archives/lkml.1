Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbZAPH0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbZAPH0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbZAPH0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:26:04 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:54460 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbZAPH0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=xxT6TvPgUKhwlhJ6+eCe0Tae1+ns4okpcEZxW1je8NcFzhkqwU2sUmmg4BLjFGlp4k
         UnkKiIhr6UKPp7a54AafW7mLOc8XVjO1jH9tzK+8J17tymSdkHAdPuuWWP6xISLlHxfp
         cvdXxXZ/xab0CwtA/F2aJcTuUbRxafhnKfhg8=
Message-ID: <49703687.044e6e0a.04fa.257b@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: simplify iteration codes
Date: Fri, 16 Jan 2009 15:25:54 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merge list_for_each and list_entry to list_for_each_entry.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b187b53..70f0248 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -104,10 +104,8 @@ static noinline struct btrfs_device *__find_device(struct list_head *head,
 						   u64 devid, u8 *uuid)
 {
 	struct btrfs_device *dev;
-	struct list_head *cur;
 
-	list_for_each(cur, head) {
-		dev = list_entry(cur, struct btrfs_device, dev_list);
+	list_for_each_entry(dev, head, dev_list) {
 		if (dev->devid == devid &&
 		    (!uuid || !memcmp(dev->uuid, uuid, BTRFS_UUID_SIZE))) {
 			return dev;
@@ -118,11 +116,9 @@ static noinline struct btrfs_device *__find_device(struct list_head *head,
 
 static noinline struct btrfs_fs_devices *find_fsid(u8 *fsid)
 {
-	struct list_head *cur;
 	struct btrfs_fs_devices *fs_devices;
 
-	list_for_each(cur, &fs_uuids) {
-		fs_devices = list_entry(cur, struct btrfs_fs_devices, list);
+	list_for_each_entry(fs_devices, &fs_uuids, list) {
 		if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) == 0)
 			return fs_devices;
 	}

