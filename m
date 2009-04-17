Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbZDQL6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbZDQL6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZDQL6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:58:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39804 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbZDQL6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:58:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Guard afs_file_readpage_read_complete() definition with
	CONFIG_AFS_FSCACHE
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matt Kraai <kraai@ftbfs.org>,
       David Howells <dhowells@redhat.com>
Date: Fri, 17 Apr 2009 12:56:38 +0100
Message-ID: <20090417115638.22649.9130.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Kraai <kraai@ftbfs.org>

If CONFIG_AFS_FSCACHE is not defined, the following warning is displayed when
fs/afs/file.c is compiled:

 fs/afs/file.c:111: warning: ‘afs_file_readpage_read_complete’ defined but not used

This occurs because all calls to this function are guarded by
CONFIG_AFS_FSCACHE.  Thus, guard its definition as well.

Signed-off-by: Matt Kraai <kraai@ftbfs.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/file.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/fs/afs/file.c b/fs/afs/file.c
index 7a1d942..0149dab 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -102,6 +102,7 @@ int afs_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+#ifdef CONFIG_AFS_FSCACHE
 /*
  * deal with notification that a page was read from the cache
  */
@@ -117,6 +118,7 @@ static void afs_file_readpage_read_complete(struct page *page,
 		SetPageUptodate(page);
 	unlock_page(page);
 }
+#endif
 
 /*
  * AFS read page from file, directory or symlink

