Return-Path: <linux-kernel-owner+w=401wt.eu-S1946478AbXBIOLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946478AbXBIOLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 09:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946477AbXBIOLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 09:11:45 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:48719 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946472AbXBIOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 09:11:44 -0500
X-Originating-Ip: 74.108.223.9
Date: Fri, 9 Feb 2007 09:10:24 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: introducing conditional submenus in the config process?
Message-ID: <Pine.LNX.4.64.0702090901500.5499@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  i brought this up a while back but nothing was finalized -- is there
sufficient value in being able to select or deselect entire submenus
of features without having to descend into that submenu first?

  as a random example, consider Device Drivers --> MTD support.  as it
stands, i can select or deselect MTD support in its entirety only by
first going into the MTD submenu.  i mentioned before that it would be
far more convenient to have the selection switch on that upper-level
menu entry instead, which you can get with a patch like this:

==================================================
diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 26f75c2..1233602 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -1,8 +1,6 @@
 # $Id: Kconfig,v 1.11 2005/11/07 11:14:19 gleixner Exp $

-menu "Memory Technology Devices (MTD)"
-
-config MTD
+menuconfig MTD
 	tristate "Memory Technology Device (MTD) support"
 	help
 	  Memory Technology Devices are flash, RAM and similar chips, often
@@ -13,6 +11,8 @@ config MTD
 	  them. It will also allow you to select individual drivers for
 	  particular hardware and users of MTD devices. If unsure, say N.

+if MTD
+
 config MTD_DEBUG
 	bool "Debugging"
 	depends on MTD
@@ -292,5 +292,5 @@ source "drivers/mtd/nand/Kconfig"

 source "drivers/mtd/onenand/Kconfig"

-endmenu
+endif
=====================================================

  so the higher level config feature changes from a "config" to a
"menuconfig", then the entire submenu is wrapped in the appropriate
conditional.  this sort of thing could be used in all kinds of places
in the current Kconfig structure to avoid constantly visiting
submenus.

  (as an aside, rather than have to implement this with two Kconfig
features, it might even be worth creating a whole new feature,
something like "submenuconfig" or whatever, that does all this
automatically.)

  thoughts?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
