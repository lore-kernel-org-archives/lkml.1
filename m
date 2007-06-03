Return-Path: <linux-kernel-owner+w=401wt.eu-S1751414AbXFCSou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbXFCSou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbXFCSol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:44:41 -0400
Received: from lazybastard.de ([212.112.238.170]:59668 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbXFCSok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:44:40 -0400
Date: Sun, 3 Jun 2007 20:40:03 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Cc: akpm@osdl.org, Sam Ravnborg <sam@ravnborg.org>,
       John Stoffel <john@stoffel.org>, David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Arnd Bergmann <arnd@arndb.de>,
       Willy Tarreau <w@1wt.eu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Bill Davidsen <davidsen@tmr.com>, Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
Subject: [Patch 01/18] fs/Kconfig
Message-ID: <20070603184002.GB8952@lazybastard.org>
References: <20070603183845.GA8952@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070603183845.GA8952@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- linux-2.6.21logfs/fs/Kconfig~logfs	2007-06-03 19:18:57.000000000 +0200
+++ linux-2.6.21logfs/fs/Kconfig	2007-06-03 19:18:57.000000000 +0200
@@ -1351,6 +1351,32 @@ config JFFS2_CMODE_SIZE
 
 endchoice
 
+config LOGFS
+	tristate "Log Filesystem (EXPERIMENTAL)"
+	depends on MTD && EXPERIMENTAL
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
