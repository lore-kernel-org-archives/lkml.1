Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYEaPjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYEaPjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYEaPiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:38:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58067 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbYEaPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:38:09 -0400
Message-Id: <20080531153510.563968336@arndb.de>
References: <20080531152013.031903990@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 31 May 2008 17:20:14 +0200
From: arnd@arndb.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: [RFC 1/7] cramfs: allow remount rw
Content-Disposition: inline; filename=0001-cramfs-allow-remount-rw.patch
X-Provags-ID: V01U2FsdGVkX1+kAae8T599VV1u8IxYB0wq7qz3UYuUr2kpZmL
 wZcNqDOEd/w5rOuP8XULaro9hQ6MjgA5BHZyHGdIaCgsB4gkxT
 kJH9xQL87d+IznSKODXqg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not possible to write to the current cramfs, so the
check for the rw mount flag is unnecessary. This patch is
required to make fake the fake write patches work on cramfs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/cramfs/inode.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 0c3b618..08f08f9 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -226,7 +226,6 @@ static void cramfs_put_super(struct super_block *sb)
 
 static int cramfs_remount(struct super_block *sb, int *flags, char *data)
 {
-	*flags |= MS_RDONLY;
 	return 0;
 }
 
-- 
1.5.4.3

-- 

