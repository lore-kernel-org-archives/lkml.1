Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYKUPpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYKUPpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYKUPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:44:12 -0500
Received: from smtp.nokia.com ([192.100.122.233]:58959 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbYKUPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:44:10 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] UBIFS: remove printk
Date: Fri, 21 Nov 2008 19:19:23 +0200
Message-Id: <1227287970-14684-2-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 21 Nov 2008 15:44:05.0944 (UTC) FILETIME=[FC549B80:01C94BEF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Remove the "UBIFS background thread ubifs_bgd0_0 started" message.
We kill the background thread when we switch to R/O mode, and
start it again whan we switch to R/W mode. OLPC is doing this
many times during boot, and we see this message many times as
well, which is irritating. So just kill the message.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/commit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/commit.c b/fs/ubifs/commit.c
index 0a6aa2c..b49884c 100644
--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -234,8 +234,8 @@ int ubifs_bg_thread(void *info)
 	int err;
 	struct ubifs_info *c = info;
 
-	ubifs_msg("background thread \"%s\" started, PID %d",
-		  c->bgt_name, current->pid);
+	dbg_msg("background thread \"%s\" started, PID %d",
+		c->bgt_name, current->pid);
 	set_freezable();
 
 	while (1) {
-- 
1.5.4.3

