Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbZGIJo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbZGIJo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 05:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbZGIJov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 05:44:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53627 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbZGIJou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 05:44:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Fix compilation warning
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       David Howells <dhowells@redhat.com>
Date: Thu, 09 Jul 2009 10:44:30 +0100
Message-ID: <20090709094430.23882.46013.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Fix the following warning:

fs/afs/dir.c: In function 'afs_d_revalidate':
fs/afs/dir.c:567: warning: 'fid.vnode' may be used uninitialized in this function
fs/afs/dir.c:567: warning: 'fid.unique' may be used uninitialized in this function

by marking the 'fid' variable as an uninitialized_var.  The problem is that gcc
doesn't always manage to work out that fid is always set on the path through
the function that uses it.

Cc: linux-afs@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 5272872..790ba9d 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -566,7 +566,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct afs_vnode *vnode, *dir;
-	struct afs_fid fid;
+	struct afs_fid uninitialized_var(fid);
 	struct dentry *parent;
 	struct key *key;
 	void *dir_version;

