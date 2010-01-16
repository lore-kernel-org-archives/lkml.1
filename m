Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0APQAY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 11:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567Ab0APQAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 11:00:18 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44209 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab0APQAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 11:00:12 -0500
Date: Sat, 16 Jan 2010 17:00:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Sage Weil <sage@newdream.net>, ceph-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/9] fs/ceph: Eliminate useless code
Message-ID: <Pine.LNX.4.64.1001161659520.28745@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable client is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ceph/addr.c  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index eab46b0..8686018 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -567,9 +567,9 @@ static int ceph_writepages_start(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_client *client = ceph_inode_to_client(inode);
+	struct ceph_client *client;
 	pgoff_t index, start, end;
 	int range_whole = 0;
 	int should_loop = 1;
