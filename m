Return-Path: <linux-kernel-owner+w=401wt.eu-S1030471AbXCGO1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030471AbXCGO1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030198AbXCGO1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:27:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030192AbXCGO10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:27:26 -0500
Subject: [GFS2] pass formal ino in do_filldir_main [6/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: "S. Wendy Cheng" <wcheng@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:30:30 +0000
Message-Id: <1173277830.11001.764.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From fb0d3bce8e88cca4abb26076f778f64edcaf19aa Mon Sep 17 00:00:00 2001
From: Wendy Cheng <wcheng@redhat.com>
Date: Wed, 28 Feb 2007 11:24:25 -0500
Subject: [PATCH] [GFS2] pass formal ino in do_filldir_main

ok, the following is the minimum changes to get NFSD going before we
settle down this issue .. would appreciate this in the tree so other NFS
related works can get done in parallel.

Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 0d6831a..902dd81 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -61,13 +61,13 @@ static int iget_set(struct inode *inode, void *opaque)
 
 struct inode *gfs2_ilookup(struct super_block *sb, struct gfs2_inum_host *inum)
 {
-	return ilookup5(sb, (unsigned long)inum->no_formal_ino,
+	return ilookup5(sb, (unsigned long)inum->no_addr,
 			iget_test, inum);
 }
 
 static struct inode *gfs2_iget(struct super_block *sb, struct gfs2_inum_host *inum)
 {
-	return iget5_locked(sb, (unsigned long)inum->no_formal_ino,
+	return iget5_locked(sb, (unsigned long)inum->no_addr,
 		     iget_test, iget_set, inum);
 }
 
-- 
1.4.4.2



