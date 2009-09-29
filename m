Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbZI2FCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbZI2FCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZI2FCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:02:39 -0400
Received: from mail.perches.com ([173.55.12.10]:1345 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbZI2FBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:01:20 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@nokia.com>, Alex Elder <aelder@sgi.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jgarzik@redhat.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       xfs-masters@oss.sgi.com, Abhijith Das <adas@redhat.com>,
       cluster-devel@redhat.com
Subject: [PATCH 7/9] fs/gfs2/sys.c: Use %pUX to print UUIDs
Date: Mon, 28 Sep 2009 22:01:09 -0700
Message-Id: <5d3edf851a4cb01c3f42b5efa05f5a9bb694d29b.1254193019.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254193019.git.joe@perches.com>
References: <cover.1254193019.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/gfs2/sys.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 4463297..56901be 100644
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
+	return snprintf(buf, PAGE_SIZE, "%pUX\n", uuid);
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
+		add_uevent_var(env, "UUID=%pUX", uuid);
 	return 0;
 }
 
-- 
1.6.3.1.10.g659a0.dirty

