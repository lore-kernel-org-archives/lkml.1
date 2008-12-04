Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbYLDLSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbYLDLSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 06:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYLDLRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 06:17:51 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:57163 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbYLDLRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 06:17:50 -0500
Subject: [PATCH] fs: reorder struct inotify_device on 64bits to remove
	padding
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: viro@zeniv.linux.org.uk
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 04 Dec 2008 11:17:47 +0000
Message-Id: <1228389467.2963.21.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder struct inotify_device to remove 8 bytes of padding on 64bit
builds, reducing size to 128 bytes . Therefore allocating from a smaller
slab & using one fewer cachelines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
Hi,
patch against 2.6.28-rc7.
built & tested on AMDX2 desktop.

I've not been able to send this to the listed inotify maintainers, I
just get mail failures. So I guessed filesystem was the best home for
it, hope that's ok. 

regards
Richard


diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index d367e9b..5554d7f 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -76,10 +76,10 @@ struct inotify_device {
 	struct mutex		ev_mutex;	/* protects event queue */
 	struct mutex		up_mutex;	/* synchronizes watch updates */
 	struct list_head 	events;		/* list of queued events */
-	atomic_t		count;		/* reference count */
 	struct user_struct	*user;		/* user who opened this dev */
 	struct inotify_handle	*ih;		/* inotify handle */
 	struct fasync_struct    *fa;            /* async notification */
+	atomic_t		count;		/* reference count */
 	unsigned int		queue_size;	/* size of the queue (bytes) */
 	unsigned int		event_count;	/* number of pending events */
 	unsigned int		max_events;	/* maximum number of events */


