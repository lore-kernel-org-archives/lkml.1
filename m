Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZHQBwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZHQBwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 21:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbZHQBwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 21:52:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43801 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbZHQBwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 21:52:14 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] inotify: start watch descriptor count at 1
To: linux-kernel@vger.kernel.org, fs-devel@vger.kernel.org
Cc: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk
Date: Sun, 16 Aug 2009 21:51:55 -0400
Message-ID: <20090817015155.15099.65278.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090817015143.15099.80614.stgit@paris.rdu.redhat.com>
References: <20090817015143.15099.80614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inotify_add_watch man page specifies that inotify_add_watch() will
return a non-negative integer.  However, historically the inotify watches
started at 1, not at 0.  Turns out that the inotifywait program provided by
the inotify-tools package doesn't properly handle a 0 watch descriptor.
In 7e790dd5 we changed from starting at 1 to starting at 0.  This patch
starts at 1, just like in previous kernels, but also just like in previous
kernels it's possible for it to wrap back to 0.  This preserves the kernel
functionality exactly like it was before the patch (neither method broke
the spec)

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 54cbded..ca0f36b 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -567,7 +567,7 @@ static struct fsnotify_group *inotify_new_group(struct user_struct *user, unsign
 
 	spin_lock_init(&group->inotify_data.idr_lock);
 	idr_init(&group->inotify_data.idr);
-	group->inotify_data.last_wd = 0;
+	group->inotify_data.last_wd = 1;
 	group->inotify_data.user = user;
 	group->inotify_data.fa = NULL;
 

