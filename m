Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYK1Rhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYK1Rhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 12:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYK1Rhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 12:37:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:36220 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYK1Rhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 12:37:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=Zo2zCMFz+S0yrzsvSNvqH8WAvHsMhQXAMNLYRB7CiKPn/iUOfeACSsdTu4jAARswV2
         HNNKamDHMtjhTM6Q/V5lvALpb6ovKM4hmsU2Xz9sBscMlcSUeUzN4KAKPivYTog1KzfT
         Vtfd9RBMAM9vPD+auAmXk8J+oyJs58mb0P84A=
Date: Fri, 28 Nov 2008 18:38:49 +0100
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: fix CONFIG_EMBEDDED submenu
Message-ID: <20081128173849.GA19101@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 06f65799401f08eff0020ba0300133c89bd02349 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 28 Nov 2008 18:29:47 +0100
Subject: [PATCH] kbuild: fix CONFIG_EMBEDDED submenu

Many of the elements of the EMBEDDED submenu were being expanded
in the current menu instead of inside the submenu. This was caused
by the lack of (explicit) dependencies on EMBEDDED. The simplest
fix is to wrap everything (except COMPAT_BRK, which just toggles a
setting) in "if/endif EMBEDDED".

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 init/Kconfig |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index f763762..4590d97 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -546,6 +546,7 @@ menuconfig EMBEDDED
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+if EMBEDDED
 config UID16
 	bool "Enable 16-bit UID system calls" if EMBEDDED
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
@@ -643,18 +644,6 @@ config PCSPKR_PLATFORM
           This option allows to disable the internal PC-Speaker
           support, saving some memory.
 
-config COMPAT_BRK
-	bool "Disable heap randomization"
-	default y
-	help
-	  Randomizing heap placement makes heap exploits harder, but it
-	  also breaks ancient binaries (including anything libc5 based).
-	  This option changes the bootup default to heap randomization
-	  disabled, and can be overriden runtime by setting
-	  /proc/sys/kernel/randomize_va_space to 2.
-
-	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
-
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EMBEDDED
@@ -760,6 +749,20 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+endif
+
+config COMPAT_BRK
+	bool "Disable heap randomization"
+	default y
+	help
+	  Randomizing heap placement makes heap exploits harder, but it
+	  also breaks ancient binaries (including anything libc5 based).
+	  This option changes the bootup default to heap randomization
+	  disabled, and can be overriden runtime by setting
+	  /proc/sys/kernel/randomize_va_space to 2.
+
+	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
+
 choice
 	prompt "Choose SLAB allocator"
 	default SLUB
-- 
1.5.6.5

