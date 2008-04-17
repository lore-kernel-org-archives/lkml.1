Return-Path: <linux-kernel-owner+w=401wt.eu-S934838AbYDQJm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838AbYDQJm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933676AbYDQJ0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933677AbYDQJ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:06 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/48] [GFS2] Remove unused counters
Date: Thu, 17 Apr 2008 09:38:56 +0100
Message-Id: <12084216101961-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216082638-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is kind of trivial in the greater scheme of things, but
this removes three counters that AFAICT are never used.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 9dfdde3..b67e44b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -636,9 +636,6 @@ struct gfs2_sbd {
 
 	/* Counters */
 
-	atomic_t sd_glock_count;
-	atomic_t sd_glock_held_count;
-	atomic_t sd_inode_count;
 	atomic_t sd_reclaimed;
 
 	char sd_fsname[GFS2_FSNAME_LEN];
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index cc35ec8..9ab9fc8 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -327,15 +327,9 @@ static ssize_t name##_show(struct gfs2_sbd *sdp, char *buf)                 \
 }                                                                           \
 static struct counters_attr counters_attr_##name = __ATTR_RO(name)
 
-COUNTERS_ATTR(glock_count,      "%u\n");
-COUNTERS_ATTR(glock_held_count, "%u\n");
-COUNTERS_ATTR(inode_count,      "%u\n");
 COUNTERS_ATTR(reclaimed,        "%u\n");
 
 static struct attribute *counters_attrs[] = {
-	&counters_attr_glock_count.attr,
-	&counters_attr_glock_held_count.attr,
-	&counters_attr_inode_count.attr,
 	&counters_attr_reclaimed.attr,
 	NULL,
 };
-- 
1.5.1.2

