Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbZFJJk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbZFJJk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZFJJiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbZFJJiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:06 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/24] GFS2: Remove a couple of unused sysfs entries
Date: Wed, 10 Jun 2009 09:30:48 +0100
Message-Id: <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two tunables are pointless and would never need to be
changed anyway. There is also a race between them and umount
as the deamons which they refer to might have gone away. The
easiest way to fix the race is to remove the interface.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index d53b22e..894bf77 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -530,15 +530,6 @@ static ssize_t name##_store(struct gfs2_sbd *sdp, const char *buf, size_t len)\
 }                                                                             \
 TUNE_ATTR_2(name, name##_store)
 
-#define TUNE_ATTR_DAEMON(name, process)                                       \
-static ssize_t name##_store(struct gfs2_sbd *sdp, const char *buf, size_t len)\
-{                                                                             \
-	ssize_t r = tune_set(sdp, &sdp->sd_tune.gt_##name, 1, buf, len);      \
-	wake_up_process(sdp->sd_##process);                                   \
-	return r;                                                             \
-}                                                                             \
-TUNE_ATTR_2(name, name##_store)
-
 TUNE_ATTR(incore_log_blocks, 0);
 TUNE_ATTR(log_flush_secs, 0);
 TUNE_ATTR(quota_warn_period, 0);
@@ -550,8 +541,6 @@ TUNE_ATTR(new_files_jdata, 0);
 TUNE_ATTR(quota_simul_sync, 1);
 TUNE_ATTR(stall_secs, 1);
 TUNE_ATTR(statfs_quantum, 1);
-TUNE_ATTR_DAEMON(recoverd_secs, recoverd_process);
-TUNE_ATTR_DAEMON(logd_secs, logd_process);
 TUNE_ATTR_3(quota_scale, quota_scale_show, quota_scale_store);
 
 static struct attribute *tune_attrs[] = {
@@ -565,8 +554,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_quota_simul_sync.attr,
 	&tune_attr_stall_secs.attr,
 	&tune_attr_statfs_quantum.attr,
-	&tune_attr_recoverd_secs.attr,
-	&tune_attr_logd_secs.attr,
 	&tune_attr_quota_scale.attr,
 	&tune_attr_new_files_jdata.attr,
 	NULL,
-- 
1.6.0.6

