Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYADF6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYADF6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbYADF5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:57:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62624 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757880AbYADF5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:57:18 -0500
Message-ID: <477DC9BC.1070006@cn.fujitsu.com>
Date: Fri, 04 Jan 2008 13:53:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] CONNECTOR: cleanup struct cn_callback_entry
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- 'cb' is a fake struct member. In a previous patch struct cn_callback
was renamed to cn_callback_id, so 'cb' should have been deleted at that
time.

- 'nls' isn't used and is redundant, we can retrieve this data through
cn_callback_entry.pdev->nls.

- 'seq' and 'group' should be u32, as they are declared to be u32 in
other places.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 drivers/connector/cn_queue.c |    1 -
 include/linux/connector.h    |    4 +---
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 75122cb..23cc87a 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -104,7 +104,6 @@ int cn_queue_add_callback(struct cn_queue_dev *dev, char *name, struct cb_id *id
 		return -EINVAL;
 	}
 
-	cbq->nls = dev->nls;
 	cbq->seq = 0;
 	cbq->group = cbq->id.id.idx;
 
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 7e18311..da6dd95 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -132,15 +132,13 @@ struct cn_callback_data {
 
 struct cn_callback_entry {
 	struct list_head callback_entry;
-	struct cn_callback *cb;
 	struct work_struct work;
 	struct cn_queue_dev *pdev;
 
 	struct cn_callback_id id;
 	struct cn_callback_data data;
 
-	int seq, group;
-	struct sock *nls;
+	u32 seq, group;
 };
 
 struct cn_ctl_entry {
-- 
1.5.3.rc7

