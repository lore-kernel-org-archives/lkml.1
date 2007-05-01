Return-Path: <linux-kernel-owner+w=401wt.eu-S1423026AbXEAK3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423026AbXEAK3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423384AbXEAK3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:29:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423026AbXEAK2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:28:49 -0400
Subject: [GFS2] printk warning fixes [32/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:24:13 +0100
Message-Id: <1178015053.5462.194.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From f391a4ead61e4510ff385815ddaf3c0777fbad1b Mon Sep 17 00:00:00 2001
From: akpm@linux-foundation.org <akpm@linux-foundation.org>
Date: Wed, 25 Apr 2007 21:08:02 -0700
Subject: [PATCH] [GFS2] printk warning fixes

alpha:

fs/gfs2/dir.c: In function 'gfs2_dir_read_leaf':
fs/gfs2/dir.c:1322: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'sector_t'
fs/gfs2/dir.c: In function 'gfs2_dir_read':
fs/gfs2/dir.c:1455: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type '__u64'

Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 6c3ed76..a96fa07 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1319,9 +1319,11 @@ static int gfs2_dir_read_leaf(struct inode *inode, u64 *offset, void *opaque,
 			if (IS_ERR(dent))
 				goto out_kfree;
 			if (entries2 != g.offset) {
-				fs_warn(sdp, "Number of entries corrupt in dir leaf %llu, "
-				        "entries2 (%u) != g.offset (%u)\n",
-					(u64)bh->b_blocknr, entries2, g.offset);
+				fs_warn(sdp, "Number of entries corrupt in dir "
+						"leaf %llu, entries2 (%u) != "
+						"g.offset (%u)\n",
+					(unsigned long long)bh->b_blocknr,
+					entries2, g.offset);
 					
 				error = -EIO;
 				goto out_kfree;
@@ -1454,7 +1456,8 @@ int gfs2_dir_read(struct inode *inode, u64 *offset, void *opaque,
 		if (dip->i_di.di_entries != g.offset) {
 			fs_warn(sdp, "Number of entries corrupt in dir %llu, "
 				"ip->i_di.di_entries (%u) != g.offset (%u)\n",
-				dip->i_num.no_addr, dip->i_di.di_entries,
+				(unsigned long long)dip->i_num.no_addr,
+				dip->i_di.di_entries,
 				g.offset);
 			error = -EIO;
 			goto out;
-- 
1.5.1.2



