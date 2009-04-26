Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbZDZCMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbZDZCMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbZDZCLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:11:44 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53519 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132AbZDZCLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:11:42 -0400
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
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 13/15] sparc: convert to use __HEAD and HEAD_TEXT macros.
Date: Sat, 25 Apr 2009 22:11:08 -0400
Message-Id: <1240711870-30505-13-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240711870-30505-12-git-send-email-tabbott@mit.edu>
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
 <1240711870-30505-12-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name use for head
code from ".text.head" to ".head.text".  Since this commit changes all
users in the architecture, this change should be harmless.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/head_32.S     |    2 +-
 arch/sparc/kernel/vmlinux.lds.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/head_32.S b/arch/sparc/kernel/head_32.S
index f0b4b51..e91f01a 100644
--- a/arch/sparc/kernel/head_32.S
+++ b/arch/sparc/kernel/head_32.S
@@ -72,7 +72,7 @@ sun4e_notsup:
 	.align 4
 
 	/* The Sparc trap table, bootloader gives us control at _start. */
-	.section .text.head,"ax"
+	__HEAD
 	.globl	start, _stext, _start, __stext
 	.globl  trapbase
 _start:   /* danger danger */
diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 7626708..fcbbd00 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -41,7 +41,7 @@ SECTIONS
 	.text TEXTSTART :
 	{
 		_text = .;
-		*(.text.head)
+		HEAD_TEXT
 		TEXT_TEXT
 		SCHED_TEXT
 		LOCK_TEXT
-- 
1.6.2.1

