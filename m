Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYADF5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYADF5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYADF5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:57:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57267 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbYADF5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:57:10 -0500
Message-ID: <477DC9B6.8050108@cn.fujitsu.com>
Date: Fri, 04 Jan 2008 13:52:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] CONNECTOR: cleanup struct cn_queue_dev
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Struct member netlink_groups is never used, and I don't see how it
can be useful.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/connector/cn_queue.c |    1 -
 include/linux/connector.h    |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 296f510..75122cb 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -146,7 +146,6 @@ struct cn_queue_dev *cn_queue_alloc_dev(char *name, struct sock *nls)
 	spin_lock_init(&dev->queue_lock);
 
 	dev->nls = nls;
-	dev->netlink_groups = 0;
 
 	dev->cn_queue = create_workqueue(dev->name);
 	if (!dev->cn_queue) {
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 13fc454..7e18311 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -112,7 +112,6 @@ struct cn_queue_dev {
 	struct list_head queue_list;
 	spinlock_t queue_lock;
 
-	int netlink_groups;
 	struct sock *nls;
 };
 
-- 
1.5.3.rc7

