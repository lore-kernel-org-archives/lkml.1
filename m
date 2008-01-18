Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYARDlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYARDlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 22:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYARDlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 22:41:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:26011 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbYARDlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 22:41:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=twFiRZJ3++B2pjUYr+Cn8s9HNxTqIl2ChXpEteRN3BM0p39eSkFHMrn+QibccjU72Jxf5+cdXhFfE+/BuuaM2yEoImHJWy4pjULKmS2nVxg9ZvSLI9fGshAPoyxdZ7ANnqEb/rbARp5EYZy4NMPQ8OaBIqs7MIONo/BWP4fjHCA=
Message-ID: <47901FE9.9020403@gmail.com>
Date: Fri, 18 Jan 2008 06:41:29 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_32: remove the useless NR_syscalls macro
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is against current x86.git.

The size of the system call table for 32-bit x86 kernels is obtained by
compile-time calculation of the sys_call_table array, not from the value,
which the NR_syscalls macro expands to. This trivial patch removes the
fossil macro.

Manually tested by grepping the x86 files for the "NR_syscalls" string.
No relevant use cases found.

Build-tested using allyesconfig, allnoconfig and a couple of randconfig
instances. All builds successfully finished.

Runtime test performed using a stripped-down Debian-ish config. The system
booted successfully.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 include/asm-x86/unistd_32.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 9b15545..8d8f9b5 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -333,8 +333,6 @@ #define __NR_fallocate		324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 325
-
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
-- 
1.4.1
