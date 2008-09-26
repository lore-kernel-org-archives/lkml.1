Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbYIZM6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbYIZM6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYIZMye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60046 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbYIZMyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:31 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/12] GFS2: Add UUID to GFS2 sb
Date: Fri, 26 Sep 2008 13:00:54 +0100
Message-Id: <1222430455-4632-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-11-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-5-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-6-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-7-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-8-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-9-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-10-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-11-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a UUID to the GFS2 sb structure. This field is not
actually referenced from kernel space at all, but is added for
completeness and due to the userland tools which get their on-disk
structure information from the gfs2_ondisk.h header file.

Since we have to be backwards compatible, we will assume that any GFS2
sb for which the UUID is all 0 does not have a UUID as such.

We should then be (after some userland changes) able to support the -U
mount option. This addresses Fedora bugzilla #242689

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/include/linux/gfs2_ondisk.h b/include/linux/gfs2_ondisk.h
index c3c19f9..14d0df0 100644
--- a/include/linux/gfs2_ondisk.h
+++ b/include/linux/gfs2_ondisk.h
@@ -118,7 +118,11 @@ struct gfs2_sb {
 
 	char sb_lockproto[GFS2_LOCKNAME_LEN];
 	char sb_locktable[GFS2_LOCKNAME_LEN];
-	/* In gfs1, quota and license dinodes followed */
+
+	struct gfs2_inum __pad3; /* Was quota inode in gfs1 */
+	struct gfs2_inum __pad4; /* Was licence inode in gfs1 */
+#define GFS2_HAS_UUID 1
+	__u8 sb_uuid[16]; /* The UUID, maybe 0 for backwards compat */
 };
 
 /*
-- 
1.5.5.1

