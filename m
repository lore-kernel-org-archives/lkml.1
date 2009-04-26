Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbZDZCVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbZDZCVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZDZCVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:21:11 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54481 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZDZCVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:21:09 -0400
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
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 11/15] s390: convert to use __HEAD and HEAD_TEXT macros.
Date: Sat, 25 Apr 2009 22:11:06 -0400
Message-Id: <1240711870-30505-11-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240711870-30505-10-git-send-email-tabbott@mit.edu>
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
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name use for head
code from ".text.head" to ".head.text".  Since this commit changes all
users in the architecture, this change should be harmless.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/head.S        |    3 ++-
 arch/s390/kernel/vmlinux.lds.S |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/head.S b/arch/s390/kernel/head.S
index bba1449..22596d7 100644
--- a/arch/s390/kernel/head.S
+++ b/arch/s390/kernel/head.S
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/init.h>
 #include <asm/setup.h>
 #include <asm/lowcore.h>
 #include <asm/asm-offsets.h>
@@ -35,7 +36,7 @@
 #define ARCH_OFFSET	0
 #endif
 
-.section ".text.head","ax"
+__HEAD
 #ifndef CONFIG_IPL
 	.org   0
 	.long  0x00080000,0x80000000+startup	# Just a restart PSW
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 7a2063e..89399b8 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -29,8 +29,8 @@ SECTIONS
 	. = 0x00000000;
 	.text : {
 	_text = .;		/* Text and read-only data */
-		*(.text.head)
-	TEXT_TEXT
+		HEAD_TEXT
+		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
-- 
1.6.2.1

