Return-Path: <linux-kernel-owner+w=401wt.eu-S1423304AbXBPGKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423304AbXBPGKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423308AbXBPGKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:10:01 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:55395 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423304AbXBPGKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:10:00 -0500
Date: Thu, 15 Feb 2007 22:09:57 -0800 (PST)
From: Zwane Mwaikambo <zwane@infradead.org>
Subject: [PATCH] Fix modular AGPGART (ia64 allmodconfig)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <Pine.LNX.4.64.0702152151460.12615@montezuma.fsmlabs.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My previous compat AGP patch broke modular AGPGART.

Test built on;

i386 CONFIG_AGP=y,m
x86_64 CONFIG_AGP=y
ia64 CONFIG_AGP=m

Signed-off-by: Zwane Mwaikambo <zwane@infradead.org>

Index: linux-2.6.20-mm1-ia64/drivers/char/agp/Makefile
===================================================================
RCS file: /home/cvsroot/linux-2.6.20-mm1/drivers/char/agp/Makefile,v
retrieving revision 1.1.1.1
diff -u -p -B -r1.1.1.1 Makefile
--- linux-2.6.20-mm1-ia64/drivers/char/agp/Makefile	15 Feb 2007 17:35:27 -0000	1.1.1.1
+++ linux-2.6.20-mm1-ia64/drivers/char/agp/Makefile	16 Feb 2007 05:47:27 -0000
@@ -1,7 +1,10 @@
 agpgart-y := backend.o frontend.o generic.o isoch.o
 
+ifeq ($(CONFIG_COMPAT),y)
+agpgart-y			+= compat_ioctl.o
+endif
+
 obj-$(CONFIG_AGP)		+= agpgart.o
-obj-$(CONFIG_COMPAT)		+= compat_ioctl.o
 obj-$(CONFIG_AGP_ALI)		+= ali-agp.o
 obj-$(CONFIG_AGP_ATI)		+= ati-agp.o
 obj-$(CONFIG_AGP_AMD)		+= amd-k7-agp.o
