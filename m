Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbZLZAtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbZLZAtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbZLZAtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:49:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:35988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389AbZLZAtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:49:10 -0500
Date: Sat, 26 Dec 2009 00:48:41 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rankincj@yahoo.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rankincj@yahoo.com
In-Reply-To: <219280.97558.qm@web52907.mail.re2.yahoo.com>
References: <219280.97558.qm@web52907.mail.re2.yahoo.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, compress: Force i386 instructions for the decompressor
Message-ID: <tip-17a2a9b57a9a7d2fd8f97df951b5e63e0bd56ef5@git.kernel.org>
Git-Commit-ID: 17a2a9b57a9a7d2fd8f97df951b5e63e0bd56ef5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17a2a9b57a9a7d2fd8f97df951b5e63e0bd56ef5
Gitweb:     http://git.kernel.org/tip/17a2a9b57a9a7d2fd8f97df951b5e63e0bd56ef5
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 25 Dec 2009 15:40:38 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 25 Dec 2009 15:40:38 -0800

x86, compress: Force i386 instructions for the decompressor

Recently, some distros have started shipping versions of gcc which
default to -march=i686.  This breaks building kernels for pre-i686
machines, even if they have been selected in Kconfig, due to the
generation of CMOV instructions.

There isn't enough benefit to try to preserve the generation of these
instructions even when selected, so simply force -march=i386 for the
decompressor when building a 32-bit kernel.

Reported-and-tested-by: Chris Rankin <rankincj@yahoo.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <219280.97558.qm@web52907.mail.re2.yahoo.com>
---
 arch/x86/boot/compressed/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index f8ed065..f25bbd3 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -9,6 +9,7 @@ targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinu
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
+cflags-$(CONFIG_X86_32) := -march=i386
 cflags-$(CONFIG_X86_64) := -mcmodel=small
 KBUILD_CFLAGS += $(cflags-y)
 KBUILD_CFLAGS += $(call cc-option,-ffreestanding)
