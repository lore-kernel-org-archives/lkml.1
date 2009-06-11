Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZFKCqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZFKCqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZFKCqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:46:36 -0400
Received: from louise.pinerecords.com ([213.168.176.16]:60110 "EHLO
	louise.pinerecords.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZFKCqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:46:35 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jun 2009 22:46:35 EDT
Date: Thu, 11 Jun 2009 04:46:30 +0200
From: =?utf-8?B?VG9tw6HFoSBTesOpcGU=?= <szepe@pinerecords.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [2.6.29.x+ FIX] CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK
Message-ID: <20090611024630.GA24852@louise.pinerecords.com>
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
Patch against 2.6.29.*, 2.6.30, current.

inlined please find a trivial fix that makes it possible to run
complete systems out of an initramfs on current kernels again
(this last worked on 2.6.27.*).

-- 
Tomáš Szépe <szepe@pinerecords.com>

diff -urN a/fs/Kconfig b/fs/Kconfig
--- a/fs/Kconfig	2009-06-10 05:05:27 +0200
+++ b/fs/Kconfig	2009-06-11 03:50:50 +0200
@@ -39,6 +39,13 @@
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
@@ -47,13 +54,6 @@
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
