Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZEHIna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZEHIna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbZEHInV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:43:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54723 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZEHInT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:43:19 -0400
Date: Fri, 8 May 2009 04:42:53 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jdike@addtoit.com, sam@ravnborg.org, Amerigo Wang <amwang@redhat.com>,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20090508084349.6229.72810.sendpatchset@localhost.localdomain>
Subject: [PATCH] uml: fix a section warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I compiled uml on x86_64, I got this warning:

  MODPOST vmlinux.o
WARNING: vmlinux.o (.__syscall_stub.2): unexpected non-allocatable section.
Did you forget to use "ax"/"aw" in a .S file?
Note that for example <linux/init.h> contains
section definitions for use in .S files.

Because modpost checks for missing SHF_ALLOC section flag. So just
add it. :)

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

---
diff --git a/arch/um/sys-x86_64/stub.S b/arch/um/sys-x86_64/stub.S
index 6d9edf9..20e4a96 100644
--- a/arch/um/sys-x86_64/stub.S
+++ b/arch/um/sys-x86_64/stub.S
@@ -1,7 +1,7 @@
 #include "as-layout.h"
 
 	.globl syscall_stub
-.section .__syscall_stub, "x"
+.section .__syscall_stub, "ax"
 syscall_stub:
 	syscall
 	/* We don't have 64-bit constants, so this constructs the address
diff --git a/arch/um/sys-i386/stub.S b/arch/um/sys-i386/stub.S
index c41b04b..54a36ec 100644
--- a/arch/um/sys-i386/stub.S
+++ b/arch/um/sys-i386/stub.S
@@ -1,7 +1,7 @@
 #include "as-layout.h"
 
 	.globl syscall_stub
-.section .__syscall_stub, "x"
+.section .__syscall_stub, "ax"
 
 	.globl batch_syscall_stub
 batch_syscall_stub:
