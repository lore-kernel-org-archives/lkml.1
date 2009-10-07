Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbZJGErE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbZJGErE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbZJGErD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:47:03 -0400
Received: from mail.perches.com ([173.55.12.10]:1973 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbZJGErB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:47:01 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 6/8] fs/gfs2/sys.c: Use %pUB to print UUIDs
Date: Tue,  6 Oct 2009 21:45:39 -0700
Message-Id: <316dfe85b1c61c65fb0c50f070614026a6958c91.1254884776.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc2.17.gdbc1b.dirty
In-Reply-To: <1254890742-28245-1-git-send-email-joe@perches.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
In-Reply-To: <cover.1254884776.git.joe@perches.com>
References: <cover.1254884776.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/gfs2/sys.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 4463297..25f03da 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -85,11 +85,7 @@ static ssize_t uuid_show(struct gfs2_sbd *sdp, char *buf)
 	buf[0] = '\0';
 	if (!gfs2_uuid_valid(uuid))
 		return 0;
-	return snprintf(buf, PAGE_SIZE, "%02X%02X%02X%02X-%02X%02X-"
-			"%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X\n",
-			uuid[0], uuid[1], uuid[2], uuid[3], uuid[4], uuid[5],
-			uuid[6], uuid[7], uuid[8], uuid[9], uuid[10], uuid[11],
-			uuid[12], uuid[13], uuid[14], uuid[15]);
+	return snprintf(buf, PAGE_SIZE, "%pUB\n", uuid);
 }
 
 static ssize_t freeze_show(struct gfs2_sbd *sdp, char *buf)
@@ -573,14 +569,8 @@ static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
 	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
 	if (!sdp->sd_args.ar_spectator)
 		add_uevent_var(env, "JOURNALID=%u", sdp->sd_lockstruct.ls_jid);
-	if (gfs2_uuid_valid(uuid)) {
-		add_uevent_var(env, "UUID=%02X%02X%02X%02X-%02X%02X-%02X%02X-"
-			       "%02X%02X-%02X%02X%02X%02X%02X%02X",
-			       uuid[0], uuid[1], uuid[2], uuid[3], uuid[4],
-			       uuid[5], uuid[6], uuid[7], uuid[8], uuid[9],
-			       uuid[10], uuid[11], uuid[12], uuid[13],
-			       uuid[14], uuid[15]);
-	}
+	if (gfs2_uuid_valid(uuid))
+		add_uevent_var(env, "UUID=%pUB", uuid);
 	return 0;
 }
 
-- 
1.6.3.1.10.g659a0.dirty

