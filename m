Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZDZCVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZDZCVV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZDZCVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:21:09 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54479 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZDZCVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:21:07 -0400
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
       David Howells <dhowells@redhat.com>, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 12/15] sh: convert to use __HEAD and HEAD_TEXT macros.
Date: Sat, 25 Apr 2009 22:11:07 -0400
Message-Id: <1240711870-30505-12-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240711870-30505-11-git-send-email-tabbott@mit.edu>
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
 <1240711870-30505-10-git-send-email-tabbott@mit.edu>
 <1240711870-30505-11-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name use for head
code from ".text.head" to ".head.text".  Since this commit changes all
users in the architecture, this change should be harmless.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/head_32.S        |    3 ++-
 arch/sh/kernel/head_64.S        |    5 ++++-
 arch/sh/kernel/vmlinux_32.lds.S |    2 +-
 arch/sh/kernel/vmlinux_64.lds.S |    2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/sh/kernel/head_32.S b/arch/sh/kernel/head_32.S
index 788605f..a78be74 100644
--- a/arch/sh/kernel/head_32.S
+++ b/arch/sh/kernel/head_32.S
@@ -10,6 +10,7 @@
  *
  * Head.S contains the SH exception handlers and startup code.
  */
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/thread_info.h>
 
@@ -40,7 +41,7 @@ ENTRY(empty_zero_page)
 1:
 	.skip	PAGE_SIZE - empty_zero_page - 1b
 
-	.section	.text.head, "ax"
+	__HEAD
 
 /*
  * Condition at the entry of _stext:
diff --git a/arch/sh/kernel/head_64.S b/arch/sh/kernel/head_64.S
index 7ccfb99..3ea7658 100644
--- a/arch/sh/kernel/head_64.S
+++ b/arch/sh/kernel/head_64.S
@@ -8,6 +8,9 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  */
+
+#include <linux/init.h>
+
 #include <asm/page.h>
 #include <asm/cache.h>
 #include <asm/tlb.h>
@@ -110,7 +113,7 @@ empty_bad_pte_table:
 fpu_in_use:	.quad	0
 
 
-	.section	.text.head, "ax"
+	__HEAD
 	.balign L1_CACHE_BYTES
 /*
  * Condition at the entry of __stext:
diff --git a/arch/sh/kernel/vmlinux_32.lds.S b/arch/sh/kernel/vmlinux_32.lds.S
index d0b2a71..dd9b2ee 100644
--- a/arch/sh/kernel/vmlinux_32.lds.S
+++ b/arch/sh/kernel/vmlinux_32.lds.S
@@ -31,7 +31,7 @@ SECTIONS
 	} = 0
 
 	.text : {
-		*(.text.head)
+		HEAD_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
diff --git a/arch/sh/kernel/vmlinux_64.lds.S b/arch/sh/kernel/vmlinux_64.lds.S
index 33fa464..6966446 100644
--- a/arch/sh/kernel/vmlinux_64.lds.S
+++ b/arch/sh/kernel/vmlinux_64.lds.S
@@ -42,7 +42,7 @@ SECTIONS
 	} = 0
 
 	.text : C_PHYS(.text) {
-		*(.text.head)
+		HEAD_TEXT
 		TEXT_TEXT
 		*(.text64)
 		*(.text..SHmedia32)
-- 
1.6.2.1

