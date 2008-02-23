Return-Path: <linux-kernel-owner+w=401wt.eu-S1763074AbYBWV3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763074AbYBWV3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 16:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYBWV2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 16:28:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:64242 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbYBWV2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 16:28:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZMdwzy80/5ROpIwwkZ1IipIbrD7Cj2jk87mBwQ+MF3Ii4s+u/MJaMGjE17FEEcHvfxyzW8CEnXkDWgAs1LxCAMpyQFFjquFi4jCHXvGF/sVsUreUOcvnKwnjushwFQaf3j+ooF+eLee0GCY8dhK/oGcwXhfR2bhPoFN+pmAk8g0=
Message-ID: <e367bd3e0802231328l1eb928f5pe538264c3a42e3d2@mail.gmail.com>
Date: Sat, 23 Feb 2008 16:28:50 -0500
From: "Nicholas Marquez" <nicholas.marquez@gatech.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] More accessible usage of custom flags
In-Reply-To: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com>
X-Google-Sender-Auth: 8bbef184c6c333a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone else have any input on this?  Tips, suggestions, ideas,
comments, constructive criticism, anything at all.  I am, however,
trying to avoid a flame war.

~Nicholas (Alex) Marquez
<nicholas.marquez@gatech.edu>

On Sat, Feb 16, 2008 at 9:52 PM, Nicholas Marquez
<nicholas.marquez@gatech.edu> wrote:
> I submitted this patch to the zen-sources Gentoo community and got
>  much praise and has promptly been included.  This kind of thing have
>  very likely already been done in other patchsets, but I haven't seen
>  it around, so I've gone ahead and made one.  The idea is that one can
>  enable -Os and various other options transparently through standard
>  kernel configuration, so why bar the builder from any other options to
>  pass on to gcc (et al)?  One can indeed add one's own flags in the
>  Makefile, but this method is a good deal friendlier.  Granted, this
>  could be misused by ricers and idiots, but they'll get themselves into
>  that mess all of their own fault and we'll all go on our merry ways.
>  It just seems that much use could be made out of this, both in terms
>  of (sane) optimizations and easier access to enhanced debugging
>  opportunities.
>
>  I see that people who build a Linux kernel are largely of two types:
>  ~the ones that understand and know enough that they could, with some
>  nudging and learning, become bonafide kernel devs and
>  ~the ones that understand it to some very basic degree and can get
>  through configuring it without too much trouble (though with limited
>  understanding)
>  I believe one of the very simple things that can be addressed is to
>  make the kernel more "accessible" without harming its integrity or
>  functionality.  This involves trying to fill the gap between those two
>  types of people, allowing there to be more understanding,
>  configuration, and (down the line) development opportunities within
>  the kernel to better ease these people into learning enough to begin
>  contributing back.  More developers can only be a Good Thing (tm).
>  Though a haughty and abstract opinion/goal/thought of mine, this patch
>  conforms to it and I think that with minimal effort such a vision
>  could be implemented.  Whilst all other kernel devs are hacking away
>  at the rough and tumultuous innards of the kernel, a few people of
>  less confidence and experience (people like me) could polish the
>  outside to make it more appealing to more people. So that eventually
>  they too will sink below the surface and join the party.
>
>  Anyway, I'm not quite sure that my implementation is as clean as it
>  could be and any feedback is certainly welcome.  This is my first time
>  posting to LKML, so I fully expect to be shot down anyway.
>
>
>  ~Nicholas (Alex) Marquez
>  <nicholas.marquez@gatech.edu>
>
>  ______
>  diff -dur original/init/Kconfig modified/init/Kconfig
>  --- original/init/Kconfig    2008-02-16 20:24:22.000000000 -0500
>  +++ modified/init/Kconfig    2008-02-16 20:53:48.000000000 -0500
>  @@ -487,6 +487,52 @@
>        option.  If problems are observed, a gcc upgrade may be needed.
>
>        If unsure, say N.
>  +
>  +menu "Custom flags"
>  +
>  +config CUSTOM_CFLAGS
>  +    string "Custom CFLAGS for kernel"
>  +    default ""
>  +    help
>  +        You can use this to easily set custom gcc CFLAGS to be used for the
>  +        entire kernel (including modules).
>  +
>  +        ONLY ADD CUSTOM CFLAGS IF YOU KNOW WHAT YOU ARE DOING
>  +
>  +        If unsure, leave blank.
>  +
>  +config CUSTOM_LDFLAGS
>  +    string "Custom LDFLAGS for kernel"
>  +    default ""
>  +    help
>  +        You can use this to easily set custom gcc LDFLAGS to be used for the
>  +        entire kernel (including modules).
>  +
>  +        ONLY ADD CUSTOM LDFLAGS IF YOU KNOW WHAT YOU ARE DOING
>  +
>  +        If unsure, leave blank.
>  +
>  +config CUSTOM_AFLAGS
>  +    string "Custom AFLAGS for kernel"
>  +    default ""
>  +    help
>  +        You can use this to easily set custom gcc AFLAGS to be used for the
>  +        entire kernel (including modules).
>  +
>  +        ONLY ADD CUSTOM AFLAGS IF YOU KNOW WHAT YOU ARE DOING
>  +
>  +        If unsure, leave blank.
>  +
>  +config CUSTOM_MAKEFLAGS
>  +    string "Custom MAKEFLAGS for kernel"
>  +    default ""
>  +    help
>  +        You can use this to easily set custom MAKEFLAGS to be used for building
>  +        the entire kernel.
>  +
>  +        If unsure, leave blank.
>  +
>  +endmenu
>
>   config SYSCTL
>      bool
>  diff -dur original/Makefile modified/Makefile
>  --- original/Makefile    2008-02-16 20:15:58.000000000 -0500
>  +++ modified/Makefile    2008-02-16 20:35:55.000000000 -0500
>  @@ -14,7 +14,7 @@
>   # o  use make's built-in rules and variables
>   #    (this increases performance and avoids hard-to-debug behaviour);
>   # o  print "Entering directory ...";
>  -MAKEFLAGS += -rR --no-print-directory
>  +MAKEFLAGS += -rR --no-print-directory $(CUSTOM_MAKEFLAGS)
>
>   # We are using a recursive build, so we need to do a little thinking
>   # to get the ordering right.
>  @@ -315,11 +315,11 @@
>
>   CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__
>  -Wbitwise $(CF)
>   MODFLAGS    = -DMODULE
>  -CFLAGS_MODULE   = $(MODFLAGS)
>  -AFLAGS_MODULE   = $(MODFLAGS)
>  -LDFLAGS_MODULE  =
>  -CFLAGS_KERNEL    =
>  -AFLAGS_KERNEL    =
>  +CFLAGS_MODULE   = $(MODFLAGS) $(CUSTOM_CFLAGS)
>  +AFLAGS_MODULE   = $(MODFLAGS) $(CUSTOM_AFLAGS)
>  +LDFLAGS_MODULE  = $(CUSTOM_LDFLAGS)
>  +CFLAGS_KERNEL    = $(CUSTOM_CFLAGS)
>  +AFLAGS_KERNEL    = $(CUSTOM_AFLAGS)
>
>
>   # Use LINUXINCLUDE when you must reference the include/ directory.
>  @@ -525,6 +525,10 @@
>   KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
>   endif
>
>  +# Apply custom flags
>  +KBUILD_CFLAGS    += $(CUSTOM_CFLAGS)
>  +KBUILD_AFLAGS    += $(CUSTOM_AFLAGS)
>  +
>   # Force gcc to behave correct even for buggy distributions
>   KBUILD_CFLAGS         += $(call cc-option, -fno-stack-protector)
>
>  @@ -560,7 +564,7 @@
>   LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
>                    $(call ld-option, -Wl$(comma)--build-id,))
>   LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
>  -LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
>  +LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID) $(CUSTOM_LDFLAGS)
>
>   # Default kernel image to build when no specific target is given.
>   # KBUILD_IMAGE may be overruled on the command line or
>
