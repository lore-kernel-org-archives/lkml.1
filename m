Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYAAHSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYAAHSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 02:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYAAHSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 02:18:38 -0500
Received: from po-out-1718.google.com ([72.14.252.153]:48545 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYAAHSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 02:18:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=x5cW3ArdfxGHgbvufNXAuysa8UzLLtRgxriGglvqi+I37IkSh/S65UR8pr0jrzYs3UZ8wa+awdtvVELoqj2VPZtg897AyeBez92T2RcNwET2yhy3j9gfywwc+xzYrT2SYQk6Jqc+PWgastMv8tE5PnCFqd/DRdMSPdvQ7zRfBWo=
Date: Tue, 1 Jan 2008 15:18:46 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch 1/8] UML: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101071846.GB2496@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101071311.GA2496@hacking>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TOPDIR is obsolete, use objtree instead.
This patch removes TOPDIR from all UML Makefiles.

Cc: Jeff Dike <jdike@addtoit.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/um/Makefile b/arch/um/Makefile
index ba6813a..57491af 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -158,7 +158,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-um/$(basename $(notdir $@))-$(SUBARCH)$(suffix $@) $@
 else
-	$(Q)cd $(TOPDIR)/$(dir $@) ; \
+	$(Q)cd $(objtree)/$(dir $@) ; \
 	ln -sf $(basename $(notdir $@))-$(SUBARCH)$(suffix $@) $(notdir $@)
 endif
 
@@ -168,7 +168,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
 else
-	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
+	$(Q)cd $(objtree)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
 endif
 
 $(objtree)/$(ARCH_DIR)/include:
diff --git a/arch/um/sys-ppc/Makefile b/arch/um/sys-ppc/Makefile
index a9814a7..a3cfae7 100644
--- a/arch/um/sys-ppc/Makefile
+++ b/arch/um/sys-ppc/Makefile
@@ -6,7 +6,7 @@ OBJ = built-in.o
 OBJS = ptrace.o sigcontext.o semaphore.o checksum.o miscthings.o misc.o \
 	ptrace_user.o sysrq.o
 
-EXTRA_AFLAGS := -DCONFIG_PPC32 -I. -I$(TOPDIR)/arch/ppc/kernel
+EXTRA_AFLAGS := -DCONFIG_PPC32 -I. -I$(objtree)/arch/ppc/kernel
 
 all: $(OBJ)
 
@@ -22,25 +22,25 @@ sigcontext.o: sigcontext.c
 
 semaphore.c:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/kernel/$@ $@
+	ln -s $(objtree)/arch/ppc/kernel/$@ $@
 
 checksum.S:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/lib/$@ $@
+	ln -s $(objtree)/arch/ppc/lib/$@ $@
 
 mk_defs.c:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/kernel/$@ $@
+	ln -s $(objtree)/arch/ppc/kernel/$@ $@
 
 ppc_defs.head:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/kernel/$@ $@
+	ln -s $(objtree)/arch/ppc/kernel/$@ $@
 
 ppc_defs.h: mk_defs.c ppc_defs.head \
-		$(TOPDIR)/include/asm-ppc/mmu.h \
-		$(TOPDIR)/include/asm-ppc/processor.h \
-		$(TOPDIR)/include/asm-ppc/pgtable.h \
-		$(TOPDIR)/include/asm-ppc/ptrace.h
+		$(objtree)/include/asm-ppc/mmu.h \
+		$(objtree)/include/asm-ppc/processor.h \
+		$(objtree)/include/asm-ppc/pgtable.h \
+		$(objtree)/include/asm-ppc/ptrace.h
 #	$(CC) $(CFLAGS) -S mk_defs.c
 	cp ppc_defs.head ppc_defs.h
 # for bk, this way we can write to the file even if it's not checked out
@@ -56,13 +56,13 @@ ppc_defs.h: mk_defs.c ppc_defs.head \
 
 checksum.o: checksum.S
 	rm -f asm
-	ln -s $(TOPDIR)/include/asm-ppc asm
+	ln -s $(objtree)/include/asm-ppc asm
 	$(CC) $(EXTRA_AFLAGS) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
 	rm -f asm
 
 misc.o: misc.S ppc_defs.h
 	rm -f asm
-	ln -s $(TOPDIR)/include/asm-ppc asm
+	ln -s $(objtree)/include/asm-ppc asm
 	$(CC) $(EXTRA_AFLAGS) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
 	rm -f asm
 
diff --git a/arch/x86/Makefile_32 b/arch/x86/Makefile_32
