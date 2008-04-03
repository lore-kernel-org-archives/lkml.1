Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbYDCHPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbYDCHPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbYDCHOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:14:52 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33029 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506AbYDCHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:14:51 -0400
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: "'Satoshi UCHIDA'" <s-uchida@ap.jp.nec.com>,
       "'Paul Menage'" <menage@google.com>, <linux-kernel@vger.kernel.org>,
       <containers@lists.linux-foundation.org>
Cc: <axboe@kernel.dk>, <tom-sugawara@ap.jp.nec.com>
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>		<008001c893db$4e2eccf0$ea8c66d0$@jp.nec.com>	<6599ad830804021541s3c1e3197y77d87f63bf47e4b3@mail.gmail.com> <005d01c89559$9e538200$dafa8600$@jp.nec.com>
In-Reply-To: <005d01c89559$9e538200$dafa8600$@jp.nec.com>
Subject: [RFC][patch 6/12][CFQ-cgroup] Add cfq optional operation framework
Date: Thu, 3 Apr 2008 16:14:39 +0900
Message-Id: <006301c8955a$61b66dc0$25234940$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciVEsqJacziMmPnQjKpkKdoNO90TwARhoqAAABbBSA=
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a cfq optional operations framework.
This framework defines specific functions for expanding CFQ.

      Signed-off-by: Satoshi UCHIDA <uchida@ap.jp.nec.com>

---
 block/cfq-cgroup.c          |    4 ++++
 block/cfq-iosched.c         |    5 +++++
 include/linux/cfq-iosched.h |    6 ++++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/block/cfq-cgroup.c b/block/cfq-cgroup.c
index 378a23d..bcb55c8 100644
--- a/block/cfq-cgroup.c
+++ b/block/cfq-cgroup.c
@@ -151,3 +151,7 @@ struct cgroup_subsys cfq_subsys = {
 	.subsys_id = cfq_subsys_id,
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
-- 
1.5.4.1


