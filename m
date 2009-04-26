Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZDZCUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZDZCUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZDZCT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:19:58 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54398 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZDZCT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:19:58 -0400
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
       Tony Luck <tony.luck@intel.com>
Subject: [PATCH 06/15] ia64: convert to use __HEAD and HEAD_TEXT macros.
Date: Sat, 25 Apr 2009 22:11:01 -0400
Message-Id: <1240711870-30505-6-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240711870-30505-5-git-send-email-tabbott@mit.edu>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
 <1240711870-30505-1-git-send-email-tabbott@mit.edu>
 <1240711870-30505-2-git-send-email-tabbott@mit.edu>
 <1240711870-30505-3-git-send-email-tabbott@mit.edu>
 <1240711870-30505-4-git-send-email-tabbott@mit.edu>
 <1240711870-30505-5-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name use for head
code from ".text.head" to ".head.text".  Since this commit changes all
users in the architecture, this change should be harmless.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/kernel/head.S        |    2 +-
 arch/ia64/kernel/vmlinux.lds.S |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/head.S b/arch/ia64/kernel/head.S
index 23f846d..a572160 100644
--- a/arch/ia64/kernel/head.S
+++ b/arch/ia64/kernel/head.S
@@ -181,7 +181,7 @@ swapper_pg_dir:
 halt_msg:
 	stringz "Halting kernel\n"
 
-	.section .text.head,"ax"
+	__HEAD
 
 	.global start_ap
 
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 4a95e86..a8b879e 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -51,8 +51,8 @@ SECTIONS
 	KPROBES_TEXT
 	*(.gnu.linkonce.t*)
     }
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET)
-	{ *(.text.head) }
+  HEAD_TEXT_SECTION : AT(ADDR(HEAD_TEXT_SECTION) - LOAD_OFFSET)
+	{ HEAD_TEXT }
   .text2 : AT(ADDR(.text2) - LOAD_OFFSET)
 	{ *(.text2) }
 #ifdef CONFIG_SMP
-- 
1.6.2.1

