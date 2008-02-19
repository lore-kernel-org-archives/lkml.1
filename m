Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbYBSWOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbYBSWOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYBSWNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:13:43 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:54069 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbYBSWNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:13:40 -0500
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Markus Armbruster <armbru@redhat.com>, Jim Meyering <jim@meyering.net>
Subject: [PATCH] hfs: handle match_strdup failure
Date: Tue, 19 Feb 2008 23:13:37 +0100
Message-Id: <1203459219-14719-5-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.5.4.2.134.g82883
In-Reply-To: <1203459219-14719-4-git-send-email-jim@meyering.net>
References: <1203459219-14719-1-git-send-email-jim@meyering.net>
 <1203459219-14719-2-git-send-email-jim@meyering.net>
 <1203459219-14719-3-git-send-email-jim@meyering.net>
 <1203459219-14719-4-git-send-email-jim@meyering.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* fs/hfs/super.c (parse_options): Handle match_strdup failure, twice.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 fs/hfs/super.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 32de44e..8cf6797 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -297,7 +297,8 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 				return 0;
 			}
 			p = match_strdup(&args[0]);
-			hsb->nls_disk = load_nls(p);
+			if (p)
+				hsb->nls_disk = load_nls(p);
 			if (!hsb->nls_disk) {
 				printk(KERN_ERR "hfs: unable to load codepage \"%s\"\n", p);
 				kfree(p);
@@ -311,7 +312,8 @@ static int parse_options(char *options, struct hfs_sb_info *hsb)
 				return 0;
 			}
 			p = match_strdup(&args[0]);
-			hsb->nls_io = load_nls(p);
+			if (p)
+				hsb->nls_io = load_nls(p);
 			if (!hsb->nls_io) {
 				printk(KERN_ERR "hfs: unable to load iocharset \"%s\"\n", p);
 				kfree(p);
-- 
1.5.4.2.134.g82883

