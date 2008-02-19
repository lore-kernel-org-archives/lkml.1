Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbYBSWOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbYBSWOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbYBSWNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:13:44 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:54070 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbYBSWNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:13:41 -0500
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Markus Armbruster <armbru@redhat.com>, Jim Meyering <jim@meyering.net>
Subject: [PATCH] hfsplus: handle match_strdup failure
Date: Tue, 19 Feb 2008 23:13:38 +0100
Message-Id: <1203459219-14719-6-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.5.4.2.134.g82883
In-Reply-To: <1203459219-14719-5-git-send-email-jim@meyering.net>
References: <1203459219-14719-1-git-send-email-jim@meyering.net>
 <1203459219-14719-2-git-send-email-jim@meyering.net>
 <1203459219-14719-3-git-send-email-jim@meyering.net>
 <1203459219-14719-4-git-send-email-jim@meyering.net>
 <1203459219-14719-5-git-send-email-jim@meyering.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* fs/hfsplus/options.c (hfsplus_parse_options): Handle match_strdup failure.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 fs/hfsplus/options.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index dc64fac..9997cbf 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -132,7 +132,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi)
 				return 0;
 			}
 			p = match_strdup(&args[0]);
-			sbi->nls = load_nls(p);
+			if (p)
+				sbi->nls = load_nls(p);
 			if (!sbi->nls) {
 				printk(KERN_ERR "hfs: unable to load nls mapping \"%s\"\n", p);
 				kfree(p);
-- 
1.5.4.2.134.g82883

