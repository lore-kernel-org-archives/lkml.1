Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZDZCSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZDZCSG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 22:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZDZCRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 22:17:52 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54193 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZDZCRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 22:17:51 -0400
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
Subject: [PATCH 04/15] frv: convert frv to use __HEAD and HEAD_TEXT macros.
Date: Sat, 25 Apr 2009 22:10:59 -0400
Message-Id: <1240711870-30505-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240711870-30505-3-git-send-email-tabbott@mit.edu>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu>
 <1240711870-30505-1-git-send-email-tabbott@mit.edu>
 <1240711870-30505-2-git-send-email-tabbott@mit.edu>
 <1240711870-30505-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name use for head
code from ".text.head" to ".head.text".  Since this commit changes all
users in the architecture, this change should be harmless.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/kernel/head.S        |    3 ++-
 arch/frv/kernel/vmlinux.lds.S |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/frv/kernel/head.S b/arch/frv/kernel/head.S
index fecf751..b825ef3 100644
--- a/arch/frv/kernel/head.S
+++ b/arch/frv/kernel/head.S
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/init.h>
 #include <linux/threads.h>
 #include <linux/linkage.h>
 #include <asm/thread_info.h>
@@ -27,7 +28,7 @@
 #   command line string
 #
 ###############################################################################
-	.section	.text.head,"ax"
+	__HEAD
 	.balign		4
 
 	.globl		_boot, __head_reference
diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index b95c4ea..22d9787 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -26,7 +26,7 @@ SECTIONS
 
   _sinittext = .;
   .init.text : {
-	*(.text.head)
+	HEAD_TEXT
 #ifndef CONFIG_DEBUG_INFO
 	INIT_TEXT
 	EXIT_TEXT
-- 
1.6.2.1

