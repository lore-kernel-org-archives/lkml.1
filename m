Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbXD1TTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbXD1TTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbXD1TTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:19:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37486 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754799AbXD1TTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:19:16 -0400
Date: Sat, 28 Apr 2007 21:19:27 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Grant Coady <gcoady@gmail.com>
Subject: [-mm patch] i386: enable 4k stacks by default
Message-ID: <20070428191927.GN3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

4k stacks have become a well-tested feature used fore a long time in
Fedora and even in RHEL 4.

Defaulting to 4k stacks in -mm kernel will give some more testing
coverage and should show whether there are problems left.

Keeping the option for now should make the people happy who want to use
the experimental -mm kernel but don't trust the well-tested 4k stacks.

Additionally, make it more obvious that available stack space is not 
being halved.

Signed-off-by: Grant Coady <gcoady@gmail.com>
Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This is the original patch that does not the opposite of what it should do.

This patch has been sent on:
- 14 Jan 2006
- 5 Jan 2006

 Kconfig.debug |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.15a/arch/i386/Kconfig.debug	2005-10-28 10:02:08.000000000 +1000
+++ linux-2.6.15b/arch/i386/Kconfig.debug	2006-01-05 09:39:22.000000000 +1100
@@ -53,14 +53,15 @@
 	  of memory corruptions.
 
 config 4KSTACKS
-	bool "Use 4Kb for kernel stacks instead of 8Kb"
-	depends on DEBUG_KERNEL
+	bool "Use 4Kb + 4Kb for kernel stacks instead of 8Kb" if DEBUG_KERNEL
+	default y
 	help
 	  If you say Y here the kernel will use a 4Kb stacksize for the
 	  kernel stack attached to each process/thread. This facilitates
 	  running more threads on a system and also reduces the pressure
 	  on the VM subsystem for higher order allocations. This option
-	  will also use IRQ stacks to compensate for the reduced stackspace.
+	  will also use separate 4Kb IRQ stacks to compensate for the 
+	  reduced stackspace.
 
 config X86_FIND_SMP_CONFIG
 	bool

