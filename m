Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXCGOXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXCGOXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965526AbXCGOXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:23:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965521AbXCGOXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:23:32 -0500
Subject: [GFS2] fix locking mistake [1/12]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: Josef Whiter <jwhiter@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1173277501.11001.752.camel@quoit.chygwyn.com>
References: <1173277501.11001.752.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Mar 2007 14:26:32 +0000
Message-Id: <1173277593.11001.754.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2e95b6653bb69c893e6ee1b42b537939c1ea2b9c Mon Sep 17 00:00:00 2001
From: Josef Whiter <jwhiter@redhat.com>
Date: Tue, 20 Feb 2007 00:03:29 -0500
Subject: [PATCH] [GFS2] fix locking mistake

This patch fixes a locking mistake in the quota code, we do a mutex_lock instead
of a mutex_unlock.

Signed-off-by: Josef Whiter <jwhiter@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index d0db881..c186857 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -279,7 +279,7 @@ static int bh_get(struct gfs2_quota_data *qd)
 		(bh->b_data + sizeof(struct gfs2_meta_header) +
 		 offset * sizeof(struct gfs2_quota_change));
 
-	mutex_lock(&sdp->sd_quota_mutex);
+	mutex_unlock(&sdp->sd_quota_mutex);
 
 	return 0;
 
-- 
1.4.4.2



