Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbYDAJfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbYDAJfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbYDAJf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:35:26 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:32882 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbYDAJfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:35:25 -0400
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
       <axboe@kernel.dk>, <menage@google.com>
Cc: <s-uchida@ap.jp.nec.com>, <tom-sugawara@ap.jp.nec.com>,
       <m-takahashi@ex.jp.nec.com>
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>
In-Reply-To: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>
Subject: [RFC][patch 5/11][CFQ-cgroup] Add cfq optional operation framework
Date: Tue, 1 Apr 2008 18:35:05 +0900
Message-Id: <008201c893db$aaf0d550$00d27ff0$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciT2dazsgoxpK4vQk6Hf026phpfBAAAazlQ
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a cfq optional operations framework.
This framework defines specific functions for expanding CFQ.

    Signed-off-by: Satoshi UCHIDA <uchida@ap.jp.nec.com>

diff --git a/block/cfq-cgroup.c b/block/cfq-cgroup.c
index b5303d9..95663f9 100644
--- a/block/cfq-cgroup.c
+++ b/block/cfq-cgroup.c
@@ -151,3 +151,7 @@ struct cgroup_subsys cfq_cgroup_subsys = {
 	.subsys_id = cfq_cgroup_subsys_id,
 	.populate = cfq_cgroup_populate,
 };
+
+
+struct cfq_ops opt = {
+};
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index aaf5d7e..245c252 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2233,6 +2233,11 @@ static void __exit cfq_exit(void)
 module_init(cfq_init);
 module_exit(cfq_exit);
 
+#ifndef CONFIG_CGROUP_CFQ
+struct cfq_ops opt = {
+};
+#endif
+
 MODULE_AUTHOR("Jens Axboe");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Completely Fair Queueing IO scheduler");
diff --git a/include/linux/cfq-iosched.h b/include/linux/cfq-iosched.h
index 035bfc4..9287da1 100644
--- a/include/linux/cfq-iosched.h
+++ b/include/linux/cfq-iosched.h
@@ -87,4 +87,10 @@ static inline struct request_queue * __cfq_container_of_queue(struct work_struct
 	return cfqd->cfq_driv_d.queue;
 };
 
+struct cfq_ops
+{
+};
+
+extern struct cfq_ops opt;
+
 #endif  /* _LINUX_CFQ_IOSCHED_H */

