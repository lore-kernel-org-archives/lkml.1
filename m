Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbXL2Ull@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbXL2Ull (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 15:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbXL2UlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 15:41:19 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:38790 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbXL2UlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 15:41:18 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@saturn.ravnborg.org>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>
Subject: [PATCH 2/5] x86: share more options between 32 and 64 bit build
Date: Sat, 29 Dec 2007 21:41:13 +0100
Message-Id: <1198960876-21159-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <1198960876-21159-1-git-send-email-sam@ravnborg.org>
References: <20071229203836.GA21020@uranus.ravnborg.org>
 <1198960876-21159-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@saturn.ravnborg.org>

On recommendation from Andi Kleen share a few more options
between 32 and 64 bit builds.
A defconfig build for i386 did not show any difference in
size of text and data.

The additional shared options are:
-Wno-sign-compare
-fno-asynchronous-unwind-tables
-mno-sse
-mno-mmx
-mno-sse2
-mno-3dnow

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
---
 arch/x86/Makefile |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index e5fbad6..4124df5 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -64,14 +64,10 @@ else
         KBUILD_CFLAGS += -mno-red-zone
         KBUILD_CFLAGS += -mcmodel=kernel
 
-        KBUILD_CFLAGS += -Wno-sign-compare
-        KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
         # -funit-at-a-time shrinks the kernel .text considerably
         # unfortunately it makes reading oopses harder.
         KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)
 
-        # prevent gcc from generating any FP code by mistake
-        KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
         # this works around some issues with generating unwind tables in older gccs
         # newer gccs do it by default
         KBUILD_CFLAGS += -maccumulate-outgoing-args
@@ -98,7 +94,15 @@ KBUILD_CFLAGS += $(cfi) $(cfi-sigframe)
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 OBJCOPYFLAGS := -O binary -R .note -R .comment -S
+
+# Speed up the build
 KBUILD_CFLAGS += -pipe
+# Workaround for a gcc prelease that unfortunately was shipped in a suse release
+KBUILD_CFLAGS += -Wno-sign-compare
+#
+KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
+# prevent gcc from generating any FP code by mistake
+KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 
 ###
 # Sub architecture support
-- 
1.5.3.7.1112.g9758e

