Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbYBSWOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbYBSWOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbYBSWNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:13:42 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:54067 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918AbYBSWNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:13:40 -0500
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Markus Armbruster <armbru@redhat.com>, Jim Meyering <jim@meyering.net>
Subject: [PATCH] affs: handle match_strdup failure
Date: Tue, 19 Feb 2008 23:13:36 +0100
Message-Id: <1203459219-14719-4-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.5.4.2.134.g82883
In-Reply-To: <1203459219-14719-3-git-send-email-jim@meyering.net>
References: <1203459219-14719-1-git-send-email-jim@meyering.net>
 <1203459219-14719-2-git-send-email-jim@meyering.net>
 <1203459219-14719-3-git-send-email-jim@meyering.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* fs/affs/super.c (parse_options): Remove useless initialization.
Handle match_strdup failure.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 fs/affs/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index d2dc047..01d25d5 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -199,7 +199,6 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 		case Opt_prefix:
 			/* Free any previous prefix */
 			kfree(*prefix);
-			*prefix = NULL;
 			*prefix = match_strdup(&args[0]);
 			if (!*prefix)
 				return 0;
@@ -233,6 +232,8 @@ parse_options(char *options, uid_t *uid, gid_t *gid, int *mode, int *reserved, s
 			break;
 		case Opt_volume: {
 			char *vol = match_strdup(&args[0]);
+			if (!vol)
+				return 0;
 			strlcpy(volume, vol, 32);
 			kfree(vol);
 			break;
-- 
1.5.4.2.134.g82883

