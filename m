Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbXKSWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbXKSWIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbXKSWG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:06:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500AbXKSWG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:06:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 11/18] x86 vDSO: vdso32 setup
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Windows: it was hard to write; it should be hard to use.
Message-Id: <20071119220606.58CD226F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:06:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This moves arch/x86/kernel/sysenter_32.c to arch/x86/vdso/vdso32-setup.c,
keeping all the code relating only to vDSO magic in the vdso/ subdirectory.
This is a pure renaming, but it paves the way to consolidating the code for
dealing with 32-bit vDSOs across CONFIG_X86_32 and CONFIG_IA32_EMULATION.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/Makefile_32                        |    1 -
 arch/x86/vdso/Makefile                             |    2 +-
 .../{kernel/sysenter_32.c => vdso/vdso32-setup.c}  |    0 
 3 files changed, 1 insertions(+), 2 deletions(-)
 rename arch/x86/{kernel/sysenter_32.c => vdso/vdso32-setup.c} (100%)

diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index 1ece642..882f164 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -33,7 +33,6 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
 obj-$(CONFIG_KPROBES)		+= kprobes_32.o
 obj-$(CONFIG_MODULES)		+= module_32.o
-obj-y				+= sysenter_32.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
 obj-$(CONFIG_EFI) 		+= efi_32.o efi_stub_32.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index cabb0c2..9ffd03f 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -15,7 +15,7 @@ vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
 
 # files to link into kernel
 obj-$(VDSO64-y)			+= vma.o vdso.o
-obj-$(CONFIG_X86_32)		+= vdso32.o
+obj-$(CONFIG_X86_32)		+= vdso32.o vdso32-setup.o
 
 vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 
diff --git a/arch/x86/kernel/sysenter_32.c b/arch/x86/vdso/vdso32-setup.c
similarity index 100%
rename from arch/x86/kernel/sysenter_32.c
rename to arch/x86/vdso/vdso32-setup.c
