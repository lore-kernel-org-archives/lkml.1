Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbZLPWzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbZLPWzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763196AbZLPWzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:55:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762940AbZLPWzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:55:13 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 2/4] cfq-iosched: Get rid of nr_groups
Date: Wed, 16 Dec 2009 17:52:58 -0500
Message-Id: <1261003980-10115-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1261003980-10115-1-git-send-email-vgoyal@redhat.com>
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Currently code does not seem to be using cfqd->nr_groups. Get rid of it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a0e5347..d9bfa09 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -208,8 +208,6 @@ struct cfq_data {
 	/* Root service tree for cfq_groups */
 	struct cfq_rb_root grp_service_tree;
 	struct cfq_group root_group;
-	/* Number of active cfq groups on group service tree */
-	int nr_groups;
 
 	/*
 	 * The priority currently being served
@@ -842,7 +840,6 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 	__cfq_group_service_tree_add(st, cfqg);
 	cfqg->on_st = true;
-	cfqd->nr_groups++;
 	st->total_weight += cfqg->weight;
 }
 
@@ -863,7 +860,6 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
 	cfqg->on_st = false;
-	cfqd->nr_groups--;
 	st->total_weight -= cfqg->weight;
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
-- 
1.6.2.5

