Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbXHWX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbXHWX3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761553AbXHWX3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:29:00 -0400
Received: from kanga.kvack.org ([66.96.29.28]:32791 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761261AbXHWX27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:28:59 -0400
Date: Thu, 23 Aug 2007 19:28:47 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH i386] fix leak of ../kernel from top level directory in Makefile
Message-ID: <20070823232847.GL19267@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compile time error that results in the kernel being 
unable to compile due to a reference to ../kernel from the top level 
directory of the kernel source if a file ../kernel exists outside of the 
kernel tree.

		-ben

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
diff --git a/arch/i386/mach-generic/Makefile b/arch/i386/mach-generic/Makefile
index 77fbc9f..bd23339 100644
--- a/arch/i386/mach-generic/Makefile
+++ b/arch/i386/mach-generic/Makefile
@@ -2,6 +2,6 @@
 # Makefile for the generic architecture
 #
 
-EXTRA_CFLAGS	+= -I../kernel
+EXTRA_CFLAGS	+= -I$(TOPDIR)/arch/i386/kernel
 
 obj-y				:= probe.o summit.o bigsmp.o es7000.o default.o ../mach-es7000/
diff --git a/arch/i386/mach-voyager/Makefile b/arch/i386/mach-voyager/Makefile
index f24d296..78898b7 100644
--- a/arch/i386/mach-voyager/Makefile
+++ b/arch/i386/mach-voyager/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-EXTRA_CFLAGS	+= -I../kernel
+EXTRA_CFLAGS	+= -I$(TOPDIR)/arch/i386/kernel
 obj-y			:= setup.o voyager_basic.o voyager_thread.o
 
 obj-$(CONFIG_SMP)	+= voyager_smp.o voyager_cat.o
