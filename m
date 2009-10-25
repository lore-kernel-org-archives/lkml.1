Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZJYU0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZJYU0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 16:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZJYU0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 16:26:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbZJYU0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 16:26:53 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/5] fsnotify: fsnotify_obtain_group kzalloc cleanup
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Sun, 25 Oct 2009 16:26:55 -0400
Message-ID: <20091025202655.11501.70437.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify_obtain_group uses kzalloc but then proceedes to set things to 0.
This patch just deletes those useless lines.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/group.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index 62fb896..934860e 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -178,17 +178,14 @@ struct fsnotify_group *fsnotify_obtain_group(__u32 mask,
 
 	atomic_set(&group->refcnt, 1);
 
-	group->on_group_list = 0;
 	group->mask = mask;
 
 	mutex_init(&group->notification_mutex);
 	INIT_LIST_HEAD(&group->notification_list);
 	init_waitqueue_head(&group->notification_waitq);
-	group->q_len = 0;
 	group->max_events = UINT_MAX;
 
 	spin_lock_init(&group->mark_lock);
-	atomic_set(&group->num_marks, 0);
 	INIT_LIST_HEAD(&group->mark_entries);
 
 	group->ops = ops;

