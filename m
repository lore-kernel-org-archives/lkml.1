Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbYEPLzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbYEPLzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYEPLy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:54:59 -0400
Received: from ns.suse.de ([195.135.220.2]:44493 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740AbYEPLy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:54:58 -0400
Date: Fri, 16 May 2008 13:54:59 +0200
From: Jan Blunck <jblunck@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: [PATCH] Don't clean bounds.h and asm-offsets.h
Message-ID: <20080516115457.GH27622@bolzano.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 97965478a66fbdf0f4ad5e4ecc4828f0cb548a45 mmzone.h includes
bounds.h. Calling make clean after make prepare removes bounds.h again so
when building external modules this fails.

Signed-off-by: Jan Blunck <jblunck@suse.de>
--
diff --git a/Kbuild b/Kbuild
index 32f19c5..e750e9c 100644
--- a/Kbuild
+++ b/Kbuild
@@ -96,5 +96,4 @@ missing-syscalls: scripts/checksyscalls.sh FORCE
 	$(call cmd,syscalls)
 
 # Delete all targets during make clean
-clean-files := $(addprefix $(objtree)/,$(targets))
-
+clean-files := $(addprefix $(objtree)/,$(filter-out $(bounds-file) $(offsets-file),$(targets)))
diff --git a/Makefile b/Makefile
index 3140145..c1c9ed1 100644
--- a/Makefile
+++ b/Makefile
@@ -1114,6 +1114,7 @@ MRPROPER_DIRS  += include/config include2 usr/include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
+                  include/linux/bounds.h include/asm*/asm-offsets.h     \
 		  Module.symvers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
