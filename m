Return-Path: <linux-kernel-owner+w=401wt.eu-S1760474AbXKERSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760474AbXKERSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbXKERI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:27 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59551 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757799AbXKERIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:25 -0500
Date: Mon, 5 Nov 2007 18:08:01 +0100
From: Adrian Bunk <bunk@kernel.org>
To: funaho@jurai.org, geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kill arch/m68k/mac/mac_ksyms.c
Message-ID: <20071105170801.GA12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/mac/Makefile    |    2 +-
 arch/m68k/mac/mac_ksyms.c |    8 --------
 arch/m68k/mac/via.c       |    5 ++++-
 3 files changed, 5 insertions(+), 10 deletions(-)

3eeace089297a73f11974fbf2570ebbcc50073f1 
diff --git a/arch/m68k/mac/Makefile b/arch/m68k/mac/Makefile
index 995a09d..1d265ba 100644
--- a/arch/m68k/mac/Makefile
+++ b/arch/m68k/mac/Makefile
@@ -3,4 +3,4 @@
 #
 
 obj-y		:= config.o bootparse.o macints.o iop.o via.o oss.o psc.o \
-			baboon.o macboing.o debug.o misc.o mac_ksyms.o
+			baboon.o macboing.o debug.o misc.o
diff --git a/arch/m68k/mac/mac_ksyms.c b/arch/m68k/mac/mac_ksyms.c
deleted file mode 100644
index 6e37ceb..0000000
--- a/arch/m68k/mac/mac_ksyms.c
+++ /dev/null
@@ -1,8 +0,0 @@
-#include <linux/module.h>
-#include <asm/ptrace.h>
-#include <asm/traps.h>
-
-/* Says whether we're using A/UX interrupts or not */
-extern int via_alt_mapping;
-
-EXPORT_SYMBOL(via_alt_mapping);
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index 8df270e..fa485df 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/ide.h>
+#include <linux/module.h>
 
 #include <asm/bootinfo.h>
 #include <asm/macintosh.h>
@@ -41,7 +42,9 @@ volatile __u8 *via1, *via2;
 /* See note in mac_via.h about how this is possibly not useful */
 volatile long *via_memory_bogon=(long *)&via_memory_bogon;
 #endif
-int rbv_present, via_alt_mapping;
+int rbv_present;
+int via_alt_mapping;
+EXPORT_SYMBOL(via_alt_mapping);
 __u8 rbv_clear;
 
 /*

