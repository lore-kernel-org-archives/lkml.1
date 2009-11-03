Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZKCXsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZKCXsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZKCXsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:48:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZKCXoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 14/20] blkio: Do not allow request merging across cfq groups
Date: Tue,  3 Nov 2009 18:43:51 -0500
Message-Id: <1257291837-6246-15-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Do not allow request merging across cfq groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6936519..87b1799 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1381,6 +1381,9 @@ static int cfq_allow_merge(struct request_queue *q, struct request *rq,
 	struct cfq_io_context *cic;
 	struct cfq_queue *cfqq;
 
+	/* Deny merge if bio and rq don't belong to same cfq group */
+	if (cfqq_to_cfqg(RQ_CFQQ(rq)) != cfq_get_cfqg(cfqd, 0))
+		return false;
 	/*
 	 * Disallow merge of a sync bio into an async request.
 	 */
-- 
1.6.2.5

