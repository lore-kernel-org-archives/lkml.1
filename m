Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZKCXoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZKCXoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZKCXoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:44:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbZKCXoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:44:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 16/20] blkio: do not select co-operating queues from different cfq groups
Date: Tue,  3 Nov 2009 18:43:53 -0500
Message-Id: <1257291837-6246-17-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Select co-operating queue from same group not from a different cfq_group
  to maintain the notion of fairness and isolation between groups.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 98dbead..020d6dd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1635,6 +1635,10 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	if (!cfqq)
 		return NULL;
 
+	/* If new queue belongs to different cfq_group, don't choose it */
+	if (cfqq_to_cfqg(cur_cfqq) != cfqq_to_cfqg(cfqq))
+		return NULL;
+
 	if (cfq_cfqq_coop(cfqq))
 		return NULL;
 
-- 
1.6.2.5

