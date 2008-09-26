Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYIZM4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYIZM4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYIZMy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57605 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbYIZMy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:28 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/12] GFS2: Direct IO write at end of file error
Date: Fri, 26 Sep 2008 13:00:50 +0100
Message-Id: <1222430455-4632-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-7-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-5-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-6-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-7-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a problem whereby a direct_io write doesn't fall
back to buffered write properly at end of file.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index e64a1b0..ae7126a 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -975,7 +975,7 @@ static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
 	if (gfs2_is_stuffed(ip))
 		return 0;
 
-	if (offset > i_size_read(&ip->i_inode))
+	if (offset >= i_size_read(&ip->i_inode))
 		return 0;
 	return 1;
 }
-- 
1.5.5.1

