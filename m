Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZDZCLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZDZCLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZDZCL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:11:29 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53466 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754621AbZDZCL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:11:28 -0400
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
       Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH 07/15] m32r: convert to use __HEAD and HEAD_TEXT macros.
Date: Sat, 25 Apr 2009 22:11:02 -0400
Message-Id: <1240711870-30505-7-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240711870-30505-6-git-send-email-tabbott@mit.edu>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
 <1240711870-30505-1-git-send-email-tabbott@mit.edu>
 <1240711870-30505-2-git-send-email-tabbott@mit.edu>
 <1240711870-30505-3-git-send-email-tabbott@mit.edu>
 <1240711870-30505-4-git-send-email-tabbott@mit.edu>
 <1240711870-30505-5-git-send-email-tabbott@mit.edu>
 <1240711870-30505-6-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name use for head
code from ".text.head" to ".head.text".  Since this commit changes all
users in the architecture, this change should be harmless.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/head.S        |    2 +-
 arch/m32r/kernel/vmlinux.lds.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m32r/kernel/head.S b/arch/m32r/kernel/head.S
index 9091606..0a71944 100644
--- a/arch/m32r/kernel/head.S
+++ b/arch/m32r/kernel/head.S
@@ -23,7 +23,7 @@ __INITDATA
 /*
  * References to members of the boot_cpu_data structure.
  */
-.section .text.head, "ax"
+__HEAD
 	.global	start_kernel
 	.global __bss_start
 	.global _end
diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 9db05df..4179adf 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -27,7 +27,7 @@ SECTIONS
   _text = .;			/* Text and read-only data */
   .boot : { *(.boot) } = 0
   .text : {
-	*(.text.head)
+	HEAD_TEXT
 	TEXT_TEXT
 	SCHED_TEXT
 	LOCK_TEXT
-- 
1.6.2.1

