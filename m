Return-Path: <linux-kernel-owner+w=401wt.eu-S932834AbXBEOX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834AbXBEOX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932839AbXBEOX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:23:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612AbXBEOXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:23:54 -0500
Subject: [GFS2] Remove max_atomic_write tunable [28/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:31:58 +0000
Message-Id: <1170685918.11001.327.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From d3601c594d21569e2963958a8d47df9eb7b55603 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 15 Jan 2007 16:36:26 -0500
Subject: [PATCH] [GFS2] Remove max_atomic_write tunable

This removes an unused sysfs tunable parameter.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 8075870..9114851 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -417,7 +417,6 @@ struct gfs2_tune {
 	unsigned int gt_atime_quantum; /* Min secs between atime updates */
 	unsigned int gt_new_files_jdata;
 	unsigned int gt_new_files_directio;
-	unsigned int gt_max_atomic_write; /* Split big writes into this size */
 	unsigned int gt_max_readahead; /* Max bytes to read-ahead from disk */
 	unsigned int gt_lockdump_size;
 	unsigned int gt_stall_secs; /* Detects trouble! */
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 100852a..3e17dcf 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -71,7 +71,6 @@ void gfs2_tune_init(struct gfs2_tune *gt)
 	gt->gt_atime_quantum = 3600;
 	gt->gt_new_files_jdata = 0;
 	gt->gt_new_files_directio = 0;
-	gt->gt_max_atomic_write = 4 << 20;
 	gt->gt_max_readahead = 1 << 18;
 	gt->gt_lockdump_size = 131072;
 	gt->gt_stall_secs = 600;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index cd28f08..1120611 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -441,7 +441,6 @@ TUNE_ATTR(new_files_jdata, 0);
 TUNE_ATTR(new_files_directio, 0);
 TUNE_ATTR(quota_simul_sync, 1);
 TUNE_ATTR(quota_cache_secs, 1);
-TUNE_ATTR(max_atomic_write, 1);
 TUNE_ATTR(stall_secs, 1);
 TUNE_ATTR(greedy_default, 1);
 TUNE_ATTR(greedy_quantum, 1);
@@ -467,7 +466,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_statfs_slow.attr,
 	&tune_attr_quota_simul_sync.attr,
 	&tune_attr_quota_cache_secs.attr,
-	&tune_attr_max_atomic_write.attr,
 	&tune_attr_stall_secs.attr,
 	&tune_attr_greedy_default.attr,
 	&tune_attr_greedy_quantum.attr,
-- 
1.4.4.2



