Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYGZNWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYGZNWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYGZNWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:22:18 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:40257 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYGZNWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:22:17 -0400
Date: Sat, 26 Jul 2008 09:20:49 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] FILESYSTEMS: Make "advanced partitions" immediately
 unselectable.
Message-ID: <alpine.LFD.1.10.0807241135540.5289@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use "menuconfig" to allow all advanced partitions to be deselectable
from the top-level FS menu.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

 fs/Kconfig            |    4 ----
 fs/partitions/Kconfig |    9 +++++++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 37db79a..f06241f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -2143,11 +2143,7 @@ config 9P_FS
 endif # NETWORK_FILESYSTEMS

 if BLOCK
-menu "Partition Types"
-
 source "fs/partitions/Kconfig"
-
-endmenu
 endif

 source "fs/nls/Kconfig"
diff --git a/fs/partitions/Kconfig b/fs/partitions/Kconfig
index cb5f0a3..4bb87d2 100644
--- a/fs/partitions/Kconfig
+++ b/fs/partitions/Kconfig
@@ -1,8 +1,9 @@
 #
 # Partition configuration
 #
-config PARTITION_ADVANCED
-	bool "Advanced partition selection"
+
+menuconfig PARTITION_ADVANCED
+	bool "Advanced partition support"
 	help
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned under an operating system running on a different
@@ -14,6 +15,8 @@ config PARTITION_ADVANCED

 	  If unsure, say N.

+if PARTITION_ADVANCED
+
 config ACORN_PARTITION
 	bool "Acorn partition support" if PARTITION_ADVANCED
 	default y if ARCH_ACORN
@@ -249,3 +252,5 @@ config SYSV68_PARTITION
 	  partition table format used by Motorola Delta machines (using
 	  sysv68).
 	  Otherwise, say N.
+
+endif # PARTITION_ADVANCED

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
