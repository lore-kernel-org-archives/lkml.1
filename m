Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbXHHQ2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbXHHQ2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936516AbXHHQ1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:27:37 -0400
Received: from lazybastard.de ([212.112.238.170]:54590 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936503AbXHHQ1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:27:35 -0400
Date: Wed, 8 Aug 2007 18:23:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch 16/18] fs/Kconfig
Message-ID: <20070808162339.GR15319@lazybastard.org>
References: <20070808161234.GB15319@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070808161234.GB15319@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-2.6.21logfs/fs/Kconfig~logfs	2007-08-08 02:57:37.000000000 +0200
+++ linux-2.6.21logfs/fs/Kconfig	2007-08-08 02:57:37.000000000 +0200
@@ -1351,6 +1351,32 @@ config JFFS2_CMODE_SIZE
 
 endchoice
 
+config LOGFS
+	bool "Log Filesystem (EXPERIMENTAL)"
+	depends on MTD && BLOCK && EXPERIMENTAL
+	select ZLIB_INFLATE
+	select ZLIB_DEFLATE
+	help
+	  Flash filesystem aimed to scale efficiently to large devices.
+	  In comparison to JFFS2 it offers significantly faster mount
+	  times and potentially less RAM usage, although the latter has
+	  not been measured yet.
+
+	  In its current state it is still very experimental and should
+	  not be used for other than testing purposes.
+
+	  If unsure, say N.
+
+config LOGFS_FSCK
+	bool "Run LogFS fsck at mount time"
+	depends on LOGFS
+	help
+	  Run a full filesystem check on every mount.  If any errors are
+	  found, mounting the filesystem will fail.  This is a debug option
+	  for developers.
+
+	  If unsure, say N.
+
 config CRAMFS
 	tristate "Compressed ROM file system support (cramfs)"
 	depends on BLOCK
