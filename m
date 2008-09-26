Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbYIZM5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbYIZM5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYIZMyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57608 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbYIZMya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:30 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Steven Whitehouse <swhitho@redhat.com>
Subject: [PATCH 09/12] GFS2: The war on bloat
Date: Fri, 26 Sep 2008 13:00:52 +0100
Message-Id: <1222430455-4632-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-9-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-5-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-6-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-7-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-8-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-9-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch shrinks the gfs2_args structure which is embedded in
every GFS2 superblock. It cuts down the size of the options to a single
unsigned int (the 13 bits of bitfields will be rounded up to that size
by the compiler) from the current 11 unsigned ints. So on x86 thats 44
bytes shrinking to 4 bytes, in each and every GFS2 superblock.

Signed-off-by: Steven Whitehouse <swhitho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index a1777a1..b2c5784 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -386,21 +386,21 @@ struct gfs2_statfs_change_host {
 #define GFS2_DATA_ORDERED	2
 
 struct gfs2_args {
-	char ar_lockproto[GFS2_LOCKNAME_LEN]; /* Name of the Lock Protocol */
-	char ar_locktable[GFS2_LOCKNAME_LEN]; /* Name of the Lock Table */
-	char ar_hostdata[GFS2_LOCKNAME_LEN]; /* Host specific data */
-	int ar_spectator; /* Don't get a journal because we're always RO */
-	int ar_ignore_local_fs; /* Don't optimize even if local_fs is 1 */
-	int ar_localflocks; /* Let the VFS do flock|fcntl locks for us */
-	int ar_localcaching; /* Local-style caching (dangerous on multihost) */
-	int ar_debug; /* Oops on errors instead of trying to be graceful */
-	int ar_upgrade; /* Upgrade ondisk/multihost format */
-	unsigned int ar_num_glockd; /* Number of glockd threads */
-	int ar_posix_acl; /* Enable posix acls */
-	int ar_quota; /* off/account/on */
-	int ar_suiddir; /* suiddir support */
-	int ar_data; /* ordered/writeback */
-	int ar_meta; /* mount metafs */
+	char ar_lockproto[GFS2_LOCKNAME_LEN];	/* Name of the Lock Protocol */
+	char ar_locktable[GFS2_LOCKNAME_LEN];	/* Name of the Lock Table */
+	char ar_hostdata[GFS2_LOCKNAME_LEN];	/* Host specific data */
+	unsigned int ar_spectator:1;		/* Don't get a journal */
+	unsigned int ar_ignore_local_fs:1;	/* Ignore optimisations */
+	unsigned int ar_localflocks:1;		/* Let the VFS do flock|fcntl */
+	unsigned int ar_localcaching:1;		/* Local caching */
+	unsigned int ar_debug:1;		/* Oops on errors */
+	unsigned int ar_upgrade:1;		/* Upgrade ondisk format */
+	unsigned int ar_posix_acl:1;		/* Enable posix acls */
+	unsigned int ar_quota:2;		/* off/account/on */
+	unsigned int ar_suiddir:1;		/* suiddir support */
+	unsigned int ar_data:2;			/* ordered/writeback */
+	unsigned int ar_meta:1;			/* mount metafs */
+	unsigned int ar_num_glockd;		/* Number of glockd threads */
 };
 
 struct gfs2_tune {
-- 
1.5.5.1

