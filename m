Return-Path: <linux-kernel-owner+w=401wt.eu-S966997AbXEGVkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966997AbXEGVkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966651AbXEGVkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:40:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966628AbXEGVkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:40:20 -0400
Message-ID: <463F9C3B.4080004@sandeen.net>
Date: Mon, 07 May 2007 16:38:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: sam@ravnborg.org
Subject: [PATCH] [KBUILD] fix external module install path
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Installing external modules is supposed to put them in some path
under /lib/modules/<version>/extra/subdir/, but this change:
http://linux.bkbits.net:8080/linux-2.6/?PAGE=cset&REV=1.1982.9.23
makes them go under /lib/modules/<version>/extrasubdir

(for example, make M=fs/ext3 modules_install puts ext3.ko in 
/lib/modules/<version>/extrafs/ext3.ko)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6.21/scripts/Makefile.modinst
===================================================================
--- linux-2.6.21.orig/scripts/Makefile.modinst
+++ linux-2.6.21/scripts/Makefile.modinst
@@ -21,7 +21,7 @@ quiet_cmd_modules_install = INSTALL $@
 
 # Modules built outside the kernel source tree go into extra by default
 INSTALL_MOD_DIR ?= extra
-ext-mod-dir = $(INSTALL_MOD_DIR)$(subst $(KBUILD_EXTMOD),,$(@D))
+ext-mod-dir = $(INSTALL_MOD_DIR)/$(subst $(KBUILD_EXTMOD),,$(@D))
 
 modinst_dir = $(if $(KBUILD_EXTMOD),$(ext-mod-dir),kernel/$(@D))
 


