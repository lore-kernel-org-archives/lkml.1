Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbYAUKYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbYAUKYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbYAUKDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:03:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759905AbYAUKD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:03:29 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 58/58] [GFS2] Allow journal recovery on read-only mount
Date: Mon, 21 Jan 2008 09:22:16 +0000
Message-Id: <12009074411454-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074392527-git-send-email-swhiteho@redhat.com>
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
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
 <12009073981159-git-send-email-swhiteho@redhat.com>
 <12009074002775-git-send-email-swhiteho@redhat.com>
 <12009074021586-git-send-email-swhiteho@redhat.com>
 <12009074032614-git-send-email-swhiteho@redhat.com>
 <1200907405414-git-send-email-swhiteho@redhat.com>
 <12009074074196-git-send-email-swhiteho@redhat.com>
 <12009074082286-git-send-email-swhiteho@redhat.com>
 <12009074103982-git-send-email-swhiteho@redhat.com>
 <12009074121930-git-send-email-swhiteho@redhat.com>
 <12009074142128-git-send-email-swhiteho@redhat.com>
 <12009074163163-git-send-email-swhiteho@redhat.com>
 <1200907417194-git-send-email-swhiteho@redhat.com>
 <12009074192015-git-send-email-swhiteho@redhat.com>
 <12009074213460-git-send-email-swhiteho@redhat.com>
 <12009074221447-git-send-email-swhiteho@redhat.com>
 <12009074243427-git-send-email-swhiteho@redhat.com>
 <12009074263736-git-send-email-swhiteho@redhat.com>
 <12009074271575-git-send-email-swhiteho@redhat.com>
 <12009074291130-git-send-email-swhiteho@redhat.com>
 <12009074312371-git-send-email-swhiteho@redhat.com>
 <12009074321081-git-send-email-swhiteho@redhat.com>
 <12009074341030-git-send-email-swhiteho@redhat.com>
 <12009074362909-git-send-email-swhiteho@redhat.com>
 <1200907438887-git-send-email-swhiteho@redhat.com>
 <12009074392527-git-send-email-swhiteho@redhat.com>
Message-Id: <7ecd8d8b2b13714181d4ae3bde6ce4005e5a304e.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

This patch allows gfs2 to perform journal recovery even if it is mounted
read-only. Strictly speaking, a read-only mount should not be writing to
the filesystem, but we do this only to perform journal recovery. A
read-only mount will fail if we don't recover the dirty journal. Also,
when gfs2 is used as a root filesystem, it will be mounted read-only
before being mounted read-write during the boot sequence. A failed
read-only mount will panic the machine during bootup.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 27c994f..b249e29 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -504,13 +504,21 @@ int gfs2_recover_journal(struct gfs2_jdesc *jd)
 			if (!test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags))
 				ro = 1;
 		} else {
-			if (sdp->sd_vfs->s_flags & MS_RDONLY)
-				ro = 1;
+			if (sdp->sd_vfs->s_flags & MS_RDONLY) {
+				/* check if device itself is read-only */
+				ro = bdev_read_only(sdp->sd_vfs->s_bdev);
+				if (!ro) {
+					fs_info(sdp, "recovery required on "
+						"read-only filesystem.\n");
+					fs_info(sdp, "write access will be "
+						"enabled during recovery.\n");
+				}
+			}
 		}
 
 		if (ro) {
-			fs_warn(sdp, "jid=%u: Can't replay: read-only FS\n",
-				jd->jd_jid);
+			fs_warn(sdp, "jid=%u: Can't replay: read-only block "
+				"device\n", jd->jd_jid);
 			error = -EROFS;
 			goto fail_gunlock_tr;
 		}
-- 
1.5.1.2

