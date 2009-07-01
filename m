Return-Path: <linux-kernel-owner+w=401wt.eu-S1765638AbZGABSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765638AbZGABSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761585AbZGAAf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:59 -0400
Received: from kroah.org ([198.145.64.141]:60743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761590AbZGAAfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:44 2009
Message-Id: <20090701002444.090084909@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 103/108] CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=config_file_locking-should-not-depend-on-config_block.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tomas Szepe <szepe@pinerecords.com>

commit 69050eee8e08a6234f29fe71a56f8c7c7d4d7186 upstream.

CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK.

This makes it possible to run complete systems out of a CONFIG_BLOCK=n
initramfs on current kernels again (this last worked on 2.6.27.*).

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -39,6 +39,13 @@ config FS_POSIX_ACL
 	bool
 	default n
 
+source "fs/xfs/Kconfig"
+source "fs/gfs2/Kconfig"
+source "fs/ocfs2/Kconfig"
+source "fs/btrfs/Kconfig"
+
+endif # BLOCK
+
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EMBEDDED
 	default y
@@ -47,13 +54,6 @@ config FILE_LOCKING
           for filesystems like NFS and for the flock() system
           call. Disabling this option saves about 11k.
 
-source "fs/xfs/Kconfig"
-source "fs/gfs2/Kconfig"
-source "fs/ocfs2/Kconfig"
-source "fs/btrfs/Kconfig"
-
-endif # BLOCK
-
 source "fs/notify/Kconfig"
 
 source "fs/quota/Kconfig"


