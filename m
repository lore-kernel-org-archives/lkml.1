Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYG0UTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYG0UTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 16:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbYG0UTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 16:19:31 -0400
Received: from www.tglx.de ([62.245.132.106]:48313 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757784AbYG0UTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 16:19:30 -0400
Date: Sun, 27 Jul 2008 22:18:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 fixes for .27
Message-ID: <alpine.LFD.1.10.0807272217400.574@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull x86 fixes from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git x86/urgent

Thanks,

	tglx

----
Thomas Gleixner (1):
      x86: fix cpu hotplug on 32bit

 arch/x86/kernel/head_32.S |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index f67e934..a7010c3 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -456,9 +456,6 @@ is386:	movl $2,%ecx		# set MP
 1:
 #endif /* CONFIG_SMP */
 	jmp *(initial_code)
-.align 4
-ENTRY(initial_code)
-	.long i386_start_kernel
 
 /*
  * We depend on ET to be correct. This checks for 287/387.
@@ -601,6 +598,11 @@ ignore_int:
 #endif
 	iret
 
+.section .cpuinit.data,"wa"
+.align 4
+ENTRY(initial_code)
+	.long i386_start_kernel
+
 .section .text
 /*
  * Real beginning of normal "text" segment
