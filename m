Return-Path: <linux-kernel-owner+w=401wt.eu-S1764747AbYEVF03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764747AbYEVF03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 01:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbYEVF0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 01:26:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46870 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbYEVF0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 01:26:14 -0400
Date: Thu, 22 May 2008 06:26:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Dike <jdike@addtoit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
Message-ID: <20080522052607.GY28946@ZenIV.linux.org.uk>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org> <18484.44691.477859.334222@cargo.ozlabs.ibm.com> <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org> <20080522005657.GU28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org> <1211419419.6908.12.camel@brick> <alpine.LFD.1.10.0805211827010.3081@woody.linux-foundation.org> <20080522042059.GA17173@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522042059.GA17173@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 12:20:59AM -0400, Jeff Dike wrote:
> On Wed, May 21, 2008 at 06:29:43PM -0700, Linus Torvalds wrote:
> > > 
> > > What about say, sparc64 that has a lot of #include <asm-sparc/foo.h>
> > 
> > Ahh, I didn't realize people did that.
> > 
> > I assume (but am too lazy to check) that UML probably does something 
> > similar for its arch-specific stuff.
> 
> Not quite - there's the include/asm-um/arch link, which points to
> ../asm-foo and a bunch of #include <asm/arch/foo.h>.  Same idea though.

It's a bit worse, though - there is target-dependent stuff in arch/um/include
*and* in include/asm-um; the latter is done in a very painful way - see
include/asm-um/module-i386.h and include/asm-um/module-x86_64.h, etc. and
logics that creates a symlink for each of those.

Is there any reason why module.h is not simply

#include <sysdep/module.h>

with these suckers sitting in arch/um/include/sysdep-{i386,x86_64}/ resp.?
Something like this:

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile                                   |   17 +----------------
 .../um/include/sysdep-i386/archparam.h             |    0 
 .../um/include/sysdep-i386/elf.h                   |    0 
 .../um/include/sysdep-i386/host_ldt.h              |    0 
 .../um/include/sysdep-i386/module.h                |    0 
 .../um/include/sysdep-i386/processor.h             |    2 +-
 .../um/include/sysdep-i386/ptrace-full.h           |    0 
 .../um/include/sysdep-i386/sigcontext-full.h       |    2 +-
 .../um/include/sysdep-i386/system.h                |    0 
 .../um/include/sysdep-i386/vm-flags.h              |    0 
 .../um/include/sysdep-ppc/archparam.h              |    0 
 .../elf-ppc.h => arch/um/include/sysdep-ppc/elf.h  |    0 
 .../um/include/sysdep-ppc/processor.h              |    0 
 .../um/include/sysdep-ppc/sigcontext-full.h        |    2 +-
 .../um/include/sysdep-ppc/system.h                 |    0 
 .../um/include/sysdep-x86_64/archparam.h           |    0 
 .../um/include/sysdep-x86_64/elf.h                 |    0 
 .../um/include/sysdep-x86_64/host_ldt.h            |    0 
 .../um/include/sysdep-x86_64/module.h              |    0 
 .../um/include/sysdep-x86_64/processor.h           |    0 
 .../um/include/sysdep-x86_64/ptrace-full.h         |    2 +-
 .../um/include/sysdep-x86_64/sigcontext-full.h     |    2 +-
 .../um/include/sysdep-x86_64/system.h              |    0 
 .../um/include/sysdep-x86_64/vm-flags.h            |    0 
 include/asm-um/elf.h                               |    1 +
 include/asm-um/fixmap.h                            |    2 +-
 include/asm-um/hw_irq.h                            |    2 +-
 include/asm-um/ldt.h                               |    2 +-
 include/asm-um/module.h                            |    1 +
 include/asm-um/processor.h                         |    1 +
 include/asm-um/ptrace.h                            |    1 +
 include/asm-um/sigcontext-generic.h                |    6 ------
 include/asm-um/sigcontext.h                        |    1 +
 include/asm-um/string.h                            |    2 +-
 include/asm-um/system.h                            |    1 +
 include/asm-um/vm-flags.h                          |    1 +
 36 files changed, 17 insertions(+), 31 deletions(-)
 rename include/asm-um/archparam-i386.h => arch/um/include/sysdep-i386/archparam.h (100%)
 rename include/asm-um/elf-i386.h => arch/um/include/sysdep-i386/elf.h (100%)
 rename include/asm-um/host_ldt-i386.h => arch/um/include/sysdep-i386/host_ldt.h (100%)
 rename include/asm-um/module-i386.h => arch/um/include/sysdep-i386/module.h (100%)
 rename include/asm-um/processor-i386.h => arch/um/include/sysdep-i386/processor.h (98%)
 rename include/asm-um/ptrace-i386.h => arch/um/include/sysdep-i386/ptrace-full.h (100%)
 rename include/asm-um/sigcontext-i386.h => arch/um/include/sysdep-i386/sigcontext-full.h (66%)
 rename include/asm-um/system-i386.h => arch/um/include/sysdep-i386/system.h (100%)
 rename include/asm-um/vm-flags-i386.h => arch/um/include/sysdep-i386/vm-flags.h (100%)
 rename include/asm-um/archparam-ppc.h => arch/um/include/sysdep-ppc/archparam.h (100%)
 rename include/asm-um/elf-ppc.h => arch/um/include/sysdep-ppc/elf.h (100%)
 rename include/asm-um/processor-ppc.h => arch/um/include/sysdep-ppc/processor.h (100%)
 rename include/asm-um/sigcontext-ppc.h => arch/um/include/sysdep-ppc/sigcontext-full.h (76%)
 rename include/asm-um/system-ppc.h => arch/um/include/sysdep-ppc/system.h (100%)
 rename include/asm-um/archparam-x86_64.h => arch/um/include/sysdep-x86_64/archparam.h (100%)
 rename include/asm-um/elf-x86_64.h => arch/um/include/sysdep-x86_64/elf.h (100%)
 rename include/asm-um/host_ldt-x86_64.h => arch/um/include/sysdep-x86_64/host_ldt.h (100%)
 rename include/asm-um/module-x86_64.h => arch/um/include/sysdep-x86_64/module.h (100%)
 rename include/asm-um/processor-x86_64.h => arch/um/include/sysdep-x86_64/processor.h (100%)
 rename include/asm-um/ptrace-x86_64.h => arch/um/include/sysdep-x86_64/ptrace-full.h (98%)
 rename include/asm-um/sigcontext-x86_64.h => arch/um/include/sysdep-x86_64/sigcontext-full.h (93%)
 rename include/asm-um/system-x86_64.h => arch/um/include/sysdep-x86_64/system.h (100%)
 rename include/asm-um/vm-flags-x86_64.h => arch/um/include/sysdep-x86_64/vm-flags.h (100%)
 create mode 100644 include/asm-um/elf.h
 create mode 100644 include/asm-um/module.h
 create mode 100644 include/asm-um/processor.h
 create mode 100644 include/asm-um/ptrace.h
 delete mode 100644 include/asm-um/sigcontext-generic.h
 create mode 100644 include/asm-um/sigcontext.h
 create mode 100644 include/asm-um/system.h
 create mode 100644 include/asm-um/vm-flags.h

diff --git a/arch/um/Makefile b/arch/um/Makefile
index dbeab15..4dd57c9 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -18,18 +18,13 @@ core-y			+= $(ARCH_DIR)/kernel/		\
 			   $(ARCH_DIR)/drivers/		\
 			   $(ARCH_DIR)/os-$(OS)/
 
-# Have to precede the include because the included Makefiles reference them.
-SYMLINK_HEADERS := archparam.h system.h sigcontext.h processor.h ptrace.h \
-	module.h vm-flags.h elf.h host_ldt.h
-SYMLINK_HEADERS := $(foreach header,$(SYMLINK_HEADERS),include/asm-um/$(header))
-
 # XXX: The "os" symlink is only used by arch/um/include/os.h, which includes
 # ../os/include/file.h
 #
 # These are cleaned up during mrproper. Please DO NOT fix it again, this is
 # the Correct Thing(tm) to do!
 ARCH_SYMLINKS = include/asm-um/arch $(ARCH_DIR)/include/sysdep $(ARCH_DIR)/os \
-	$(SYMLINK_HEADERS) $(ARCH_DIR)/include/uml-config.h
+	$(ARCH_DIR)/include/uml-config.h
 
 MODE_INCLUDE	+= -I$(srctree)/$(ARCH_DIR)/include/skas
 
@@ -143,16 +138,6 @@ archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \
 		-o -name '*.gcov' \) -type f -print | xargs rm -f
 
-$(SYMLINK_HEADERS):
-	@echo '  SYMLINK $@'
-ifneq ($(KBUILD_SRC),)
-	$(Q)mkdir -p $(objtree)/include/asm-um
-	$(Q)ln -fsn $(srctree)/include/asm-um/$(basename $(notdir $@))-$(SUBARCH)$(suffix $@) $@
-else
-	$(Q)cd $(srctree)/$(dir $@) ; \
-	ln -sf $(basename $(notdir $@))-$(SUBARCH)$(suffix $@) $(notdir $@)
-endif
-
 include/asm-um/arch:
 	@echo '  SYMLINK $@'
 ifneq ($(KBUILD_SRC),)
diff --git a/include/asm-um/archparam-i386.h b/arch/um/include/sysdep-i386/archparam.h
similarity index 100%
rename from include/asm-um/archparam-i386.h
rename to arch/um/include/sysdep-i386/archparam.h
diff --git a/include/asm-um/elf-i386.h b/arch/um/include/sysdep-i386/elf.h
similarity index 100%
rename from include/asm-um/elf-i386.h
rename to arch/um/include/sysdep-i386/elf.h
diff --git a/include/asm-um/host_ldt-i386.h b/arch/um/include/sysdep-i386/host_ldt.h
similarity index 100%
rename from include/asm-um/host_ldt-i386.h
rename to arch/um/include/sysdep-i386/host_ldt.h
diff --git a/include/asm-um/module-i386.h b/arch/um/include/sysdep-i386/module.h
similarity index 100%
rename from include/asm-um/module-i386.h
rename to arch/um/include/sysdep-i386/module.h
diff --git a/include/asm-um/processor-i386.h b/arch/um/include/sysdep-i386/processor.h
similarity index 98%
rename from include/asm-um/processor-i386.h
rename to arch/um/include/sysdep-i386/processor.h
index a2b7fe1..64c1978 100644
--- a/include/asm-um/processor-i386.h
+++ b/arch/um/include/sysdep-i386/processor.h
@@ -7,7 +7,7 @@
 #define __UM_PROCESSOR_I386_H
 
 #include "linux/string.h"
-#include "asm/host_ldt.h"
+#include "sysdep/host_ldt.h"
 #include "asm/segment.h"
 
 extern int host_has_cmov;
diff --git a/include/asm-um/ptrace-i386.h b/arch/um/include/sysdep-i386/ptrace-full.h
similarity index 100%
rename from include/asm-um/ptrace-i386.h
rename to arch/um/include/sysdep-i386/ptrace-full.h
diff --git a/include/asm-um/sigcontext-i386.h b/arch/um/include/sysdep-i386/sigcontext-full.h
similarity index 66%
rename from include/asm-um/sigcontext-i386.h
rename to arch/um/include/sysdep-i386/sigcontext-full.h
index b88333f..588d58c 100644
--- a/include/asm-um/sigcontext-i386.h
+++ b/arch/um/include/sysdep-i386/sigcontext-full.h
@@ -1,6 +1,6 @@
 #ifndef __UM_SIGCONTEXT_I386_H
 #define __UM_SIGCONTEXT_I386_H
 
-#include "asm/sigcontext-generic.h"
+#include <asm/arch/sigcontext.h>
 
 #endif
diff --git a/include/asm-um/system-i386.h b/arch/um/include/sysdep-i386/system.h
similarity index 100%
rename from include/asm-um/system-i386.h
rename to arch/um/include/sysdep-i386/system.h
diff --git a/include/asm-um/vm-flags-i386.h b/arch/um/include/sysdep-i386/vm-flags.h
similarity index 100%
rename from include/asm-um/vm-flags-i386.h
rename to arch/um/include/sysdep-i386/vm-flags.h
diff --git a/include/asm-um/archparam-ppc.h b/arch/um/include/sysdep-ppc/archparam.h
similarity index 100%
rename from include/asm-um/archparam-ppc.h
rename to arch/um/include/sysdep-ppc/archparam.h
diff --git a/include/asm-um/elf-ppc.h b/arch/um/include/sysdep-ppc/elf.h
similarity index 100%
rename from include/asm-um/elf-ppc.h
rename to arch/um/include/sysdep-ppc/elf.h
diff --git a/include/asm-um/processor-ppc.h b/arch/um/include/sysdep-ppc/processor.h
similarity index 100%
rename from include/asm-um/processor-ppc.h
rename to arch/um/include/sysdep-ppc/processor.h
diff --git a/include/asm-um/sigcontext-ppc.h b/arch/um/include/sysdep-ppc/sigcontext-full.h
similarity index 76%
rename from include/asm-um/sigcontext-ppc.h
rename to arch/um/include/sysdep-ppc/sigcontext-full.h
index 2467f20..c02555d 100644
--- a/include/asm-um/sigcontext-ppc.h
+++ b/arch/um/include/sysdep-ppc/sigcontext-full.h
@@ -3,7 +3,7 @@
 
 #define pt_regs sys_pt_regs
 
-#include "asm/sigcontext-generic.h"
+#include <asm/arch/sigcontext.h>
 
 #undef pt_regs
 
diff --git a/include/asm-um/system-ppc.h b/arch/um/include/sysdep-ppc/system.h
similarity index 100%
rename from include/asm-um/system-ppc.h
rename to arch/um/include/sysdep-ppc/system.h
diff --git a/include/asm-um/archparam-x86_64.h b/arch/um/include/sysdep-x86_64/archparam.h
similarity index 100%
rename from include/asm-um/archparam-x86_64.h
rename to arch/um/include/sysdep-x86_64/archparam.h
diff --git a/include/asm-um/elf-x86_64.h b/arch/um/include/sysdep-x86_64/elf.h
similarity index 100%
rename from include/asm-um/elf-x86_64.h
rename to arch/um/include/sysdep-x86_64/elf.h
diff --git a/include/asm-um/host_ldt-x86_64.h b/arch/um/include/sysdep-x86_64/host_ldt.h
similarity index 100%
rename from include/asm-um/host_ldt-x86_64.h
rename to arch/um/include/sysdep-x86_64/host_ldt.h
diff --git a/include/asm-um/module-x86_64.h b/arch/um/include/sysdep-x86_64/module.h
similarity index 100%
rename from include/asm-um/module-x86_64.h
rename to arch/um/include/sysdep-x86_64/module.h
diff --git a/include/asm-um/processor-x86_64.h b/arch/um/include/sysdep-x86_64/processor.h
similarity index 100%
rename from include/asm-um/processor-x86_64.h
rename to arch/um/include/sysdep-x86_64/processor.h
diff --git a/include/asm-um/ptrace-x86_64.h b/arch/um/include/sysdep-x86_64/ptrace-full.h
similarity index 98%
rename from include/asm-um/ptrace-x86_64.h
rename to arch/um/include/sysdep-x86_64/ptrace-full.h
index 4c47535..4dacb69 100644
--- a/include/asm-um/ptrace-x86_64.h
+++ b/arch/um/include/sysdep-x86_64/ptrace-full.h
@@ -9,7 +9,7 @@
 
 #include "linux/compiler.h"
 #include "asm/errno.h"
-#include "asm/host_ldt.h"
+#include "sysdep/host_ldt.h"
 
 #define __FRAME_OFFSETS /* Needed to get the R* macros */
 #include "asm/ptrace-generic.h"
diff --git a/include/asm-um/sigcontext-x86_64.h b/arch/um/include/sysdep-x86_64/sigcontext-full.h
similarity index 93%
rename from include/asm-um/sigcontext-x86_64.h
rename to arch/um/include/sysdep-x86_64/sigcontext-full.h
index b600e0b..b8a0d68 100644
--- a/include/asm-um/sigcontext-x86_64.h
+++ b/arch/um/include/sysdep-x86_64/sigcontext-full.h
@@ -6,7 +6,7 @@
 #ifndef __UM_SIGCONTEXT_X86_64_H
 #define __UM_SIGCONTEXT_X86_64_H
 
-#include "asm/sigcontext-generic.h"
+#include <asm/arch/sigcontext.h>
 
 #endif
 
diff --git a/include/asm-um/system-x86_64.h b/arch/um/include/sysdep-x86_64/system.h
similarity index 100%
rename from include/asm-um/system-x86_64.h
rename to arch/um/include/sysdep-x86_64/system.h
diff --git a/include/asm-um/vm-flags-x86_64.h b/arch/um/include/sysdep-x86_64/vm-flags.h
similarity index 100%
rename from include/asm-um/vm-flags-x86_64.h
rename to arch/um/include/sysdep-x86_64/vm-flags.h
diff --git a/include/asm-um/elf.h b/include/asm-um/elf.h
new file mode 100644
index 0000000..8ea111f
--- /dev/null
+++ b/include/asm-um/elf.h
@@ -0,0 +1 @@
+#include <sysdep/elf.h>
diff --git a/include/asm-um/fixmap.h b/include/asm-um/fixmap.h
index 9d2be52..a846653 100644
--- a/include/asm-um/fixmap.h
+++ b/include/asm-um/fixmap.h
@@ -4,7 +4,7 @@
 #include <asm/processor.h>
 #include <asm/system.h>
 #include <asm/kmap_types.h>
-#include <asm/archparam.h>
+#include <sysdep/archparam.h>
 #include <asm/page.h>
 
 /*
diff --git a/include/asm-um/hw_irq.h b/include/asm-um/hw_irq.h
index 1cf84cf..f2feb14 100644
--- a/include/asm-um/hw_irq.h
+++ b/include/asm-um/hw_irq.h
@@ -2,6 +2,6 @@
 #define _ASM_UM_HW_IRQ_H
 
 #include "asm/irq.h"
-#include "asm/archparam.h"
+#include <sysdep/archparam.h>
 
 #endif
diff --git a/include/asm-um/ldt.h b/include/asm-um/ldt.h
index 52af512..a7f999a 100644
--- a/include/asm-um/ldt.h
+++ b/include/asm-um/ldt.h
@@ -9,7 +9,7 @@
 #define __ASM_LDT_H
 
 #include <linux/mutex.h>
-#include "asm/host_ldt.h"
+#include <sysdep/host_ldt.h>
 
 extern void ldt_host_info(void);
 
diff --git a/include/asm-um/module.h b/include/asm-um/module.h
new file mode 100644
index 0000000..4b3bdf0
--- /dev/null
+++ b/include/asm-um/module.h
@@ -0,0 +1 @@
+#include <sysdep/module.h>
diff --git a/include/asm-um/processor.h b/include/asm-um/processor.h
new file mode 100644
index 0000000..476d55f
--- /dev/null
+++ b/include/asm-um/processor.h
@@ -0,0 +1 @@
+#include <sysdep/processor.h>
diff --git a/include/asm-um/ptrace.h b/include/asm-um/ptrace.h
new file mode 100644
index 0000000..8530714
--- /dev/null
+++ b/include/asm-um/ptrace.h
@@ -0,0 +1 @@
+#include <sysdep/ptrace-full.h>
diff --git a/include/asm-um/sigcontext-generic.h b/include/asm-um/sigcontext-generic.h
deleted file mode 100644
index 1645870..0000000
--- a/include/asm-um/sigcontext-generic.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __UM_SIGCONTEXT_GENERIC_H
-#define __UM_SIGCONTEXT_GENERIC_H
-
-#include "asm/arch/sigcontext.h"
-
-#endif
diff --git a/include/asm-um/sigcontext.h b/include/asm-um/sigcontext.h
new file mode 100644
index 0000000..f05c67e
--- /dev/null
+++ b/include/asm-um/sigcontext.h
@@ -0,0 +1 @@
+#include <sysdep/sigcontext-full.h>
diff --git a/include/asm-um/string.h b/include/asm-um/string.h
index 9a0571f..9ca64af 100644
--- a/include/asm-um/string.h
+++ b/include/asm-um/string.h
@@ -2,6 +2,6 @@
 #define __UM_STRING_H
 
 #include "asm/arch/string.h"
-#include "asm/archparam.h"
+#include <sysdep/archparam.h>
 
 #endif
diff --git a/include/asm-um/system.h b/include/asm-um/system.h
new file mode 100644
index 0000000..ad45077
--- /dev/null
+++ b/include/asm-um/system.h
@@ -0,0 +1 @@
+#include <sysdep/system.h>
diff --git a/include/asm-um/vm-flags.h b/include/asm-um/vm-flags.h
new file mode 100644
index 0000000..dd5a8a6
--- /dev/null
+++ b/include/asm-um/vm-flags.h
@@ -0,0 +1 @@
+#include <sysdep/vm-flags.h>
-- 
1.5.3.GIT

