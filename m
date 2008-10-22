Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYJVJI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYJVJI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYJVJIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:08:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58108 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYJVJIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:08:46 -0400
Message-ID: <48FEED4D.3000208@cn.fujitsu.com>
Date: Wed, 22 Oct 2008 17:07:25 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: [PATCH] Fix debugfs_create_*'s error checking method for wireless/rt2x00/
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

debugfs_create_*() returns NULL if an error occurs, returns -ENODEV
when debugfs is not enabled in the kernel.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 5cf4c85..b380cd3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -587,29 +587,29 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	intf->driver_folder =
 	    debugfs_create_dir(intf->rt2x00dev->ops->name,
 			       rt2x00dev->hw->wiphy->debugfsdir);
-	if (IS_ERR(intf->driver_folder))
+	if (IS_ERR(intf->driver_folder) || !intf->driver_folder)
 		goto exit;
 
 	intf->driver_entry =
 	    rt2x00debug_create_file_driver("driver", intf, &intf->driver_blob);
-	if (IS_ERR(intf->driver_entry))
+	if (IS_ERR(intf->driver_entry) || !intf->driver_entry)
 		goto exit;
 
 	intf->chipset_entry =
 	    rt2x00debug_create_file_chipset("chipset",
 					    intf, &intf->chipset_blob);
-	if (IS_ERR(intf->chipset_entry))
+	if (IS_ERR(intf->chipset_entry) || !intf->chipset_entry)
 		goto exit;
 
 	intf->dev_flags = debugfs_create_file("dev_flags", S_IRUSR,
 					      intf->driver_folder, intf,
 					      &rt2x00debug_fop_dev_flags);
-	if (IS_ERR(intf->dev_flags))
+	if (IS_ERR(intf->dev_flags) || !intf->dev_flags)
 		goto exit;
 
 	intf->register_folder =
 	    debugfs_create_dir("register", intf->driver_folder);
-	if (IS_ERR(intf->register_folder))
+	if (IS_ERR(intf->register_folder) || !intf->register_folder)
 		goto exit;
 
 #define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)	\
@@ -619,7 +619,8 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 			       S_IRUSR | S_IWUSR,		\
 			       (__intf)->register_folder,	\
 			       &(__intf)->offset_##__name);	\
-	if (IS_ERR((__intf)->__name##_off_entry))		\
+	if (IS_ERR((__intf)->__name##_off_entry)		\
+			|| !(__intf)->__name##_off_entry)	\
 		goto exit;					\
 								\
 	(__intf)->__name##_val_entry =				\
@@ -627,7 +628,8 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 				S_IRUSR | S_IWUSR,		\
 				(__intf)->register_folder,	\
 				(__intf), &rt2x00debug_fop_##__name);\
-	if (IS_ERR((__intf)->__name##_val_entry))		\
+	if (IS_ERR((__intf)->__name##_val_entry)		\
+			|| !(__intf)->__name##_val_entry)	\
 		goto exit;					\
 })
 
@@ -640,13 +642,14 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 
 	intf->queue_folder =
 	    debugfs_create_dir("queue", intf->driver_folder);
-	if (IS_ERR(intf->queue_folder))
+	if (IS_ERR(intf->queue_folder) || !intf->queue_folder)
 		goto exit;
 
 	intf->queue_frame_dump_entry =
 	    debugfs_create_file("dump", S_IRUSR, intf->queue_folder,
 				intf, &rt2x00debug_fop_queue_dump);
-	if (IS_ERR(intf->queue_frame_dump_entry))
+	if (IS_ERR(intf->queue_frame_dump_entry)
+		|| !intf->queue_frame_dump_entry)
 		goto exit;
 
 	skb_queue_head_init(&intf->frame_dump_skbqueue);
-- 1.5.5.3 



