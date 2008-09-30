Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYI3HrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYI3HrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYI3Hm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:26 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59037 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbYI3HmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:42:15 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: correct key comparison
Date: Tue, 30 Sep 2008 12:19:06 +0300
Message-Id: <1222766358-21886-11-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:36.0975 (UTC) FILETIME=[F7EB7DF0:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

The comparison was working, but more by accident than design.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 fs/ubifs/tnc_misc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/tnc_misc.c b/fs/ubifs/tnc_misc.c
index a25c1cc..b48db99 100644
--- a/fs/ubifs/tnc_misc.c
+++ b/fs/ubifs/tnc_misc.c
@@ -480,8 +480,8 @@ int ubifs_tnc_read_node(struct ubifs_info *c, struct ubifs_zbranch *zbr,
 	}
 
 	/* Make sure the key of the read node is correct */
-	key_read(c, key, &key1);
-	if (memcmp(node + UBIFS_KEY_OFFSET, &key1, c->key_len)) {
+	key_read(c, node + UBIFS_KEY_OFFSET, &key1);
+	if (!keys_eq(c, key, &key1)) {
 		ubifs_err("bad key in node at LEB %d:%d",
 			  zbr->lnum, zbr->offs);
 		dbg_tnc("looked for key %s found node's key %s",
-- 
1.5.4.1

