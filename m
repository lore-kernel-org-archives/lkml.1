Return-Path: <linux-kernel-owner+w=401wt.eu-S965312AbXHMDBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312AbXHMDBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 23:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759716AbXHMDBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 23:01:39 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:9499 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbXHMDBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 23:01:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=RbQdlKORGNwglnJR2e2pyrrE+YIF33vh5iaQO2p2qbRka2gyjBeggHQ0TK/Rq8wrdykc/q9HJfrbZjoChz9ODgXD/AMUR2cvcc4RJrkwV4abEZNhfLhpUhDNf8Jql9WCNoQbqdmoSZXBuy/NvNNldiT9//B5RLnjm1g0mf0CMYc=
From: Denis Cheng <crquan@gmail.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] gfs2: better code for translating characters
Date: Mon, 13 Aug 2007 11:01:58 +0800
Message-Id: <11869741183677-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the original code could work, but I think this code could work better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/gfs2/ops_fstype.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index cf5aa50..b9a7759 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -145,7 +145,8 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
 	snprintf(sdp->sd_proto_name, GFS2_FSNAME_LEN, "%s", proto);
 	snprintf(sdp->sd_table_name, GFS2_FSNAME_LEN, "%s", table);
 
-	while ((table = strchr(sdp->sd_table_name, '/')))
+	table = sdp->sd_table_name;
+	while ((table = strchr(table, '/')))
 		*table = '_';
 
 out:
-- 
1.5.2.2

