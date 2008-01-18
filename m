Return-Path: <linux-kernel-owner+w=401wt.eu-S1765315AbYARVeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765315AbYARVeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757303AbYARVd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:33:56 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37506 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759358AbYARVd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:33:56 -0500
Date: Fri, 18 Jan 2008 22:34:02 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes for v2.6.24
Message-ID: <20080118213402.GB20904@uranus.ravnborg.org>
References: <20080118154809.GA18248@elte.hu> <20080118191249.GA20384@uranus.ravnborg.org> <20080118205152.GF3079@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118205152.GF3079@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 09:51:52PM +0100, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > @@ -1088,7 +1088,7 @@ CLEAN_FILES +=	vmlinux System.map \
> > >                  .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
> > >  
> > >  # Directories & files removed with 'make mrproper'
> > > -MRPROPER_DIRS  += include/config include2 usr/include
> > > +MRPROPER_DIRS  += include/config include2 usr/include arch/i386 arch/x86_64
> > sigh - arch specific stuff in the top-level Makefile.
> > This really belongs in arch/x86/Makefile
> 
> is this a NACK? Can clean this up in v2.6.25, but this seemed the only 
> simple solution for v2.6.24.

I would have preferred following solution.
And then the directory is killed during make clean as
opposed to make mrproper.

Not tested but seemed obvious.

	Sam

diff --git a/arch/x86/Makefile_32 b/arch/x86/Makefile_32
index 50394da..f806cec 100644
--- a/arch/x86/Makefile_32
+++ b/arch/x86/Makefile_32
@@ -156,7 +156,8 @@ install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
 
 archclean:
-	$(Q)rm -rf $(objtree)/arch/i386/boot
+	$(Q)rm -rf $(objtree)/arch/i386
+	$(Q)rm -rf $(objtree)/arch/x86_64
 	$(Q)$(MAKE) $(clean)=arch/x86/boot
 
 define archhelp
diff --git a/arch/x86/Makefile_64 b/arch/x86/Makefile_64
index a804860..93cf177 100644
--- a/arch/x86/Makefile_64
+++ b/arch/x86/Makefile_64
@@ -123,7 +123,8 @@ endif
 	$(Q)$(MAKE) $(build)=arch/x86/vdso $@
 
 archclean:
-	$(Q)rm -rf $(objtree)/arch/x86_64/boot
+	$(Q)rm -rf $(objtree)/arch/i386
+	$(Q)rm -rf $(objtree)/arch/x86_64
 	$(Q)$(MAKE) $(clean)=$(boot)
 
 define archhelp
