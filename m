Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab0BLLWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:22:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab0BLLWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:22:31 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/2] GFS2: Fix error code
Date: Fri, 12 Feb 2010 11:13:20 +0000
Message-Id: <1265973201-3142-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1265973201-3142-1-git-send-email-swhiteho@redhat.com>
References: <1265973201-3142-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

We need this one-liner to signal the mount helper of the 'insufficient journals' condition.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/ops_fstype.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 8a102f7..a86ed63 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -725,7 +725,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 		goto fail;
 	}
 
-	error = -EINVAL;
+	error = -EUSERS;
 	if (!gfs2_jindex_size(sdp)) {
 		fs_err(sdp, "no journals!\n");
 		goto fail_jindex;
-- 
1.6.2.5

