Return-Path: <linux-kernel-owner+w=401wt.eu-S1767382AbXECEyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767382AbXECEyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767386AbXECEys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:54:48 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:41106 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767382AbXECEys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:54:48 -0400
Date: Thu, 3 May 2007 14:54:46 +1000
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: [LGUEST] Look in object dir for .config
Message-ID: <20070503045446.GG15955@bakeyournoodle.com>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel ML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Breeds <tony@bakeyournoodle.com>

[LGUEST] Look in object dir for .config

If you build with make O=.... then .config isn't in ../../, this patch
goes partway to making sure that you don't dirty the source tree.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---
 Documentation/lguest/Makefile |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- Documentation/lguest/Makefile.orig	2007-05-03 14:23:07.000000000 +1000
+++ Documentation/lguest/Makefile	2007-05-03 14:25:27.000000000 +1000
@@ -1,8 +1,15 @@
 # This creates the demonstration utility "lguest" which runs a Linux guest.
 
+# For those people that have a separate object dir, look there for .config
+KBUILD_OUTPUT := ../..
+ifdef O
+  ifeq ("$(origin O)", "command line")
+    KBUILD_OUTPUT := $(O)
+  endif
+endif
 # We rely on CONFIG_PAGE_OFFSET to know the highest address we can put
 # the lguest binary.
-include ../../.config
+include $(KBUILD_OUTPUT)/.config
 LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)
 
 CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 \

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!
