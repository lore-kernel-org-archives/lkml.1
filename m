Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbZFKCrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbZFKCrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZFKCri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:47:38 -0400
Received: from louise.pinerecords.com ([213.168.176.16]:60121 "EHLO
	louise.pinerecords.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbZFKCrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:47:37 -0400
Date: Thu, 11 Jun 2009 04:40:19 +0200
From: =?utf-8?B?VG9tw6HFoSBTesOpcGU=?= <szepe@pinerecords.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [2.6.28.x FIX] CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK
Message-ID: <20090611024019.GC25384@louise.pinerecords.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Fix: CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK.
Patch against 2.6.28.10.

inlined please find a trivial fix that makes it possible to run
complete systems out of an initramfs on 2.6.28.10 again (this
broke somewhere between 2.6.27 and 2.6.28).

-- 
Tomáš Szépe <szepe@pinerecords.com>

diff -urN a/fs/Kconfig b/fs/Kconfig
--- a/fs/Kconfig	2008-12-25 00:26:37 +0100
+++ b/fs/Kconfig	2009-06-11 04:23:12 +0200
@@ -172,14 +172,6 @@
 	bool
 	default n
 
-config FILE_LOCKING
-	bool "Enable POSIX file locking API" if EMBEDDED
-	default y
-	help
-	  This option enables standard file locking support, required
-          for filesystems like NFS and for the flock() system
-          call. Disabling this option saves about 11k.
-
 source "fs/xfs/Kconfig"
 source "fs/gfs2/Kconfig"
 
@@ -270,6 +262,14 @@
 
 endif # BLOCK
 
+config FILE_LOCKING
+	bool "Enable POSIX file locking API" if EMBEDDED
+	default y
+	help
+	  This option enables standard file locking support, required
+          for filesystems like NFS and for the flock() system
+          call. Disabling this option saves about 11k.
+
 config DNOTIFY
 	bool "Dnotify support"
 	default y
