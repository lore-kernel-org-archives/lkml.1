Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZIJKbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZIJKbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbZIJK36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:29:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbZIJK35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:57 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Roel Kluin <roel.kluin@gmail.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/15] GFS2: jumping to wrong label?
Date: Thu, 10 Sep 2009 12:28:00 +0100
Message-Id: <1252582087-10007-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-8-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-6-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-7-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-8-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

Also a gfs2_glock_dq() is required here.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/ops_inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index f8bd20b..ce551f8 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -349,7 +349,7 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 
 	error = gfs2_trans_begin(sdp, 2*RES_DINODE + RES_LEAF + RES_RG_BIT, 0);
 	if (error)
-		goto out_rgrp;
+		goto out_gunlock;
 
 	error = gfs2_dir_del(dip, &dentry->d_name);
         if (error)
-- 
1.6.2.5

