Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbYBKJJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbYBKJJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYBKJIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:08:45 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:11370 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYBKJIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:08:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bifKc0DNbaj/PJgQkI2UhgPfGEcJ3HmMRvLBLuEFtS4AFa5pvcpd8G85yEJqrgLPnCSCaWqeA07ELC6Ab2luh+rtdkdJG5sZl7hVXj/ZtKhNDEGZEcR2zCnymAKOcc84omTDBZDv5Yzq6na9NIHxwnLo2CS3AHeHuEixi22XPkM=
From: Joonwoo Park <joonwpark81@gmail.com>
Cc: Joonwoo Park <joonwpark81@gmail.com>, linux-kernel@vger.kernel.org,
       pcaulfie@redhat.com, teigland@redhat.com
Subject: [PATCH 1/2] [RESENDING] fs/dlm: get rid of unnecessary initialization
Date: Mon, 11 Feb 2008 18:08:30 +0900
Message-Id: <12027209122955-git-send-email-joonwpark81@gmail.com>
X-Mailer: git-send-email 1.5.3.rc5
To: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default_groups was allocated with kcalloc, so initialize to NULL
is unnecessary.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 fs/dlm/config.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index c3ad1df..2b96428 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -414,7 +414,6 @@ static struct config_group *make_cluster(struct config_group *g,
 	cl->group.default_groups = gps;
 	cl->group.default_groups[0] = &sps->ss_group;
 	cl->group.default_groups[1] = &cms->cs_group;
-	cl->group.default_groups[2] = NULL;
 
 	cl->cl_tcp_port = dlm_config.ci_tcp_port;
 	cl->cl_buffer_size = dlm_config.ci_buffer_size;
@@ -483,7 +482,6 @@ static struct config_group *make_space(struct config_group *g, const char *name)
 
 	sp->group.default_groups = gps;
 	sp->group.default_groups[0] = &nds->ns_group;
-	sp->group.default_groups[1] = NULL;
 
 	INIT_LIST_HEAD(&sp->members);
 	mutex_init(&sp->members_lock);
-- 
1.5.3.rc5

