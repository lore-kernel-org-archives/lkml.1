Return-Path: <linux-kernel-owner+w=401wt.eu-S1761429AbZDSNmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429AbZDSNmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760704AbZDSNl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:41:27 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:39000 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311AbZDSNlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:41:21 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH 03/10] kconfig: resort the documentation of the environment variables
Date: Sun, 19 Apr 2009 15:41:20 +0200
Message-Id: <1240148487-27584-4-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.rc1.24.g467d50
In-Reply-To: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
References: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX1+7OFhoY2dEvk2btjTqfwPekHObFsAdR2H9bDlN
	Q9L++GYbUDjIjkOBr43nMPCUZyWbXwM17pE8EytHafPT769L+M
	HGRCHqF9bwjb8PkGOvaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the KCONFIG_ environment variables were previously located in a
section "Environment variables in 'menuconfig'", but neither are they
restricted to 'menuconfig' nor are they all used by 'menuconfig'.

Introduce the following three sections for these variables:
  * Environment variables for '*config'
  * Environment variables for '{allyes/allmod/allno/rand}config'
  * Environment variables for 'silentoldconfig'

Furthermore this puts MENUCONFIG_MODE next to MENUCONFIG_COLOR into a
common section "User interface options for 'menuconfig'".

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
---
 Documentation/kbuild/kconfig.txt |  116 +++++++++++++++++++------------------
 1 files changed, 60 insertions(+), 56 deletions(-)

diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
index 26a7c0a..849b5e5 100644
--- a/Documentation/kbuild/kconfig.txt
+++ b/Documentation/kbuild/kconfig.txt
@@ -35,48 +35,26 @@ new .config files to see the differences:
 
 (Yes, we need something better here.)
 
-
-======================================================================
-menuconfig
---------------------------------------------------
-
-SEARCHING for CONFIG symbols
-
-Searching in menuconfig:
-
-	The Search function searches for kernel configuration symbol
-	names, so you have to know something close to what you are
-	looking for.
-
-	Example:
-		/hotplug
-		This lists all config symbols that contain "hotplug",
-		e.g., HOTPLUG, HOTPLUG_CPU, MEMORY_HOTPLUG.
-
-	For search help, enter / followed TAB-TAB-TAB (to highlight
-	<Help>) and Enter.  This will tell you that you can also use
-	regular expressions (regexes) in the search string, so if you
-	are not interested in MEMORY_HOTPLUG, you could try
-
-		/^hotplug
-
-
 ______________________________________________________________________
-Color Themes for 'menuconfig'
+Environment variables for '*config'
 
-It is possible to select different color themes using the variable
-MENUCONFIG_COLOR.  To select a theme use:
+KCONFIG_CONFIG
+--------------------------------------------------
+This environment variable can be used to specify a default kernel config
+file name to override the default name of ".config".
 
-	make MENUCONFIG_COLOR=<theme> menuconfig
+KCONFIG_OVERWRITECONFIG
+--------------------------------------------------
+If you set KCONFIG_OVERWRITECONFIG in the environment, Kconfig will not
+break symlinks when .config is a symlink to somewhere else.
 
-Available themes are:
-  mono       => selects colors suitable for monochrome displays
-  blackbg    => selects a color scheme with black background
-  classic    => theme with blue background. The classic look
-  bluetitle  => a LCD friendly version of classic. (default)
+KCONFIG_NOTIMESTAMP
+--------------------------------------------------
+If this environment variable exists and is non-null, the timestamp line
+in generated .config files is omitted.
 
 ______________________________________________________________________
-Environment variables in 'menuconfig'
+Environment variables for '{allyes/allmod/allno/rand}config'
 
 KCONFIG_ALLCONFIG
 --------------------------------------------------
@@ -95,8 +73,7 @@ values.
 This enables you to create "miniature" config (miniconfig) or custom
 config files containing just the config symbols that you are interested
 in.  Then the kernel config system generates the full .config file,
-including dependencies of your miniconfig file, based on the miniconfig
-file.
+including symbols of your miniconfig file.
 
 This 'KCONFIG_ALLCONFIG' file is a config file which contains
 (usually a subset of all) preset config symbols.  These variable
@@ -113,26 +90,14 @@ These examples will disable most options (allnoconfig) but enable or
 disable the options that are explicitly listed in the specified
 mini-config files.
 
+______________________________________________________________________
+Environment variables for 'silentoldconfig'
+
 KCONFIG_NOSILENTUPDATE
 --------------------------------------------------
 If this variable has a non-blank value, it prevents silent kernel
 config udpates (requires explicit updates).
 
-KCONFIG_CONFIG
---------------------------------------------------
-This environment variable can be used to specify a default kernel config
-file name to override the default name of ".config".
-
-KCONFIG_OVERWRITECONFIG
---------------------------------------------------
-If you set KCONFIG_OVERWRITECONFIG in the environment, Kconfig will not
-break symlinks when .config is a symlink to somewhere else.
-
-KCONFIG_NOTIMESTAMP
---------------------------------------------------
-If this environment variable exists and is non-null, the timestamp line
-in generated .config files is omitted.
-
 KCONFIG_AUTOCONFIG
 --------------------------------------------------
 This environment variable can be set to specify the path & name of the
@@ -143,15 +108,54 @@ KCONFIG_AUTOHEADER
 This environment variable can be set to specify the path & name of the
 "autoconf.h" (header) file.  Its default value is "include/linux/autoconf.h".
 
+
+======================================================================
+menuconfig
+--------------------------------------------------
+
+SEARCHING for CONFIG symbols
+
+Searching in menuconfig:
+
+	The Search function searches for kernel configuration symbol
+	names, so you have to know something close to what you are
+	looking for.
+
+	Example:
+		/hotplug
+		This lists all config symbols that contain "hotplug",
+		e.g., HOTPLUG, HOTPLUG_CPU, MEMORY_HOTPLUG.
+
+	For search help, enter / followed TAB-TAB-TAB (to highlight
+	<Help>) and Enter.  This will tell you that you can also use
+	regular expressions (regexes) in the search string, so if you
+	are not interested in MEMORY_HOTPLUG, you could try
+
+		/^hotplug
+
 ______________________________________________________________________
-menuconfig User Interface Options
-----------------------------------------------------------------------
+User interface options for 'menuconfig'
+
+MENUCONFIG_COLOR
+--------------------------------------------------
+It is possible to select different color themes using the variable
+MENUCONFIG_COLOR.  To select a theme use:
+
+	make MENUCONFIG_COLOR=<theme> menuconfig
+
+Available themes are:
+  mono       => selects colors suitable for monochrome displays
+  blackbg    => selects a color scheme with black background
+  classic    => theme with blue background. The classic look
+  bluetitle  => a LCD friendly version of classic. (default)
+
 MENUCONFIG_MODE
 --------------------------------------------------
 This mode shows all sub-menus in one large tree.
 
 Example:
-	MENUCONFIG_MODE=single_menu make menuconfig
+	make MENUCONFIG_MODE=single_menu menuconfig
+
 
 ======================================================================
 xconfig
-- 
1.6.3.rc1.24.g467d50

