Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZHIV7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZHIV7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 17:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZHIV7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 17:59:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43961 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbZHIV7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 17:59:47 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/5] inotify: use container_of instead of casting
To: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Date: Sun, 09 Aug 2009 17:59:47 -0400
Message-ID: <20090809215947.26204.41124.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090809215935.26204.46787.stgit@paris.rdu.redhat.com>
References: <20090809215935.26204.46787.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify_free_mark casts directly from an fsnotify_mark_entry to an
inotify_inode_mark_entry.  This works, but should use container_of instead
for future proofing.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_user.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index c3086b0..fb38e73 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -424,7 +424,9 @@ skip_send_ignore:
 /* ding dong the mark is dead */
 static void inotify_free_mark(struct fsnotify_mark_entry *entry)
 {
-	struct inotify_inode_mark_entry *ientry = (struct inotify_inode_mark_entry *)entry;
+	struct inotify_inode_mark_entry *ientry;
+
+	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
 
 	kmem_cache_free(inotify_inode_mark_cachep, ientry);
 }

