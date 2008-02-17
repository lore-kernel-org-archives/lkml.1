Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbYBQUl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbYBQUl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYBQUlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:41:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39315 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYBQUlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:41:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v2] Re: 2.6.25-rc2-mm1 (wakeup)
Date: Sun, 17 Feb 2008 21:40:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>, sam@ravnborg.org
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7B9AF.2030006@zytor.com> <47B7BC4C.8070502@oracle.com>
In-Reply-To: <47B7BC4C.8070502@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802172140.16055.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of February 2008, Randy Dunlap wrote:
> H. Peter Anvin wrote:
> > Randy Dunlap wrote:
> >> On Sat, 16 Feb 2008 19:58:06 -0800 H. Peter Anvin wrote:
> >>
> >>> Randy Dunlap wrote:
> >>>> Yes, adding -m32 to the X86_32 config ccflags (as is done for the
> >>>> X86_64 case) makes it build for me.  (like patch below)
> >>>>
> >>> It's wrong, though, because you can't assume a 32-bit compiler knows 
> >>> about -m32.
> >>>
> >>> You need $(call cc-option,-m32).
> >>
> >> -cflags-$(CONFIG_X86_32) :=
> >> +cflags-$(CONFIG_X86_32) := $(call cc-option, -m32)
> >>  cflags-$(CONFIG_X86_64) := -m32
> > 
> > I think this works for both; that's what we do for arch/x86/boot.
> 
> OK, that makes sense.  I think I'll let Rafael complete it.

OK, so that would be the appended patch.

Still, since there are several fixes against the "move the wakeup code to C"
patch, I'll probably fold them all into a new version of this patch and resend
it.

Thanks,
Rafael

---
 arch/x86/kernel/acpi/realmode/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/realmode/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/realmode/Makefile
+++ linux-2.6/arch/x86/kernel/acpi/realmode/Makefile
@@ -27,8 +27,6 @@ bootsrc		:= $(src)/../../../boot
 # How to compile the 16-bit code.  Note we always compile for -march=i386,
 # that way we can complain to the user if the CPU is insufficient.
 # Compile with _SETUP since this is similar to the boot-time setup code.
-cflags-$(CONFIG_X86_32) :=
-cflags-$(CONFIG_X86_64) := -m32
 KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D_WAKEUP -D__KERNEL__ \
 		   -I$(srctree)/$(bootsrc) \
 		   $(cflags-y) \
@@ -41,6 +39,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 			$(call cc-option, -fno-unit-at-a-time)) \
 		   $(call cc-option, -fno-stack-protector) \
 		   $(call cc-option, -mpreferred-stack-boundary=2)
+KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
 WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
