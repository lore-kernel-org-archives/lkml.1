Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbZI2FBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbZI2FBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZI2FBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:01:14 -0400
Received: from mail.perches.com ([173.55.12.10]:1300 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZI2FBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:01:12 -0400
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
       xfs-masters@oss.sgi.com, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/9] random.c: Use %pU to print UUIDs
Date: Mon, 28 Sep 2009 22:01:05 -0700
Message-Id: <fc7b6edec15282eaf7f3bbf47157ac29f4505805.1254193019.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254193019.git.joe@perches.com>
References: <cover.1254193019.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/random.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 04b505e..7104df9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1245,12 +1245,8 @@ static int proc_do_uuid(ctl_table *table, int write,
 	if (uuid[8] == 0)
 		generate_random_uuid(uuid);
 
-	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
-		"%02x%02x%02x%02x%02x%02x",
-		uuid[0],  uuid[1],  uuid[2],  uuid[3],
-		uuid[4],  uuid[5],  uuid[6],  uuid[7],
-		uuid[8],  uuid[9],  uuid[10], uuid[11],
-		uuid[12], uuid[13], uuid[14], uuid[15]);
+	sprintf(buf, "%pU", uuid);
+
 	fake_table.data = buf;
 	fake_table.maxlen = sizeof(buf);
 
@@ -1350,7 +1346,7 @@ ctl_table random_table[] = {
 
 /********************************************************************
  *
- * Random funtions for networking
+ * Random functions for networking
  *
  ********************************************************************/
 
-- 
1.6.3.1.10.g659a0.dirty

