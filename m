Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYHMIkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYHMIkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYHMIjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:39:24 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37109 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbYHMIjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:39:23 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Zoltan Sogor <weth@inf.u-szeged.hu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] UBIFS: minor tweaks in commit
Date: Wed, 13 Aug 2008 13:17:50 +0300
Message-Id: <1218622675-28853-22-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
References: <1218622675-28853-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 08:39:04.0253 (UTC) FILETIME=[0AD45ED0:01C8FD20]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

No functional changes, just lessen the amount of indentations.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/tnc_commit.c |   37 ++++++++++++++++++-------------------
 1 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/ubifs/tnc_commit.c b/fs/ubifs/tnc_commit.c
index 8117e65..8ac76b1 100644
--- a/fs/ubifs/tnc_commit.c
+++ b/fs/ubifs/tnc_commit.c
@@ -372,26 +372,25 @@ static int layout_in_gaps(struct ubifs_info *c, int cnt)
 		written = layout_leb_in_gaps(c, p);
 		if (written < 0) {
 			err = written;
-			if (err == -ENOSPC) {
-				if (!dbg_force_in_the_gaps_enabled) {
-					/*
-					 * Do not print scary warnings if the
-					 * debugging option which forces
-					 * in-the-gaps is enabled.
-					 */
-					ubifs_err("out of space");
-					spin_lock(&c->space_lock);
-					dbg_dump_budg(c);
-					spin_unlock(&c->space_lock);
-					dbg_dump_lprops(c);
-				}
-				/* Try to commit anyway */
-				err = 0;
-				break;
+			if (err != -ENOSPC) {
+				kfree(c->gap_lebs);
+				c->gap_lebs = NULL;
+				return err;
 			}
-			kfree(c->gap_lebs);
-			c->gap_lebs = NULL;
-			return err;
+			if (!dbg_force_in_the_gaps_enabled) {
+				/*
+				 * Do not print scary warnings if the debugging
+				 * option which forces in-the-gaps is enabled.
+				 */
+				ubifs_err("out of space");
+				spin_lock(&c->space_lock);
+				dbg_dump_budg(c);
+				spin_unlock(&c->space_lock);
+				dbg_dump_lprops(c);
+			}
+			/* Try to commit anyway */
+			err = 0;
+			break;
 		}
 		p++;
 		cnt -= written;
-- 
1.5.4.1

