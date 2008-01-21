Return-Path: <linux-kernel-owner+w=401wt.eu-S1762153AbYAUKI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153AbYAUKI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759601AbYAUKCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063AbYAUKCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:18 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 17/58] [GFS2] Given device ID rather than s_id in "id" sysfs file
Date: Mon, 21 Jan 2008 09:21:35 +0000
Message-Id: <12009073701982-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009073698-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
Message-Id: <1083867ce6c8bee18b9e8894b789ce1d0368e23b.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes the /sys/fs/gfs2/<s_id>/id file to give the device
id "major:minor" rather than the s_id.  That enables gfs2_tool to
match devices properly (by id, not name) when locating the tuning files.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 1359198..65dd065 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -32,7 +32,8 @@ spinlock_t gfs2_sys_margs_lock;
 
 static ssize_t id_show(struct gfs2_sbd *sdp, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", sdp->sd_vfs->s_id);
+	return snprintf(buf, PAGE_SIZE, "%u:%u\n",
+			MAJOR(sdp->sd_vfs->s_dev), MINOR(sdp->sd_vfs->s_dev));
 }
 
 static ssize_t fsname_show(struct gfs2_sbd *sdp, char *buf)
-- 
1.5.1.2

