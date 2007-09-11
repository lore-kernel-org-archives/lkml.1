Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbXIKMDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbXIKMDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763033AbXIKMCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:02:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:37495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763683AbXIKMCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:02:13 -0400
From: Andi Kleen <ak@suse.de>
References: <20070911202.911586000@suse.de>
In-Reply-To: <20070911202.911586000@suse.de>
To: sam@ravnborg.org, bcrl@kvack.org, torvalds@osdl.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.23] [3/3] i386: Fix leak of ../kernel from top level
Message-Id: <20070911120212.2FAA414EEC@wotan.suse.de>
Date: Tue, 11 Sep 2007 14:02:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a compile error when the directory above the kernel source contains
a file named "kernel". Originally from Ben La Haise, modified based
on feedback from Sam Ravnborg

Cc: sam@ravnborg.org
Cc: bcrl@kvack.org

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/mach-generic/Makefile
===================================================================
--- linux.orig/arch/i386/mach-generic/Makefile
+++ linux/arch/i386/mach-generic/Makefile
@@ -2,6 +2,6 @@
 # Makefile for the generic architecture
 #
 
-EXTRA_CFLAGS	+= -I../kernel
+EXTRA_CFLAGS	:= -Iarch/i386/kernel
 
 obj-y				:= probe.o summit.o bigsmp.o es7000.o default.o ../mach-es7000/
Index: linux/arch/i386/mach-voyager/Makefile
===================================================================
--- linux.orig/arch/i386/mach-voyager/Makefile
+++ linux/arch/i386/mach-voyager/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-EXTRA_CFLAGS	+= -I../kernel
+EXTRA_CFLAGS	:= -Iarch/i386/kernel
 obj-y			:= setup.o voyager_basic.o voyager_thread.o
 
 obj-$(CONFIG_SMP)	+= voyager_smp.o voyager_cat.o
