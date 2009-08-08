Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbZHHIDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbZHHIDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 04:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZHHIDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 04:03:17 -0400
Received: from sh.osrg.net ([192.16.179.4]:46317 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbZHHIDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 04:03:13 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-fsdevel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       users@nilfs.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH] fs/Kconfig: move nilfs2 outside misc filesystems
Date: Sat,  8 Aug 2009 17:00:14 +0900
Message-Id: <1249718414-5282-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 08 Aug 2009 17:03:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some people asked me questions like the following:

On Wed, 15 Jul 2009 13:11:21 +0200, Leon Woestenberg wrote:
> just wondering, any reasons why NILFS2 is one of the miscellaneous
> filesystems and, for example, btrfs, is not in Kconfig?

Actually, nilfs is NOT a filesystem came from other operating systems,
but a filesystem created purely for Linux.  Nor is it a flash
filesystem but that for generic block devices.

So, this moves nilfs outside the misc category as I responded in LKML
"Re: Why does NILFS2 hide under Miscellaneous filesystems?"
(Message-Id: <20090716.002526.93465395.ryusuke@osrg.net>).

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/Kconfig        |    2 +-
 fs/nilfs2/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 0e7da7b..455aa20 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -43,6 +43,7 @@ source "fs/xfs/Kconfig"
 source "fs/gfs2/Kconfig"
 source "fs/ocfs2/Kconfig"
 source "fs/btrfs/Kconfig"
+source "fs/nilfs2/Kconfig"
 
 endif # BLOCK
 
@@ -186,7 +187,6 @@ source "fs/romfs/Kconfig"
 source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
-source "fs/nilfs2/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/nilfs2/Kconfig b/fs/nilfs2/Kconfig
index 72da095..251da07 100644
--- a/fs/nilfs2/Kconfig
+++ b/fs/nilfs2/Kconfig
@@ -1,6 +1,6 @@
 config NILFS2_FS
 	tristate "NILFS2 file system support (EXPERIMENTAL)"
-	depends on BLOCK && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	select CRC32
 	help
 	  NILFS2 is a log-structured file system (LFS) supporting continuous
-- 
1.6.3.4

