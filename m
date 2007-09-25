Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbXIYIK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbXIYIK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbXIYIKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:10:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36011 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511AbXIYIKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:10:20 -0400
Date: Tue, 25 Sep 2007 10:10:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rdunlap@xenotime.net, neilb@suse.de, trond.myklebust@fys.uio.no,
       sfrench@samba.org
Subject: [patch 2/2] menuconfig: transform Network Filesystems menu
In-Reply-To: <Pine.LNX.4.64.0709250128510.23305@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0709250132300.23305@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709250128510.23305@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Turn Network File Systems into a menuconfig so that it can be
disabled at once.

(Note: I added a "default y". If you do not like that, speak up.)

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 fs/Kconfig |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

Index: linux-2.6.23/fs/Kconfig
===================================================================
--- linux-2.6.23.orig/fs/Kconfig
+++ linux-2.6.23/fs/Kconfig
@@ -1516,8 +1516,20 @@ config UFS_DEBUG
 
 endmenu
 
-menu "Network File Systems"
+menuconfig NETWORK_FILESYSTEMS
+	bool "Network File Systems"
+	default y
 	depends on NET
+	---help---
+	  Say Y here to get to see options for network filesystems and
+	  filesystem-related networking code, such as NFS daemon and
+	  RPCSEC security modules.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled; if unsure, say Y here.
+
+if NETWORK_FILESYSTEMS
 
 config NFS_FS
 	tristate "NFS file system support"
@@ -2055,7 +2067,7 @@ config 9P_FS
 
 	  If unsure, say N.
 
-endmenu
+endif # NETWORK_FILESYSTEMS
 
 if BLOCK
 menu "Partition Types"
