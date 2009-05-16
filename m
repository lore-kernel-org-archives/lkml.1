Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbZEPJwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbZEPJwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 05:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbZEPJv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 05:51:28 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:45198 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbZEPJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 05:51:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wPswBOrj+VnA9kKg4ve4I81cFqOqTW6F/afXulfZBAUGt3Xo/824/Sy0z6mzjpx5VF
         yri3DbjEpZBj1Ea8rp5nhMDATfBaCJL7apKLppLTgajEo47QXipJ2xvcnMTmMywCMONe
         TuzpLTzVN+ImI9pkX6xMlUTO4MK7pFbOurn3U=
From: Vegard Nossum <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3/4] kmemcheck: fix do_mount_root() false positive
Date: Sat, 16 May 2009 11:51:19 +0200
Message-Id: <1242467480-14378-3-git-send-email-vegard.nossum@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.61.g5cd12
In-Reply-To: <1242467480-14378-2-git-send-email-vegard.nossum@gmail.com>
References: <1242467480-14378-1-git-send-email-vegard.nossum@gmail.com>
 <1242467480-14378-2-git-send-email-vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hide the false positive by using the new __getname_gfp() with the
__GFP_NOTRACK_FALSE_POSITIVE flag.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 init/do_mounts.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index dd7ee5f..093f659 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -231,7 +231,8 @@ static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 
 void __init mount_block_root(char *name, int flags)
 {
-	char *fs_names = __getname();
+	char *fs_names = __getname_gfp(GFP_KERNEL
+		| __GFP_NOTRACK_FALSE_POSITIVE);
 	char *p;
 #ifdef CONFIG_BLOCK
 	char b[BDEVNAME_SIZE];
-- 
1.6.0.6

