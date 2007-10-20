Return-Path: <linux-kernel-owner+w=401wt.eu-S1765779AbXJTSq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765779AbXJTSq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbXJTSqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:46:21 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37971 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbXJTSqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:46:20 -0400
Date: Sat, 20 Oct 2007 20:47:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] restore arch/ppc/boot cflags
Message-ID: <20071020184753.GA8572@uranus.ravnborg.org>
References: <200710200858.l9K8w3Nn064775@sullivan.realtime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710200858.l9K8w3Nn064775@sullivan.realtime.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 03:58:03AM -0500, Milton Miller wrote:
> Commit 9a39e273d4df0560c724c5fe71f6314a0583ca2b removed the boot directory
> addition to CFLAGS that was being used by the subdirectory builds.  For the
> other files, that patch set EXTRA_CFLAGS, but Makefile.build explicitly
> sets that to empty as it is explicitly for a single directory only.
> Append to KBUILD_CFLAGS instead.

Neat - I had not figured out that the assignmnet took effect
recursively.
I have applied following patch.

	Sam

>From 437374e9a95062fe310b901e48585691edaf5dd0 Mon Sep 17 00:00:00 2001
From: Milton Miller <miltonm@bga.com>
Date: Sat, 20 Oct 2007 03:58:03 -0500
Subject: [PATCH] kbuild: restore arch/{ppc/xtensa}/boot cflags

Commit 9a39e273d4df0560c724c5fe71f6314a0583ca2b removed the boot directory
addition to CFLAGS that was being used by the subdirectory builds.  For the
other files, that patch set EXTRA_CFLAGS, but Makefile.build explicitly
sets that to empty as it is explicitly for a single directory only.
Append to KBUILD_CFLAGS instead.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/ppc/boot/Makefile    |    2 ++
 arch/xtensa/boot/Makefile |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/ppc/boot/Makefile b/arch/ppc/boot/Makefile
index 487dc66..500497e 100644
--- a/arch/ppc/boot/Makefile
+++ b/arch/ppc/boot/Makefile
@@ -13,6 +13,8 @@
 # modified by Cort (cort@cs.nmt.edu)
 #
 
+# KBUILD_CFLAGS used when building rest of boot (takes effect recursively)
+KBUILD_CFLAGS 	+= -fno-builtin -D__BOOTER__ -Iarch/$(ARCH)/boot/include
 HOSTCFLAGS	+= -Iarch/$(ARCH)/boot/include
 
 BOOT_TARGETS	= zImage zImage.initrd znetboot znetboot.initrd
diff --git a/arch/xtensa/boot/Makefile b/arch/xtensa/boot/Makefile
index 9c5185f..40aa55b 100644
--- a/arch/xtensa/boot/Makefile
+++ b/arch/xtensa/boot/Makefile
@@ -8,7 +8,8 @@
 #
 
 
-EXTRA_CFLAGS	+= -fno-builtin -Iarch/$(ARCH)/boot/include
+# KBUILD_CFLAGS used when building rest of boot (takes effect recursively)
+KBUILD_CFLAGS	+= -fno-builtin -Iarch/$(ARCH)/boot/include
 HOSTFLAGS	+= -Iarch/$(ARCH)/boot/include
 
 BIG_ENDIAN	:= $(shell echo -e __XTENSA_EB__ | $(CC) -E - | grep -v "\#")
-- 
1.5.3.4.206.g58ba4

