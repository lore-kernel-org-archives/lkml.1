Return-Path: <linux-kernel-owner+w=401wt.eu-S1759770AbYHaNQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770AbYHaNQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 09:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759058AbYHaNOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 09:14:47 -0400
Received: from smtp.nokia.com ([192.100.122.233]:61152 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758922AbYHaNOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 09:14:46 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: [PATCH] UBIFS: do not update min_idx_lebs in stafs
Date: Sun, 31 Aug 2008 17:52:38 +0300
Message-Id: <1220194366-12731-5-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 31 Aug 2008 13:14:25.0665 (UTC) FILETIME=[7DCB4710:01C90B6B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

This is bad because the rest of the code should not depend on it,
and this may hide bugss, instead of revealing them.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/budget.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 1540981..ac0d2e1 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -741,7 +741,6 @@ long long ubifs_budg_get_free_space(struct ubifs_info *c)
 
 	available = ubifs_calc_available(c, min_idx_lebs);
 	outstanding = c->budg_data_growth + c->budg_dd_growth;
-	c->min_idx_lebs = min_idx_lebs;
 	spin_unlock(&c->space_lock);
 
 	if (available > outstanding)
-- 
1.5.4.1

