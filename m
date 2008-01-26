Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbYAZWxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbYAZWxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYAZWw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:52:57 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35184 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbYAZWw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:52:56 -0500
Date: Sat, 26 Jan 2008 23:53:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix usage of .section .sched.text in assembler code
Message-ID: <20080126225306.GA27215@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch the linker will generate a section
named .sched.text.1 which is unexpected.
This is because the gcc generated section has "ax" but the
assembler usage of .sched.text lacks the "ax" specifier.

It would be better to have a definition we could use from
assembler code but I did not find a suitable header
file for it.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
build tested on 64 bit only but seems obviously correct.

 arch/x86/lib/semaphore_32.S |    2 +-
 arch/x86/lib/thunk_64.S     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 444fba4..1edb5f2 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -29,7 +29,7 @@
  * registers (%eax, %edx and %ecx) except %eax whish is either a return
  * value or just clobbered..
  */
-	.section .sched.text
+	.section .sched.text, "ax"
 ENTRY(__down_failed)
 	CFI_STARTPROC
 	FRAME
diff --git a/arch/x86/lib/thunk_64.S b/arch/x86/lib/thunk_64.S
index 6ea73f3..8b92d42 100644
--- a/arch/x86/lib/thunk_64.S
+++ b/arch/x86/lib/thunk_64.S
@@ -33,7 +33,7 @@
 	.endm
 	
 
-	.section .sched.text
+	.section .sched.text, "ax"
 #ifdef CONFIG_RWSEM_XCHGADD_ALGORITHM
 	thunk rwsem_down_read_failed_thunk,rwsem_down_read_failed
 	thunk rwsem_down_write_failed_thunk,rwsem_down_write_failed
-- 
1.5.4.rc3.14.g44397

