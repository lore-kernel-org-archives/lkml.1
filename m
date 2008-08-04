Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYHDRd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYHDRd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYHDRdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:33:17 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:60472 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbYHDRdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:33:16 -0400
Date: Mon, 4 Aug 2008 13:31:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] KBUILD:  Extend "menuconfig" for modules to simplify Kconfig
 file.
Message-ID: <alpine.LFD.1.10.0808041328440.6174@localhost.localdomain>
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


Given that the init/Kconfig file uses a "menuconfig" directive for
modules already, might as well wrap all the submenu entries in an "if"
to toss all those dependencies.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/init/Kconfig b/init/Kconfig
index 7e6dae1..b678803 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -845,9 +845,10 @@ menuconfig MODULES

 	  If unsure, say Y.

+if MODULES
+
 config MODULE_FORCE_LOAD
 	bool "Forced module loading"
-	depends on MODULES
 	default n
 	help
 	  Allow loading of modules without version information (ie. modprobe
@@ -856,7 +857,6 @@ config MODULE_FORCE_LOAD

 config MODULE_UNLOAD
 	bool "Module unloading"
-	depends on MODULES
 	help
 	  Without this option you will not be able to unload any
 	  modules (note that some modules may not be unloadable
@@ -875,7 +875,6 @@ config MODULE_FORCE_UNLOAD

 config MODVERSIONS
 	bool "Module versioning support"
-	depends on MODULES
 	help
 	  Usually, you have to use modules compiled with your kernel.
 	  Saying Y here makes it sometimes possible to use modules
@@ -886,7 +885,6 @@ config MODVERSIONS

 config MODULE_SRCVERSION_ALL
 	bool "Source checksum for all modules"
-	depends on MODULES
 	help
 	  Modules which contain a MODULE_VERSION get an extra "srcversion"
 	  field inserted into their modinfo section, which contains a
@@ -898,11 +896,12 @@ config MODULE_SRCVERSION_ALL

 config KMOD
 	def_bool y
-	depends on MODULES
 	help
 	  This is being removed soon.  These days, CONFIG_MODULES
 	  implies CONFIG_KMOD, so use that instead.

+endif # MODULES
+
 config STOP_MACHINE
 	bool
 	default y

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
