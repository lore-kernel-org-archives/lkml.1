Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbYFIWgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbYFIWgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761308AbYFIWeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:34:01 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:26395 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761231AbYFIWeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=Fol4kUdT/svquizgbrF+yuX4XZLy3MvkuxpRgDWRb/D4/dGe2OyanmVlDQhhEMl91O
         K2Q3bqG9lTyqzXwco5oBpT5voisdsw5jOR5AFxQYcVz7B1NmJaiLCHUhCWBbCFoK1DSv
         LOA7i+FBYa11sAcNyqomV9yxY0f/6dWIrH1WU=
To: linux-kernel@vger.kernel.org
Subject: [patch 06/21] perfmon2 minimal:  X86 generic hooks
From: eranian@googlemail.com
Date: Mon, 09 Jun 2008 15:33:58 -0700 (PDT)
Message-ID: <484dafd6.0407560a.301b.6595@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the generic X86 hooks to support perfmon2.
And in particular the Makefile and header file export.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: o/arch/x86/Makefile
===================================================================
--- o.orig/arch/x86/Makefile	2008-06-02 18:53:33.000000000 +0200
+++ o/arch/x86/Makefile	2008-06-02 18:54:41.000000000 +0200
@@ -176,6 +176,8 @@
 core-y += arch/x86/kernel/
 core-y += arch/x86/mm/
 
+core-$(CONFIG_PERFMON) += arch/x86/perfmon/
+
 # Remaining sub architecture files
 core-y += $(mcore-y)
 
Index: o/include/asm-x86/Kbuild
===================================================================
--- o.orig/include/asm-x86/Kbuild	2008-06-02 18:53:33.000000000 +0200
+++ o/include/asm-x86/Kbuild	2008-06-02 18:54:41.000000000 +0200
@@ -11,6 +11,7 @@
 header-y += sigcontext32.h
 header-y += ucontext.h
 header-y += processor-flags.h
+header-y += perfmon.h
 
 unifdef-y += e820.h
 unifdef-y += ist.h
Index: o/arch/x86/Kconfig
===================================================================
--- o.orig/arch/x86/Kconfig	2008-06-02 18:53:33.000000000 +0200
+++ o/arch/x86/Kconfig	2008-06-02 18:54:41.000000000 +0200
@@ -1306,6 +1306,8 @@
 
 	  If unsure, say Y.
 
+source "arch/x86/perfmon/Kconfig"
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG

-- 

