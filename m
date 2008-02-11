Return-Path: <linux-kernel-owner+w=401wt.eu-S1751515AbYBKJJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbYBKJJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYBKJIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:08:48 -0500
Received: from qb-out-0506.google.com ([72.14.204.224]:61683 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYBKJIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=E64JQve1Lw1AP2KLRrB87uBozQTZQz9KyB908Fd6Vp9yVnzb5iJTBSO3W+YsvD87YbVoJUnhX9RC7U7iBNL6sw/I4+I8gJ/4LnJlsEG5ohj16YOm8ZbMkruViFq+rwc06Z+JvARQIbrxbYnVvu3hAuDLm2puN0sKfNXgsy89ZGM=
From: Joonwoo Park <joonwpark81@gmail.com>
Cc: Joonwoo Park <joonwpark81@gmail.com>, linux-kernel@vger.kernel.org,
       mark.fasheh@oracle.com, kurt.hackel@oracle.com
Subject: [PATCH 2/2] [RESENDING] fs/ocfs2: get rid of unnecessary initialization
Date: Mon, 11 Feb 2008 18:08:31 +0900
Message-Id: <12027209163465-git-send-email-joonwpark81@gmail.com>
X-Mailer: git-send-email 1.5.3.rc5
In-Reply-To: <12027209122955-git-send-email-joonwpark81@gmail.com>
References: <12027209122955-git-send-email-joonwpark81@gmail.com>
To: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default_groups was allocated with kcalloc, so initialize to NULL
is unnecessary.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 fs/ocfs2/cluster/nodemanager.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index 709fba2..08609d7 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -839,7 +839,6 @@ static struct config_group *o2nm_cluster_group_make_group(struct config_group *g
 	cluster->cl_group.default_groups = defs;
 	cluster->cl_group.default_groups[0] = &ns->ns_group;
 	cluster->cl_group.default_groups[1] = o2hb_group;
-	cluster->cl_group.default_groups[2] = NULL;
 	rwlock_init(&cluster->cl_nodes_lock);
 	cluster->cl_node_ip_tree = RB_ROOT;
 	cluster->cl_reconnect_delay_ms = O2NET_RECONNECT_DELAY_MS_DEFAULT;
-- 
1.5.3.rc5

