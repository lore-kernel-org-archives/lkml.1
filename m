Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZEPQ63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZEPQ63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 12:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZEPQ6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 12:58:19 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:37036 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZEPQ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 12:58:18 -0400
Date: Sat, 16 May 2009 18:58:16 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Mahoney <jeffm@suse.com>, Al Viro <viro@zeniv.linux.org.uk>
cc: reiserfs-devel@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] reiserfs: xattr - Kill warning if !CONFIG_REISERFS_FS_XATTR
Message-ID: <Pine.LNX.4.64.0905161857370.31230@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_REISERFS_FS_XATTR is not set, I get:

    fs/reiserfs/xattr.c: In function 'reiserfs_xattr_init':
    fs/reiserfs/xattr.c:993: warning: unused variable 'privroot'

since commit ab17c4f02156c4f75d7fa43a5aa2a7f942d47201 ("reiserfs: fixup
xattr_root caching").

Move the definition of `privroot' inside the section protected by #ifdef
CONFIG_REISERFS_FS_XATTR to kill the warning.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/reiserfs/xattr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 2237e10..3c767d9 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -990,9 +990,10 @@ int reiserfs_lookup_privroot(struct super_block *s)
 int reiserfs_xattr_init(struct super_block *s, int mount_flags)
 {
 	int err = 0;
-	struct dentry *privroot = REISERFS_SB(s)->priv_root;
 
 #ifdef CONFIG_REISERFS_FS_XATTR
+	struct dentry *privroot = REISERFS_SB(s)->priv_root;
+
 	err = xattr_mount_check(s);
 	if (err)
 		goto error;
-- 
1.6.3

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
