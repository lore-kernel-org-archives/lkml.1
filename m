Return-Path: <linux-kernel-owner+w=401wt.eu-S933831AbXCNFMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831AbXCNFMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbXCNFMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:00 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45240 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933831AbXCNFL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:11:59 -0400
Message-Id: <20070314051047.869228088@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 02/18] x86 Makefile changes
Content-Disposition: inline; filename=x86-makefile.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create the arch/x86/Makefile and modify the i386 and x86_64
Makefiles accordingly.


Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
new file mode 100644
index 0000000..97407b2
--- /dev/null
+++ b/arch/x86/Makefile
@@ -0,0 +1,3 @@
+
+
+drivers-$(CONFIG_OPROFILE)		+= arch/x86/oprofile/
diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index bd28f9f..78e59ef 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -98,15 +98,17 @@ mflags-y += -Iinclude/asm-i386/mach-default
 
 head-y := arch/i386/kernel/head.o arch/i386/kernel/init_task.o
 
-libs-y 					+= arch/i386/lib/
+libs-y 					+= arch/i386/lib/ \
+					   arch/x86/lib/
 core-y					+= arch/i386/kernel/ \
+					   arch/x86/kernel/ \
 					   arch/i386/mm/ \
+					   arch/x86/mm/ \
 					   arch/i386/$(mcore-y)/ \
 					   arch/i386/crypto/
 drivers-$(CONFIG_MATH_EMULATION)	+= arch/i386/math-emu/
 drivers-$(CONFIG_PCI)			+= arch/i386/pci/
 # must be linked after kernel/
-drivers-$(CONFIG_OPROFILE)		+= arch/i386/oprofile/
 drivers-$(CONFIG_PM)			+= arch/i386/power/
 
 CFLAGS += $(mflags-y)
diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 2941a91..150942b 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -79,11 +79,15 @@ head-y := arch/x86_64/kernel/head.o arch/x86_64/kernel/head64.o arch/x86_64/kern
 
 libs-y 					+= arch/x86_64/lib/
 core-y					+= arch/x86_64/kernel/ \
+					   arch/x86/kernel/ \
 					   arch/x86_64/mm/ \
-					   arch/x86_64/crypto/
+					   arch/x86/mm/ \
+					   arch/x86_64/crypto/ \
+					   arch/x86/lib/
 core-$(CONFIG_IA32_EMULATION)		+= arch/x86_64/ia32/
 drivers-$(CONFIG_PCI)			+= arch/x86_64/pci/
-drivers-$(CONFIG_OPROFILE)		+= arch/x86_64/oprofile/
+
+include arch/x86/Makefile
 
 boot := arch/x86_64/boot
 

--
