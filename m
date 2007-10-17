Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbXJQTPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbXJQTPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbXJQTPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:15:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:50373 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbXJQTPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:15:04 -0400
Date: Wed, 17 Oct 2007 21:16:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Boaz Harrosh <bharrosh@panasas.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix kernel rebuild due to vsyscall fallout
Message-ID: <20071017191633.GB11837@uranus.ravnborg.org>
References: <4715F2E5.6000104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4715F2E5.6000104@panasas.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix rebuild of kernel when there is no changes.
This happened for i386.
Using make V=2 hinted that the output files were
not assigned to targets - fixed by this patch.

Reported by: Boaz Harrosh <bharrosh@panasas.com>

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index 7ff0206..a3fa11f 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -51,7 +51,7 @@ obj-$(CONFIG_SCx200)		+= scx200_32.o
 # We must build both images before we can assemble it.
 # Note: kbuild does not track this dependency due to usage of .incbin
 $(obj)/vsyscall_32.o: $(obj)/vsyscall-int80_32.so $(obj)/vsyscall-sysenter_32.so
-targets += $(foreach F,int80 sysenter,vsyscall-$F.o vsyscall-$F.so)
+targets += $(foreach F,int80 sysenter,vsyscall-$F_32.o vsyscall-$F_32.so)
 targets += vsyscall-note_32.o vsyscall_32.lds
 
 # The DSO images are built using a special linker script.
