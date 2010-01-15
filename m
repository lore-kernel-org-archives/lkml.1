Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0AOC4b (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 21:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043Ab0AOC4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 21:56:30 -0500
Received: from [206.15.93.42] ([206.15.93.42]:15480 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751160Ab0AOC4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 21:56:30 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/notify/notification.c: make subsys_initcall static
Date: Thu, 14 Jan 2010 19:56:35 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141956.36042.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/notify/notification.c: make subsys_initcall static

The function fsnotify_notification_init is a subsys_initcall
and does not need to be exported. Make the function
static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index b8bf53b..7f9a085 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -407,7 +407,7 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 	return event;
 }
 
-__init int fsnotify_notification_init(void)
+static __init int fsnotify_notification_init(void)
 {
 	fsnotify_event_cachep = KMEM_CACHE(fsnotify_event, SLAB_PANIC);
 	fsnotify_event_holder_cachep = KMEM_CACHE(fsnotify_event_holder, SLAB_PANIC);
