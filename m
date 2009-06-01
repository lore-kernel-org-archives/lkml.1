Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbZFAUDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbZFAUDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbZFAUDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:03:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49314 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503AbZFAUDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:03:20 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/4] dnotify: do not use ?true:false when assigning to a bool
To: linux-kernel@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, hch@lst.de, eparis@redhat.com
Date: Mon, 01 Jun 2009 16:03:20 -0400
Message-ID: <20090601200319.16582.41037.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090601200314.16582.70992.stgit@paris.rdu.redhat.com>
References: <20090601200314.16582.70992.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dnotify_should send event assigned a bool using ?true:false when computing
a bit operation.  This is poitless and the bool type does this for us.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/dnotify/dnotify.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 12f9e6b..5134e89 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -154,7 +154,7 @@ static bool dnotify_should_send_event(struct fsnotify_group *group,
 		return false;
 
 	spin_lock(&entry->lock);
-	send = (mask & entry->mask) ? true : false;
+	send = (mask & entry->mask);
 	spin_unlock(&entry->lock);
 	fsnotify_put_mark(entry); /* matches fsnotify_find_mark_entry */
 

