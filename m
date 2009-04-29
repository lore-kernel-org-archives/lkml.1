Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbZD2Hq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbZD2Hq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZD2Hp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:28 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57937 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbZD2HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 04/13] x86, vmlinux.lds: unify start/end of SECTIONS
Date: Wed, 29 Apr 2009 09:47:20 +0200
Message-Id: <1240991249-27117-4-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/vmlinux.lds.S    |   14 ++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |    9 ---------
 arch/x86/kernel/vmlinux_64.lds.S |    9 ---------
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index fef1d8d..40f3439 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -49,12 +49,26 @@ PHDRS {
 	note PT_NOTE FLAGS(0);          /* ___ */
 }
 
+SECTIONS
+{
+#ifdef CONFIG_X86_32
+        . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
+        phys_startup_32 = startup_32 - LOAD_OFFSET;
+#else
+        . = __START_KERNEL;
+        phys_startup_64 = startup_64 - LOAD_OFFSET;
+#endif
+
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
 #else
 # include "vmlinux_64.lds.S"
 #endif
 
+        STABS_DEBUG
+        DWARF_DEBUG
+}
+
 
 #ifdef CONFIG_X86_32
 ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 4fd40dc..3d3d49c 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,8 +1,3 @@
-SECTIONS
-{
-	. = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
-	phys_startup_32 = startup_32 - LOAD_OFFSET;
-
 	/* Text and read-only data */
 	.text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
 		_text = .;
@@ -205,7 +200,3 @@ SECTIONS
 		*(.exitcall.exit)
 		*(.discard)
 	}
-
-	STABS_DEBUG
-	DWARF_DEBUG
-}
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 6e7cbee..2d7fa20 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,8 +1,3 @@
-SECTIONS
-{
-	. = __START_KERNEL;
-	phys_startup_64 = startup_64 - LOAD_OFFSET;
-
 	/* Text and read-only data */
 	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
 		_text = .;
@@ -277,7 +272,3 @@ SECTIONS
 		*(.eh_frame)
 		*(.discard)
 	}
-
-	STABS_DEBUG
-	DWARF_DEBUG
-}
-- 
1.6.0.6

