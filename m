Return-Path: <linux-kernel-owner+w=401wt.eu-S935093AbYBCMfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093AbYBCMfQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 07:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbYBCMfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 07:35:04 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37134 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbYBCMfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:35:03 -0500
Date: Sun, 3 Feb 2008 13:35:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: rename module scx200_32 to scx200
Message-ID: <20080203123506.GG20810@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module scx200 were renamed to scx200_32 by the
merge of the 32 and 64 bit x86 arch trees.

Keep the _32 prefix on the .c file as it is 32 bit
specific and fix the module name in the Makefile.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

Found during audit for this issue.
One other file uses module_init: vmiclock_32.c
But this file cannot be build as a module with present
configuration.

Build time tested only but obviously correct.

	Sam

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 6f81300..55106aa 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -74,7 +74,8 @@ ifdef CONFIG_INPUT_PCSPKR
 obj-y				+= pcspeaker.o
 endif
 
-obj-$(CONFIG_SCx200)		+= scx200_32.o
+obj-$(CONFIG_SCx200)		+= scx200.o
+scx200-y			+= scx200_32.o
 
 ###
 # 64 bit specific files
