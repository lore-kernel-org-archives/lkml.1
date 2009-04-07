Return-Path: <linux-kernel-owner+w=401wt.eu-S1759540AbZDGF3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540AbZDGF3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759518AbZDGF3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:29:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41515 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758893AbZDGF3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:29:13 -0400
Date: Tue, 7 Apr 2009 14:27:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: Re: mmotm 2009-04-05-21-45 uploaded
Message-Id: <20090407142739.0027de02.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200904060450.n364oaUj031923@imap1.linux-foundation.org>
References: <200904060450.n364oaUj031923@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Apr 2009 21:50:36 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2009-04-05-21-45 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 
> It contains the following patches against 2.6.29:
> 
> origin.patch

The warning itself comes from changes in origin.patch...so, someone
might fix this already...

==
At make, following warning is pirnted.

scripts/kconfig/mconf arch/x86/Kconfig
usr/Kconfig:145:warning: defaults for choice values not supported

This is a fix.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 usr/Kconfig |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

Index: mmotm-2.6.29-Apr5/usr/Kconfig
===================================================================
--- mmotm-2.6.29-Apr5.orig/usr/Kconfig
+++ mmotm-2.6.29-Apr5/usr/Kconfig
@@ -72,10 +72,9 @@ config RD_LZMA
 	  Support loading of a LZMA encoded initial ramdisk or cpio buffer
 	  If unsure, say N.
 
-if INITRAMFS_SOURCE!=""
-
 choice
 	prompt "Built-in initramfs compression mode"
+	default INITRAMFS_COMPTRSSION_NONE if INITRAMFS_SOURCE=""
 	help
 	  This option decides by which algorithm the builtin initramfs
 	  will be compressed.  Several compression algorithms are
@@ -109,6 +108,7 @@ config INITRAMFS_COMPRESSION_NONE
 config INITRAMFS_COMPRESSION_GZIP
 	bool "Gzip"
 	depends on RD_GZIP
+	depends on INITRAMFS_SOURCE!=""
 	help
 	  The old and tried gzip compression. Its compression ratio is
 	  the poorest among the 3 choices; however its speed (both
@@ -117,6 +117,7 @@ config INITRAMFS_COMPRESSION_GZIP
 config INITRAMFS_COMPRESSION_BZIP2
 	bool "Bzip2"
 	depends on RD_BZIP2
+	depends on INITRAMFS_SOURCE!=""
 	help
 	  Its compression ratio and speed is intermediate.
 	  Decompression speed is slowest among the three.  The initramfs
@@ -127,6 +128,7 @@ config INITRAMFS_COMPRESSION_BZIP2
 config INITRAMFS_COMPRESSION_LZMA
 	bool "LZMA"
 	depends on RD_LZMA
+	depends on INITRAMFS_SOURCE!=""
 	help
 	  The most recent compression algorithm.
 	  Its ratio is best, decompression speed is between the other
@@ -134,14 +136,3 @@ config INITRAMFS_COMPRESSION_LZMA
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

