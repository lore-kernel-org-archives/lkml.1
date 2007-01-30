Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbXA3BMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbXA3BMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXA3BLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:11:50 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47387 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752635AbXA3BLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:11:47 -0500
Date: Tue, 30 Jan 2007 02:11:56 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz
Subject: [RFC: -mm patch] CONFIG_INPUT_DEBUG improvements
Message-ID: <20070130011156.GD3754@stusta.de>
References: <20070127234928.64d8e437.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070127234928.64d8e437.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 27, 2007 at 11:49:28PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc4-mm1:
>...
>  git-hid.patch
>...
>  git trees.
>...

This patch contains the following CONFIG_INPUT_DEBUG improvements:
- remove Makefile code for the nonexisting CONFIG_INPUT_DEBUG
- simpler Makefile for hid-debug.o
- replace all HID debug #define's with CONFIG_INPUT_DEBUG

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/hid/Makefile    |   15 ++-------------
 drivers/hid/hid-core.c  |    6 ++----
 drivers/hid/hid-input.c |    6 ++----
 3 files changed, 6 insertions(+), 21 deletions(-)

--- linux-2.6.20-rc6-mm1/drivers/hid/Makefile.old	2007-01-28 23:50:41.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/hid/Makefile	2007-01-29 00:13:22.000000000 +0100
@@ -2,18 +2,7 @@
 # Makefile for the HID driver
 #
 
-# Multipart objects.
-hid-objs	:= hid-core.o hid-input.o
-
-# Optional parts of multipart objects.
-ifeq ($(CONFIG_HID_DEBUG),y)
-hid-objs	+= hid-debug.o
-endif
-
-ifeq ($(CONFIG_INPUT_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
-
-
 obj-$(CONFIG_HID)		+= hid.o
+hid-objs			:= hid-core.o hid-input.o
+hid-$(CONFIG_HID_DEBUG)		+= hid-debug.o
 
--- linux-2.6.20-rc6-mm1/drivers/hid/hid-core.c.old	2007-01-28 23:52:34.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/hid/hid-core.c	2007-01-28 23:53:47.000000000 +0100
@@ -27,8 +27,6 @@
 #include <linux/input.h>
 #include <linux/wait.h>
 
-#undef DEBUG_DATA
-
 #include <linux/hid.h>
 #include <linux/hiddev.h>
 #include <linux/hid-debug.h>
@@ -950,7 +948,7 @@
 		return -1;
 	}
 
-#ifdef DEBUG_DATA
+#ifdef CONFIG_INPUT_DEBUG
 	printk(KERN_DEBUG __FILE__ ": report (size %u) (%snumbered)\n", size, report_enum->numbered ? "" : "un");
 #endif
 
@@ -960,7 +958,7 @@
 		size--;
 	}
 
-#ifdef DEBUG_DATA
+#ifdef CONFIG_INPUT_DEBUG
 	{
 		int i;
 		printk(KERN_DEBUG __FILE__ ": report %d (size %u) = ", n, size);
--- linux-2.6.20-rc6-mm1/drivers/hid/hid-input.c.old	2007-01-28 23:53:56.000000000 +0100
+++ linux-2.6.20-rc6-mm1/drivers/hid/hid-input.c	2007-01-28 23:54:21.000000000 +0100
@@ -31,8 +31,6 @@
 #include <linux/slab.h>
 #include <linux/kernel.h>
 
-#undef DEBUG
-
 #include <linux/hid.h>
 #include <linux/hid-debug.h>
 
@@ -248,7 +246,7 @@
 
 	field->hidinput = hidinput;
 
-#ifdef DEBUG
+#ifdef CONFIG_HID_DEBUG
 	printk(KERN_DEBUG "Mapping: ");
 	hid_resolv_usage(usage->hid);
 	printk(" ---> ");
@@ -685,7 +683,7 @@
 	return;
 
 ignore:
-#ifdef DEBUG
+#ifdef CONFIG_HID_DEBUG
 	printk("IGNORED\n");
 #endif
 	return;
