Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbZK1G2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbZK1G2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 01:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZK1G1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 01:27:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:54901 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752101AbZK1G1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 01:27:48 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX1/GuMErnBLGtNQMT3tIvJkYazGSRolDeWQF/nSVpI
	Q1b1mpLa5aR8y1
From: Johannes Buchner <buchner.johannes@gmx.at>
To: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Cc: Johannes Buchner <buchner.johannes@gmx.at>
Subject: [PATCH 4/4] reiser4: fixed null pointer dereference
Date: Sat, 28 Nov 2009 19:28:04 +1300
Message-Id: <1259389684-18625-5-git-send-email-buchner.johannes@gmx.at>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1259389684-18625-4-git-send-email-buchner.johannes@gmx.at>
References: <1259389179-3772-2-git-send-email-buchner.johannes@gmx.at>
 <1259389684-18625-1-git-send-email-buchner.johannes@gmx.at>
 <1259389684-18625-2-git-send-email-buchner.johannes@gmx.at>
 <1259389684-18625-3-git-send-email-buchner.johannes@gmx.at>
 <1259389684-18625-4-git-send-email-buchner.johannes@gmx.at>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter wbc=NULL caused a NULL pointer dereference in
reiser4_sync_inodes.
This issue was introduced in patch reiser4-vfs-add-super_operationssync_inodes
---
 fs/reiser4/super_ops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiser4/super_ops.c b/fs/reiser4/super_ops.c
index 0c09e3e..f72d42a 100644
--- a/fs/reiser4/super_ops.c
+++ b/fs/reiser4/super_ops.c
@@ -395,7 +395,7 @@ static void reiser4_sync_inodes(struct super_block *super,
 	reiser4_context *ctx;
 	long to_write;
 
-	if (wbc->for_kupdate)
+	if (wbc == NULL || wbc->for_kupdate)
 		/* reiser4 has its own means of periodical write-out */
 		return;
 
-- 
1.6.4.4

