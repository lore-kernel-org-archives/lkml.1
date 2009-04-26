Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbZDZCLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbZDZCLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZDZCLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:11:22 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53428 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbZDZCLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:11:21 -0400
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
       Chris Zankel <chris@zankel.net>
Subject: [PATCH 02/15] xtensa: convert to use __HEAD and HEAD_TEXT macros.
Date: Sat, 25 Apr 2009 22:10:57 -0400
Message-Id: <1240711870-30505-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240711870-30505-1-git-send-email-tabbott@mit.edu>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
 <1240711870-30505-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/kernel/head.S        |    3 ++-
 arch/xtensa/kernel/vmlinux.lds.S |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/kernel/head.S b/arch/xtensa/kernel/head.S
index 0817f9d..d9ddc1b 100644
--- a/arch/xtensa/kernel/head.S
+++ b/arch/xtensa/kernel/head.S
@@ -19,6 +19,7 @@
 #include <asm/page.h>
 #include <asm/cacheasm.h>
 
+#include <linux/init.h>
 #include <linux/linkage.h>
 
 /*
@@ -45,7 +46,7 @@
 	 * instruction.
 	 */
 
-	.section .head.text, "ax"
+	__HEAD
 	.globl _start
 _start:	_j	2f
 	.align	4
diff --git a/arch/xtensa/kernel/vmlinux.lds.S b/arch/xtensa/kernel/vmlinux.lds.S
index c1be9a4..5accf51 100644
--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -85,8 +85,8 @@ SECTIONS
 
   .text :
   {
-    /* The .head.text section must be the first section! */
-    *(.head.text)
+    /* The HEAD_TEXT section must be the first section! */
+    HEAD_TEXT
     *(.literal .text)
     VMLINUX_SYMBOL(__sched_text_start) = .;
     *(.sched.literal .sched.text)
-- 
1.6.2.1

