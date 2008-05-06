Return-Path: <linux-kernel-owner+w=401wt.eu-S932686AbYEFXFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbYEFXFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYEFXFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:05:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbYEFXFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:05:06 -0400
Date: Tue, 6 May 2008 19:04:43 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805062304.m46N4h6d007206@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH] fix UML on x86-64
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch breaks UML for me on x86-64 running Fedora 8 (gcc 4.1.2):

commit 22eecde2f9034764a3fd095eecfa3adfb8ec9a98
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu May 1 12:06:54 2008 +0200

    uml: fix gcc problem
    
    this is what caused gcc 4.3 to throw an internal error when
    OPTIMIZE_INLINING was enabled ...
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


If you want to use the option for gcc 4.3 then do it, but only for those
versions.  I haven't tested whether gcc 4.2 and 4.3 works, I just know
that gcc 4.1.2 needs the option for some reason.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 01b97c1..3f52a8c 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -77,9 +77,9 @@ include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
 KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
 			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
-# Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
+# Disable unit-at-a-time mode on pre-gcc-4.3 compilers, it makes gcc use
 # a lot more stack due to the lack of sharing of stacklots:
-KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
+KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0430 ] ; then \
 			echo $(call cc-option,-fno-unit-at-a-time); fi ;)
 
 PHONY += linux
