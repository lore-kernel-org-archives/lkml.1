Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbZLQXvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbZLQXvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZLQXvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:51:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50091 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbZLQXvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:51:16 -0500
Date: Fri, 18 Dec 2009 10:51:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tao Ma <tao.ma@oracle.com>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the ocfs2 tree with Linus' tree
Message-Id: <20091218105114.947efae9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joel,

Today's linux-next merge of the ocfs2 tree got a conflict in
fs/ocfs2/file.c between commit 6b2f3d1f769be5779b479c37800229d9a4809fc3
("vfs: Implement proper O_SYNC semantics") from Linus' tree and commit
a8227ccc585025735bcf350f71fa9c1ffd005d8d ("ocfs2: Handle O_DIRECT when
writing to a refcounted cluster") from the ocfs2 tree.

I fixed it up (see below) and can carry the fix for a while.  Since this
is a conflict against Linus' tree, it is fixable in the ocfs2 tree by
doing a merge with Linus' tree.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ocfs2/file.c
index 3d30a1c,04e178e..0000000
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@@ -2006,7 -2013,8 +2013,8 @@@ out_dio
  	/* buffered aio wouldn't have proper lock coverage today */
  	BUG_ON(ret == -EIOCBQUEUED && !(file->f_flags & O_DIRECT));
  
- 	if ((file->f_flags & O_DSYNC && !direct_io) || IS_SYNC(inode)) {
 -	if ((file->f_flags & O_SYNC && !direct_io) || IS_SYNC(inode) ||
++	if ((file->f_flags & O_DSYNC && !direct_io) || IS_SYNC(inode) ||
+ 	    (file->f_flags & O_DIRECT && has_refcount)) {
  		ret = filemap_fdatawrite_range(file->f_mapping, pos,
  					       pos + count - 1);
  		if (ret < 0)
