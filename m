Return-Path: <linux-kernel-owner+w=401wt.eu-S934767AbZKYNiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934767AbZKYNiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934735AbZKYNiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:38:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934412AbZKYNgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:36:21 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 25/30] GFS2: Display nobarrier option in /proc/mounts
Date: Wed, 25 Nov 2009 14:30:57 +0000
Message-Id: <1259159462-28622-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259159462-28622-4-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-1-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-2-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-3-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the default is barriers on, this only displays the
nobarrier option when that is active.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 5e4b314..c282ad4 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1336,6 +1336,9 @@ static int gfs2_show_options(struct seq_file *s, struct vfsmount *mnt)
 		}
 		seq_printf(s, ",errors=%s", state);
 	}
+	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
+		seq_printf(s, ",nobarrier");
+
 	return 0;
 }
 
-- 
1.6.2.5

