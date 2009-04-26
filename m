Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbZDZCYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbZDZCYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbZDZCYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:24:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54746 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431AbZDZCYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:24:19 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?utf-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 10/15] powerpc: convert to use __HEAD and HEAD_TEXT macros.
Date: Sat, 25 Apr 2009 22:11:05 -0400
Message-Id: <1240711870-30505-10-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240711870-30505-9-git-send-email-tabbott@mit.edu>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
 <1240711870-30505-1-git-send-email-tabbott@mit.edu>
 <1240711870-30505-2-git-send-email-tabbott@mit.edu>
 <1240711870-30505-3-git-send-email-tabbott@mit.edu>
 <1240711870-30505-4-git-send-email-tabbott@mit.edu>
 <1240711870-30505-5-git-send-email-tabbott@mit.edu>
 <1240711870-30505-6-git-send-email-tabbott@mit.edu>
 <1240711870-30505-7-git-send-email-tabbott@mit.edu>
 <1240711870-30505-8-git-send-email-tabbott@mit.edu>
 <1240711870-30505-9-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name use for head
code from ".text.head" to ".head.text".  Since this commit changes all
users in the architecture, this change should be harmless.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/kernel/head_32.S        |    3 ++-
 arch/powerpc/kernel/head_40x.S       |    3 ++-
 arch/powerpc/kernel/head_44x.S       |    3 ++-
 arch/powerpc/kernel/head_8xx.S       |    3 ++-
 arch/powerpc/kernel/head_fsl_booke.S |    3 ++-
 arch/powerpc/kernel/vmlinux.lds.S    |    2 +-
 6 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_32.S b/arch/powerpc/kernel/head_32.S
index 54e68c1..c01467f 100644
--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/init.h>
 #include <asm/reg.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -50,7 +51,7 @@
 	mtspr	SPRN_DBAT##n##L,RB;	\
 1:
 
-	.section	.text.head, "ax"
+	__HEAD
 	.stabs	"arch/powerpc/kernel/",N_SO,0,0,0f
 	.stabs	"head_32.S",N_SO,0,0,0f
 0:
diff --git a/arch/powerpc/kernel/head_40x.S b/arch/powerpc/kernel/head_40x.S
index 56d8e5d..0c96911 100644
--- a/arch/powerpc/kernel/head_40x.S
+++ b/arch/powerpc/kernel/head_40x.S
@@ -31,6 +31,7 @@
  *
  */
 
+#include <linux/init.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -52,7 +53,7 @@
  *
  * This is all going to change RSN when we add bi_recs.......  -- Dan
  */
-	.section	.text.head, "ax"
+	__HEAD
 _ENTRY(_stext);
 _ENTRY(_start);
 
diff --git a/arch/powerpc/kernel/head_44x.S b/arch/powerpc/kernel/head_44x.S
index b56fecc..18d8a16 100644
--- a/arch/powerpc/kernel/head_44x.S
+++ b/arch/powerpc/kernel/head_44x.S
@@ -28,6 +28,7 @@
  * option) any later version.
  */
 
+#include <linux/init.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -50,7 +51,7 @@
  *   r7 - End of kernel command line string
  *
  */
-	.section	.text.head, "ax"
+	__HEAD
 _ENTRY(_stext);
 _ENTRY(_start);
 	/*
diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 3c9452d..52ff8c5 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/init.h>
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
@@ -38,7 +39,7 @@
 #else
 #define DO_8xx_CPU6(val, reg)
 #endif
-	.section	.text.head, "ax"
+	__HEAD
 _ENTRY(_stext);
 _ENTRY(_start);
 
diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index 4c22620..5bdcc06 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -30,6 +30,7 @@
  * option) any later version.
  */
 
+#include <linux/init.h>
 #include <linux/threads.h>
 #include <asm/processor.h>
 #include <asm/page.h>
@@ -53,7 +54,7 @@
  *   r7 - End of kernel command line string
  *
  */
-	.section	.text.head, "ax"
+	__HEAD
 _ENTRY(_stext);
 _ENTRY(_start);
 	/*
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index b9ef164..d7425ff 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -52,7 +52,7 @@ SECTIONS
 	/* Text and gots */
 	.text : AT(ADDR(.text) - LOAD_OFFSET) {
 		ALIGN_FUNCTION();
-		*(.text.head)
+		HEAD_TEXT
 		_text = .;
 		*(.text .fixup .text.init.refok .exit.text.refok __ftr_alt_*)
 		SCHED_TEXT
-- 
1.6.2.1

