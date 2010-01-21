Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248Ab0AUEXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0AUEXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318Ab0AUEWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:22:46 -0500
Received: from kroah.org ([198.145.64.141]:60056 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab0AUEWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:43 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:32 2010
Message-Id: <20100121041832.720573885@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Paris <eparis@redhat.com>
Subject: [02/30] inotify: only warn once for inotify problems
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 976ae32be45a736acd49215a7e4771ff91f161c3 upstream.

inotify will WARN() if it finds that the idr and the fsnotify internals
somehow got out of sync.  It was only supposed to do this once but due
to this stupid bug it would warn every single time a problem was
detected.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/notify/inotify/inotify_fsnotify.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -121,7 +121,7 @@ static int idr_callback(int id, void *p,
 	if (warned)
 		return 0;
 
-	warned = false;
+	warned = true;
 	entry = p;
 	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
 


