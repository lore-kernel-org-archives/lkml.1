Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZHIV74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZHIV74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 17:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZHIV7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 17:59:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43965 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbZHIV7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 17:59:53 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/5] fsnotify: kzalloc fsnotify groups
To: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Date: Sun, 09 Aug 2009 17:59:53 -0400
Message-ID: <20090809215952.26204.34643.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090809215935.26204.46787.stgit@paris.rdu.redhat.com>
References: <20090809215935.26204.46787.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzalloc for fsnotify_groups so that none of the fields can leak any
information accidentally.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/group.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index 0e16771..777ca82 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -207,7 +207,7 @@ struct fsnotify_group *fsnotify_obtain_group(unsigned int group_num, __u32 mask,
 	struct fsnotify_group *group, *tgroup;
 
 	/* very low use, simpler locking if we just always alloc */
-	group = kmalloc(sizeof(struct fsnotify_group), GFP_KERNEL);
+	group = kzalloc(sizeof(struct fsnotify_group), GFP_KERNEL);
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 

