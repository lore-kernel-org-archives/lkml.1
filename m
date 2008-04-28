Return-Path: <linux-kernel-owner+w=401wt.eu-S1765421AbYD1F7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765421AbYD1F7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763017AbYD1F7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:59:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43490 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762306AbYD1F7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:59:08 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ia64 kvm fixes for O=... builds
Cc: linux-kernel@vger.kernel.org, kvm-ia64-devel@lists.sourceforge.net,
       sfr@canb.auug.org.au
Message-Id: <E1JqMOH-0004ky-VF@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 28 Apr 2008 06:59:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* EXTRA_CFLAGS do not apply for *.S
* don't bother with symlinks to ../lib/mem*.S, just add ../lib/mem*.o
  to object list

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/ia64/kvm/Makefile |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kvm/Makefile b/arch/ia64/kvm/Makefile
index 41b034f..5235339 100644
--- a/arch/ia64/kvm/Makefile
+++ b/arch/ia64/kvm/Makefile
@@ -42,10 +42,7 @@ $(obj)/$(offsets-file): arch/ia64/kvm/asm-offsets.s
 #
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/ia64/kvm/
-
-$(addprefix $(objtree)/,$(obj)/memcpy.S $(obj)/memset.S):
-	$(shell ln -snf ../lib/memcpy.S $(src)/memcpy.S)
-	$(shell ln -snf ../lib/memset.S $(src)/memset.S)
+EXTRA_AFLAGS += -Ivirt/kvm -Iarch/ia64/kvm/
 
 common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o)
 
@@ -57,5 +54,5 @@ EXTRA_CFLAGS_vcpu.o += -mfixed-range=f2-f5,f12-f127
 kvm-intel-objs = vmm.o vmm_ivt.o trampoline.o vcpu.o optvfault.o mmio.o \
 	vtlb.o process.o
 #Add link memcpy and memset to avoid possible structure assignment error
-kvm-intel-objs += memset.o memcpy.o
+kvm-intel-objs += ../lib/memset.o ../lib/memcpy.o
 obj-$(CONFIG_KVM_INTEL) += kvm-intel.o
-- 
1.5.3.GIT


