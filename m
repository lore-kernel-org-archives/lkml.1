Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab0AORQA (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 12:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852Ab0AORP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 12:15:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757672Ab0AORP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 12:15:58 -0500
From: eparis@redhat.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, faure@kde.org,
        bhutchings@solarflare.com, akpm@linux-foundation.org,
        linux@horizon.com, Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/2] inotify: only warn once for inotify problems
Date: Fri, 15 Jan 2010 12:12:25 -0500
Message-Id: <1263575545-26703-2-git-send-email-eparis@redhat.com>
In-Reply-To: <1263575545-26703-1-git-send-email-eparis@redhat.com>
References: <1263575545-26703-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

inotify will WARN() if it finds that the idr and the fsnotify internals
somehow got out of sync.  It was only supposed to do this once but due
to this stupid bug it would warn every single time a problem was detected.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/inotify/inotify_fsnotify.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index c9ee67b..1afb0a1 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -121,7 +121,7 @@ static int idr_callback(int id, void *p, void *data)
 	if (warned)
 		return 0;
 
-	warned = false;
+	warned = true;
 	entry = p;
 	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
 
-- 
1.6.5.3

