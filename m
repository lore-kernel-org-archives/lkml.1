Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZHKQaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZHKQaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbZHKQaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:30:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbZHKQaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:30:05 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/8] fsnotify: allow notification requests to not include
	private data
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Date: Tue, 11 Aug 2009 12:30:01 -0400
Message-ID: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify currently expects everything using the generic notification
infrastructure to want to send private data with the notification.
fanotify has no such requirement (like inotify does) so support that
as well.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/notification.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 96ffbd0..cdf203c 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -173,7 +173,8 @@ int fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_even
 	struct fsnotify_event *last_event;
 
 	/* easy to tell if priv was attached to the event */
-	INIT_LIST_HEAD(&priv->event_list);
+	if (priv)
+		INIT_LIST_HEAD(&priv->event_list);
 
 	/*
 	 * There is one fsnotify_event_holder embedded inside each fsnotify_event.

