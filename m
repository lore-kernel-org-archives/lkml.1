Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0CHTvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:51:18 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:41607 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab0CHTvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:51:10 -0500
Date: Mon, 8 Mar 2010 20:51:03 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Inotify: Fix build failure in inotify user support
Message-ID: <20100308195103.GA9228@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_INOTIFY_USER defined but CONFIG_ANON_INODES undefined will result
in the following build failure:

  LD      vmlinux
fs/built-in.o: In function 'sys_inotify_init1':
(.text.sys_inotify_init1+0x22c): undefined reference to 'anon_inode_getfd'
fs/built-in.o: In function `sys_inotify_init1':
(.text.sys_inotify_init1+0x22c): relocation truncated to fit: R_MIPS_26 against 'anon_inode_getfd'
make[2]: *** [vmlinux] Error 1
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@linux-kernel.org

 fs/notify/inotify/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/notify/inotify/Kconfig b/fs/notify/inotify/Kconfig
index 3e56dbf..b3a159b 100644
--- a/fs/notify/inotify/Kconfig
+++ b/fs/notify/inotify/Kconfig
@@ -15,6 +15,7 @@ config INOTIFY
 
 config INOTIFY_USER
 	bool "Inotify support for userspace"
+	select ANON_INODES
 	select FSNOTIFY
 	default y
 	---help---
