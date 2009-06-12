Return-Path: <linux-kernel-owner+w=401wt.eu-S1763070AbZFLOAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763070AbZFLOAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbZFLN7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:59:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51472 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760269AbZFLN7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:59:37 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] GFS2: Remove lock_kernel from gfs2_put_super()
Date: Fri, 12 Jun 2009 13:52:37 +0100
Message-Id: <1244811157-7558-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244811157-7558-2-git-send-email-swhiteho@redhat.com>
References: <1244811157-7558-1-git-send-email-swhiteho@redhat.com>
 <1244811157-7558-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not required here.

Signed-off-by: Steven Whitehouse <swhiteho@redhat,com>
Cc: Christoph Hellwig <hch@infradead.org>

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index c8930b3..0a68013 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -719,8 +719,6 @@ static void gfs2_put_super(struct super_block *sb)
 	int error;
 	struct gfs2_jdesc *jd;
 
-	lock_kernel();
-
 	/*  Unfreeze the filesystem, if we need to  */
 
 	mutex_lock(&sdp->sd_freeze_lock);
@@ -787,8 +785,6 @@ restart:
 
 	/*  At this point, we're through participating in the lockspace  */
 	gfs2_sys_fs_del(sdp);
-
-	unlock_kernel();
 }
 
 /**
-- 
1.6.0.6

