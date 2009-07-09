Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbZGIGO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbZGIGO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZGIGOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:14:50 -0400
Received: from smtp.nokia.com ([192.100.105.134]:38382 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZGIGOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:14:50 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: David Howells <dhowells@redhat.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] AFS: fix compilation warning
Date: Thu,  9 Jul 2009 11:04:34 +0300
Message-Id: <1247126674-22912-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.6.0.6
X-OriginalArrivalTime: 09 Jul 2009 06:14:07.0249 (UTC) FILETIME=[77546010:01CA005C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning:

fs/afs/dir.c: In function ‘afs_d_revalidate’:
fs/afs/dir.c:567: warning: ‘fid.vnode’ may be used uninitialized in this function
fs/afs/dir.c:567: warning: ‘fid.unique’ may be used uninitialized in this function

Cc: linux-afs@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

---
 fs/afs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 9bd7577..88067f3 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -564,7 +564,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct afs_vnode *vnode, *dir;
-	struct afs_fid fid;
+	struct afs_fid uninitialized_var(fid);
 	struct dentry *parent;
 	struct key *key;
 	void *dir_version;
-- 
1.6.0.6

