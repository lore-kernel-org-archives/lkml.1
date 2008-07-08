Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbYGHRMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbYGHRMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYGHRMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:12:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60640 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYGHRMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:12:45 -0400
Message-Id: <20080708170048.633321000@sipsolutions.net>
References: <20080708170015.470877000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jul 2008 19:00:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: [RFC 10/11] remove mention of CONFIG_KMOD from documentation
Content-Disposition: inline; filename=config-kmod-remove-doc.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also includes a few Kconfig files (xtensa, blackfin)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-doc@vger.kernel.org
---
 Documentation/filesystems/bfs.txt                     |   10 +++++-----
 Documentation/sound/alsa/DocBook/alsa-driver-api.tmpl |    2 +-
 Documentation/telephony/ixj.txt                       |   13 +++----------
 Documentation/video4linux/w9968cf.txt                 |    3 ---
 arch/blackfin/Kconfig                                 |    4 ++--
 arch/xtensa/Kconfig                                   |    4 ++--
 6 files changed, 13 insertions(+), 23 deletions(-)

--- everything.orig/Documentation/filesystems/bfs.txt	2008-07-08 18:54:03.000000000 +0200
+++ everything/Documentation/filesystems/bfs.txt	2008-07-08 18:59:25.000000000 +0200
@@ -26,11 +26,11 @@ You can simplify mounting by just typing
 
 this will allocate the first available loopback device (and load loop.o 
 kernel module if necessary) automatically. If the loopback driver is not
-loaded automatically, make sure that your kernel is compiled with kmod 
-support (CONFIG_KMOD) enabled. Beware that umount will not
-deallocate /dev/loopN device if /etc/mtab file on your system is a
-symbolic link to /proc/mounts. You will need to do it manually using
-"-d" switch of losetup(8). Read losetup(8) manpage for more info.
+loaded automatically, make sure that you have compiled the module and
+that modprobe is functioning. Beware that umount will not deallocate
+/dev/loopN device if /etc/mtab file on your system is a symbolic link to
+/proc/mounts. You will need to do it manually using "-d" switch of
+losetup(8). Read losetup(8) manpage for more info.
 
 To create the BFS image under UnixWare you need to find out first which
 slice contains it. The command prtvtoc(1M) is your friend:
--- everything.orig/Documentation/telephony/ixj.txt	2008-07-08 18:54:03.000000000 +0200
+++ everything/Documentation/telephony/ixj.txt	2008-07-08 18:59:25.000000000 +0200
@@ -305,21 +305,14 @@ driver, like this:
 
 which will result in the needed drivers getting loaded automatically.
 
-   g.  if you are planning on using kerneld to automatically load the 
-module for you, then you need to edit /etc/conf.modules and add the 
+   g.  if you are planning on having the kernel automatically request
+the module for you, then you need to edit /etc/conf.modules and add the
 following lines:
 
 	options ixj dspio=0x340 xio=0x330 ixjdebug=0
 
 If you do this, then when you execute an application that uses the
-module kerneld will load the module for you.  Note that to do this,
-you need to have your kernel set to support kerneld.  You can check
-for this by looking at /usr/src/linux/.config and you should see this:
-
-	# Loadable module support
-	#
-	<snip>
-	CONFIG_KMOD=y
+module the kernel will request that it is loaded.
 
   h.  if you want non-root users to be able to read and write to the 
 ixj devices (this is a good idea!) you should do the following:
--- everything.orig/Documentation/video4linux/w9968cf.txt	2008-07-08 18:54:02.000000000 +0200
+++ everything/Documentation/video4linux/w9968cf.txt	2008-07-08 18:59:25.000000000 +0200
@@ -193,9 +193,6 @@ Description:     Automatic 'ovcamchip' m
 		 loads that module automatically. This action is performed as
 		 once soon as the 'w9968cf' module is loaded into memory.
 Default:         1
-Note:            The kernel must be compiled with the CONFIG_KMOD option
-		 enabled for the 'ovcamchip' module to be loaded and for
-		 this parameter to be present.
 -------------------------------------------------------------------------------
 Name:           simcams
 Type:           int
--- everything.orig/Documentation/sound/alsa/DocBook/alsa-driver-api.tmpl	2008-07-08 18:54:03.000000000 +0200
+++ everything/Documentation/sound/alsa/DocBook/alsa-driver-api.tmpl	2008-07-08 18:59:25.000000000 +0200
@@ -42,7 +42,7 @@
      <sect1><title>Device Components</title>
 !Esound/core/device.c
      </sect1>
-     <sect1><title>KMOD and Device File Entries</title>
+     <sect1><title>Module requests and Device File Entries</title>
 !Esound/core/sound.c
      </sect1>
      <sect1><title>Memory Management Helpers</title>
--- everything.orig/arch/blackfin/Kconfig	2008-07-08 18:54:02.000000000 +0200
+++ everything/arch/blackfin/Kconfig	2008-07-08 18:59:25.000000000 +0200
@@ -873,8 +873,8 @@ config HOTPLUG
 	  plugged into slots found on all modern laptop computers.  Another
 	  example, used on modern desktops as well as laptops, is USB.
 
-	  Enable HOTPLUG and KMOD, and build a modular kernel.  Get agent
-	  software (at <http://linux-hotplug.sourceforge.net/>) and install it.
+	  Enable HOTPLUG and build a modular kernel.  Get agent software
+	  (from <http://linux-hotplug.sourceforge.net/>) and install it.
 	  Then your kernel will automatically call out to a user mode "policy
 	  agent" (/sbin/hotplug) to load modules and set up software needed
 	  to use devices as you hotplug them.
--- everything.orig/arch/xtensa/Kconfig	2008-07-08 18:54:02.000000000 +0200
+++ everything/arch/xtensa/Kconfig	2008-07-08 18:59:25.000000000 +0200
@@ -194,8 +194,8 @@ config HOTPLUG
 	plugged into slots found on all modern laptop computers.  Another
 	example, used on modern desktops as well as laptops, is USB.
 
-	Enable HOTPLUG and KMOD, and build a modular kernel.  Get agent
-	software (at <http://linux-hotplug.sourceforge.net/>) and install it.
+	Enable HOTPLUG and build a modular kernel.  Get agent software
+	(from <http://linux-hotplug.sourceforge.net/>) and install it.
 	Then your kernel will automatically call out to a user mode "policy
 	agent" (/sbin/hotplug) to load modules and set up software needed
 	to use devices as you hotplug them.

-- 

