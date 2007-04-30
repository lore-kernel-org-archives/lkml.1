Return-Path: <linux-kernel-owner+w=401wt.eu-S1031095AbXD3LrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031095AbXD3LrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031093AbXD3LrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:47:08 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:51607 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030924AbXD3LrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:47:07 -0400
Date: Mon, 30 Apr 2007 13:46:47 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/36] Use menuconfig objects II - oprofile
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301345550.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 arch/i386/Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- linux-2.6.21-mm_20070428.orig/arch/i386/Kconfig
+++ linux-2.6.21-mm_20070428/arch/i386/Kconfig
@@ -1210,8 +1210,12 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
-menu "Instrumentation Support"
+menuconfig INSTRUMENTATION
+	bool "Instrumentation Support"
 	depends on EXPERIMENTAL
+	default y
+
+if INSTRUMENTATION
 
 source "arch/i386/oprofile/Kconfig"
 
@@ -1227,7 +1231,7 @@ config KPROBES
 
 source "kernel/Kconfig.marker"
 
-endmenu
+endif # INSTRUMENTATION
 
 source "arch/i386/Kconfig.debug"
 
