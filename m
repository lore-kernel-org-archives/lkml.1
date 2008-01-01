Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYAANBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYAANBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbYAANBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:01:15 -0500
Received: from po-out-1718.google.com ([72.14.252.158]:36314 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbYAANBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pRBZSnswubG6F0YoQ4DkKvkuJrpn3VF6ZRrJLR1mizv5P+8zfob0zQ3iuTm1ZYqKeFMtOdHw51mtLKEDM7DYbNqlgP9yqIFd1o0SkEjTL43HoLi2wMsNs2nHDxYzLfvDRz3ZeVXefufQmC6XeZwSL8ijSGFOZILI0efMMP295FA=
Date: Tue, 1 Jan 2008 21:01:25 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net
Subject: (Try #2) [Patch 1/8] UML: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101130125.GA2499@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking> <20080101071846.GB2496@hacking> <20080101103342.GH28913@uranus.ravnborg.org> <20080101104942.GI28913@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101104942.GI28913@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 11:49:42AM +0100, Sam Ravnborg wrote:
>On Tue, Jan 01, 2008 at 11:33:42AM +0100, Sam Ravnborg wrote:
>> On Tue, Jan 01, 2008 at 03:18:46PM +0800, WANG Cong wrote:
>> > 
>> > TOPDIR is obsolete, use objtree instead.
>> > This patch removes TOPDIR from all UML Makefiles.
>> > 
>> 
>> I do not feel confident with these changes.
>> In some places I had expected to see srctree and not objtree.
>> I would like to see this tested before applying it.
>> 
>> Building a ppc toolchain now to test it...
>
>It seems that building a ppc based um kernel is not supported
>in mainline.
>Kconfig.ppc is missing and when creating it um build fails
>in sys-ppc/ due to user-offset.c is missing.
>
>As most of your patch touches ppc specific code I suggest
>to just replace TOPDIR with srctree all over (no semantic change)
>and the the um people can figure out the ppc stuff when they get to it.

You're right. I use srctree instead. And tested with:

$ make O=../foobar/ ARCH=um linux

It works fine. Thanks for your points!

-------->

TOPDIR is obsolete, use srctree instead.
This patch removes TOPDIR from all UML Makefiles.

Cc: Jeff Dike <jdike@addtoit.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/um/Makefile b/arch/um/Makefile
index ba6813a..08a2865 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -158,7 +158,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-um/$(basename $(notdir $@))-$(SUBARCH)$(suffix $@) $@
 else
-	$(Q)cd $(TOPDIR)/$(dir $@) ; \
+	$(Q)cd $(srctree)/$(dir $@) ; \
 	ln -sf $(basename $(notdir $@))-$(SUBARCH)$(suffix $@) $(notdir $@)
 endif
 
@@ -168,7 +168,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
 else
-	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
+	$(Q)cd $(srctree)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
 endif
 
 $(objtree)/$(ARCH_DIR)/include:
diff --git a/arch/um/sys-ppc/Makefile b/arch/um/sys-ppc/Makefile
index a9814a7..0890152 100644
--- a/arch/um/sys-ppc/Makefile
+++ b/arch/um/sys-ppc/Makefile
@@ -6,7 +6,7 @@ OBJ = built-in.o
 OBJS = ptrace.o sigcontext.o semaphore.o checksum.o miscthings.o misc.o \
 	ptrace_user.o sysrq.o
 
-EXTRA_AFLAGS := -DCONFIG_PPC32 -I. -I$(TOPDIR)/arch/ppc/kernel
+EXTRA_AFLAGS := -DCONFIG_PPC32 -I. -I$(srctree)/arch/ppc/kernel
 
 all: $(OBJ)
 
@@ -22,25 +22,25 @@ sigcontext.o: sigcontext.c
 
 semaphore.c:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/kernel/$@ $@
+	ln -s $(srctree)/arch/ppc/kernel/$@ $@
 
 checksum.S:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/lib/$@ $@
+	ln -s $(srctree)/arch/ppc/lib/$@ $@
 
 mk_defs.c:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/kernel/$@ $@
+	ln -s $(srctree)/arch/ppc/kernel/$@ $@
 
 ppc_defs.head:
 	rm -f $@
-	ln -s $(TOPDIR)/arch/ppc/kernel/$@ $@
+	ln -s $(srctree)/arch/ppc/kernel/$@ $@
 
 ppc_defs.h: mk_defs.c ppc_defs.head \
-		$(TOPDIR)/include/asm-ppc/mmu.h \
-		$(TOPDIR)/include/asm-ppc/processor.h \
-		$(TOPDIR)/include/asm-ppc/pgtable.h \
-		$(TOPDIR)/include/asm-ppc/ptrace.h
+		$(srctree)/include/asm-ppc/mmu.h \
+		$(srctree)/include/asm-ppc/processor.h \
+		$(srctree)/include/asm-ppc/pgtable.h \
+		$(srctree)/include/asm-ppc/ptrace.h
 #	$(CC) $(CFLAGS) -S mk_defs.c
 	cp ppc_defs.head ppc_defs.h
 # for bk, this way we can write to the file even if it's not checked out
@@ -56,13 +56,13 @@ ppc_defs.h: mk_defs.c ppc_defs.head \
 
 checksum.o: checksum.S
 	rm -f asm
-	ln -s $(TOPDIR)/include/asm-ppc asm
+	ln -s $(srctree)/include/asm-ppc asm
 	$(CC) $(EXTRA_AFLAGS) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
 	rm -f asm
 
 misc.o: misc.S ppc_defs.h
 	rm -f asm
-	ln -s $(TOPDIR)/include/asm-ppc asm
+	ln -s $(srctree)/include/asm-ppc asm
 	$(CC) $(EXTRA_AFLAGS) $(KBUILD_AFLAGS) -D__ASSEMBLY__ -D__UM_PPC__ -c $< -o $*.o
 	rm -f asm
 
