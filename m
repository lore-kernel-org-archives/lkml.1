Return-Path: <linux-kernel-owner+w=401wt.eu-S1031647AbXEAKDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031647AbXEAKDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031646AbXEAKDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:03:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031647AbXEAKDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:03:37 -0400
Subject: [GFS2] fix bz 231369, gfs2 will oops if you specify an invalid
	mount option [2/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Josef Whiter <jwhiter@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 10:59:04 +0100
Message-Id: <1178013544.5462.131.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5c7342d894973636f03270673e1fb7b908a421a8 Mon Sep 17 00:00:00 2001
From: Josef Whiter <jwhiter@redhat.com>
Date: Wed, 7 Mar 2007 17:09:10 -0500
Subject: [PATCH] [GFS2] fix bz 231369, gfs2 will oops if you specify an invalid mount option

If you specify an invalid mount option when trying to mount a gfs2 filesystem,
gfs2 will oops.  The attached patch resolves this problem.

Signed-off-by: Josef Whiter <jwhiter@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 9f203ef..a3a24f2 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -2217,7 +2217,7 @@ int gfs2_create_debugfs_file(struct gfs2_sbd *sdp)
 
 void gfs2_delete_debugfs_file(struct gfs2_sbd *sdp)
 {
-	if (sdp->debugfs_dentry)
+	if (sdp && sdp->debugfs_dentry)
 		debugfs_remove(sdp->debugfs_dentry);
 }
 
-- 
1.5.1.2



