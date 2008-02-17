Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbYBQVHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbYBQVHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYBQVHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:07:05 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48120 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbYBQVHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:07:04 -0500
Date: Sun, 17 Feb 2008 22:07:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       pavel@suse.cz, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2] Re: 2.6.25-rc2-mm1 (wakeup)
Message-ID: <20080217210710.GA15284@uranus.ravnborg.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7B9AF.2030006@zytor.com> <47B7BC4C.8070502@oracle.com> <200802172140.16055.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802172140.16055.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 09:40:15PM +0100, Rafael J. Wysocki wrote:
> On Sunday, 17 of February 2008, Randy Dunlap wrote:
> > H. Peter Anvin wrote:
> > > Randy Dunlap wrote:
> > >> On Sat, 16 Feb 2008 19:58:06 -0800 H. Peter Anvin wrote:
> > >>
> > >>> Randy Dunlap wrote:
> > >>>> Yes, adding -m32 to the X86_32 config ccflags (as is done for the
> > >>>> X86_64 case) makes it build for me.  (like patch below)
> > >>>>
> > >>> It's wrong, though, because you can't assume a 32-bit compiler knows 
> > >>> about -m32.
> > >>>
> > >>> You need $(call cc-option,-m32).
> > >>
> > >> -cflags-$(CONFIG_X86_32) :=
> > >> +cflags-$(CONFIG_X86_32) := $(call cc-option, -m32)
> > >>  cflags-$(CONFIG_X86_64) := -m32
> > > 
> > > I think this works for both; that's what we do for arch/x86/boot.
> > 
> > OK, that makes sense.  I think I'll let Rafael complete it.
> 
> OK, so that would be the appended patch.
> 
> Still, since there are several fixes against the "move the wakeup code to C"
> patch, I'll probably fold them all into a new version of this patch and resend
> it.
> 
> Thanks,
> Rafael
> 
> ---
>  arch/x86/kernel/acpi/realmode/Makefile |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/acpi/realmode/Makefile
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/acpi/realmode/Makefile
> +++ linux-2.6/arch/x86/kernel/acpi/realmode/Makefile
> @@ -27,8 +27,6 @@ bootsrc		:= $(src)/../../../boot
>  # How to compile the 16-bit code.  Note we always compile for -march=i386,
>  # that way we can complain to the user if the CPU is insufficient.
>  # Compile with _SETUP since this is similar to the boot-time setup code.
> -cflags-$(CONFIG_X86_32) :=
> -cflags-$(CONFIG_X86_64) := -m32
>  KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D_WAKEUP -D__KERNEL__ \
>  		   -I$(srctree)/$(bootsrc) \
>  		   $(cflags-y) \
> @@ -41,6 +39,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
>  			$(call cc-option, -fno-unit-at-a-time)) \
>  		   $(call cc-option, -fno-stack-protector) \
>  		   $(call cc-option, -mpreferred-stack-boundary=2)
> +KBUILD_CFLAGS	+= $(call cc-option, -m32)

For a 64 bit build we should error out if the compiler
fials to support -m32 (how unlikely that may be).
So I would prefer it unconditional for 64 bit.

But nit picking - I know.

	Sam
