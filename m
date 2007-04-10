Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXDJVXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXDJVXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXDJVXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:23:48 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:50415 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbXDJVXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:23:47 -0400
Date: Tue, 10 Apr 2007 23:22:07 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jens Axboe <axboe@kernel.dk>, Rusty Russell <rusty@rustcorp.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH 15/30] Use menuconfig objects - module menu
In-Reply-To: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102318520.32056@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Use menuconfigs instead of menus, so the whole menu can be disabled at        
once instead of going through all options.

This one also touches the block menu, so needs to go handinhand with 
[PATCH 04/30] Use meunconfig objects - block. (I just noticed now - 
sorry)

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/init/Kconfig
===================================================================
--- linux-2.6.21-rc5.orig/init/Kconfig
+++ linux-2.6.21-rc5/init/Kconfig
@@ -511,9 +511,7 @@ config SLOB
 	default !SLAB
 	bool
 
-menu "Loadable module support"
-
-config MODULES
+menuconfig MODULES
 	bool "Enable loadable module support"
 	help
 	  Kernel modules are small pieces of compiled code which can
@@ -593,8 +591,5 @@ config STOP_MACHINE
 	depends on (SMP && MODULE_UNLOAD) || HOTPLUG_CPU
 	help
 	  Need stop_machine() primitive.
-endmenu
 
-menu "Block layer"
 source "block/Kconfig"
-endmenu
#<EOF>
