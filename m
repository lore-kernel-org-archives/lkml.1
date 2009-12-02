Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZLBOPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZLBOPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZLBOPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:15:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbZLBOPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:15:14 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/4] fsnotify: clear marks to 0 in fsnotify_init_mark
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Wed, 02 Dec 2009 09:15:12 -0500
Message-ID: <20091202141511.12819.48242.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com>
References: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently fsnotify_init_mark sets some fields to 0/NULL.  Some users
already used some sorts of zalloc, some didn't.  This patch uses memset to
explicitly zero everything in the fsnotify_mark when it is initialized so we
don't have to be careful if fields are later added to marks.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/mark.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index e56e876..57bb1d7 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -284,11 +284,8 @@ void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *ol
 void fsnotify_init_mark(struct fsnotify_mark *mark,
 			void (*free_mark)(struct fsnotify_mark *mark))
 {
+	memset(mark, 0, sizeof(*mark));
 	spin_lock_init(&mark->lock);
 	atomic_set(&mark->refcnt, 1);
-	INIT_HLIST_NODE(&mark->i.i_list);
-	mark->group = NULL;
-	mark->mask = 0;
-	mark->i.inode = NULL;
 	mark->free_mark = free_mark;
 }

