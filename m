Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0BVUmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:42:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab0BVUmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:42:43 -0500
Date: Mon, 22 Feb 2010 15:42:37 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH] VFS: BUG_ON() rehash of an already hashed dentry
Message-ID: <20100222204237.GG972@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a one-line debugging patch which is invaluable when working on
the dcache.  Can I get a yea or a nay on this so I can drop it if it
will never go in?  Thanks,

-VAL

From: Jan Blunck <jblunck@suse.de>
Date: Sun, 17 May 2009 17:29:47 -0700

BUG_ON() rehash of an already hashed dentry.  For debugging of
dcache-related development.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 74da947..3d656ab 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1568,6 +1568,7 @@ void d_rehash(struct dentry * entry)
 {
 	spin_lock(&dcache_lock);
 	spin_lock(&entry->d_lock);
+	BUG_ON(!d_unhashed(entry));
 	_d_rehash(entry);
 	spin_unlock(&entry->d_lock);
 	spin_unlock(&dcache_lock);
-- 
1.5.6.5

