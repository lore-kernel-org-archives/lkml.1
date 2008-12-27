Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYL0U2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYL0U2t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYL0U2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:28:37 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:46781 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbYL0U2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:28:37 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp
Subject: [PATCH] fat: drop negative dentry on rename() path
Date: Sun, 28 Dec 2008 05:17:23 +0900
Message-Id: <ebeb0406f153db51ab2d4771faf2342bd6ca14dd.1230408710.git.hirofumi@mail.parknet.co.jp>
X-Mailer: git-send-email 1.6.0.5.dirty
In-Reply-To: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
References: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
In-Reply-To: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
References: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the negative dentry on rename() path, in order to make sure to
use the case sensitive name which is specified by user if this is for
creation.

For it, this uses newly added LOOKUP_RENAME_TARGET like LOOKUP_CREATE.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/namei_vfat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index bf326d4..8ae32e3 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -78,7 +78,7 @@ static int vfat_revalidate_ci(struct dentry *dentry, struct nameidata *nd)
 	 * for creation.
 	 */
 	if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
-		if (nd->flags & LOOKUP_CREATE)
+		if (nd->flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET))
 			return 0;
 	}
 
-- 
1.6.0.5.dirty

