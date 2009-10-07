Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZJGEqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZJGEqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZJGEqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:46:23 -0400
Received: from mail.perches.com ([173.55.12.10]:1953 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbZJGEqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:46:20 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Subject: [PATCH 2/8] random.c: Use %pU to print UUIDs
Date: Tue,  6 Oct 2009 21:45:35 -0700
Message-Id: <f1bf1e935f962ce807a0d70e1657ac778ca833ba.1254884776.git.joe@perches.com>
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

