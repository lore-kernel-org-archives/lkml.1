Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZDAHKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZDAHKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 03:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbZDAHKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 03:10:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZDAHKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 03:10:01 -0400
Date: Wed, 1 Apr 2009 00:08:25 -0700
Message-Id: <200904010708.n3178PZx004586@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Teoh <htmldeveloper@gmail.com>, Alain Knaff <alain@knaff.lu>,
       Jike Song <albcamus@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixer <tglx@linutronix.de>
In-Reply-To: <804dabb00903312335t660536a1pc029988c1f71f63a@mail.gmail.com>
Subject: [GIT PULL] bzip2/lzma Kconfig warning fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patch should take care of the annoying Kconfig warning from the
bzip2/lzma code.

The following changes since commit 15f7176eb1cccec0a332541285ee752b935c1c85:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git bzip2-lzma-for-linus

H. Peter Anvin (1):
      bzip2/lzma: quiet Kconfig warning for INITRAMFS_COMPRESSION_NONE

 usr/Kconfig  |   15 +--------------
 usr/Makefile |    3 ---
 2 files changed, 1 insertions(+), 17 deletions(-)

commit 1359096eacb1971be67eead8bf9b582864d92a30
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Tue Mar 31 12:24:17 2009 -0700

    bzip2/lzma: quiet Kconfig warning for INITRAMFS_COMPRESSION_NONE
    
    Impact: quiet Kconfig warning
    
    It appears that Kconfig simply has no way to provide defaults for
    entries that exist inside a conditionalized choice block.
    Fortunately, it turns out we don't actually ever use
    CONFIG_INITRAMFS_COMPRESSION_NONE, so we can just drop it for
    everything outside the choice block.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/usr/Kconfig b/usr/Kconfig
index 588c588..1c3039f 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -72,10 +72,8 @@ config RD_LZMA
 	  Support loading of a LZMA encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
 
-if INITRAMFS_SOURCE!=""
-
 choice
-	prompt "Built-in initramfs compression mode"
+	prompt "Built-in initramfs compression mode" if INITRAMFS_SOURCE!=""
 	help
 	  This option decides by which algorithm the builtin initramfs
 	  will be compressed.  Several compression algorithms are
@@ -134,14 +132,3 @@ config INITRAMFS_COMPRESSION_LZMA
 	  smaller with LZMA in comparison to gzip.
 
 endchoice
-
-endif
-
-if INITRAMFS_SOURCE=""
-# The builtin initramfs is so small so we don't want to bug the user...
-
-config INITRAMFS_COMPRESSION_NONE
-	bool
-	default y
-
-endif
diff --git a/usr/Makefile b/usr/Makefile
index b84894b..245145a 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -6,9 +6,6 @@ klibcdirs:;
 PHONY += klibcdirs
 
 
-# No compression
-suffix_$(CONFIG_INITRAMFS_COMPRESSION_NONE)   =
-
 # Gzip, but no bzip2
 suffix_$(CONFIG_INITRAMFS_COMPRESSION_GZIP)   = .gz
 
