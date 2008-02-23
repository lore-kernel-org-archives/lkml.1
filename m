Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYBWW2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYBWW2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 17:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYBWW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 17:28:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:59507 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYBWW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 17:28:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=vy2Wsuj4DPrJOAcmTpumRCAjyvUQ/SkODK7pA/cVdl9UfW25ajQn3GtDJtaUivGJReeDU4n68yE1RwLsGLCSsOQoXVGKO9d28jTgZAxaczj1c2KSYSk97mH3bCzeEv+Y9gn7RlhvBzUGZdm52JUEPG8xEcG1RKnFK8Z1yBL0LN8=
Message-ID: <e367bd3e0802231428k11a7d8ddgdfafacfba4c4d078@mail.gmail.com>
Date: Sat, 23 Feb 2008 17:28:23 -0500
From: "Nicholas Marquez" <nicholas.marquez@gatech.edu>
To: "Nick Andrew" <nick@nick-andrew.net>
Subject: Re: [PATCH] More accessible usage of custom flags
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080223220458.GA3496@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com>
	 <e367bd3e0802231328l1eb928f5pe538264c3a42e3d2@mail.gmail.com>
	 <20080223220458.GA3496@tull.net>
X-Google-Sender-Auth: a7f6880040ef8601
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all, thanks for the input!

On Sat, Feb 23, 2008 at 5:04 PM, Nick Andrew <nick@nick-andrew.net> wrote:
> On Sat, Feb 23, 2008 at 04:28:50PM -0500, Nicholas Marquez wrote:
>  > Does anyone else have any input on this?  Tips, suggestions, ideas,
>  > comments, constructive criticism, anything at all.  I am, however,
>  > trying to avoid a flame war.
>
>  I missed it the first time you posted it, so thanks for resending.
>
>
>  > On Sat, Feb 16, 2008 at 9:52 PM, Nicholas Marquez
>  > <nicholas.marquez@gatech.edu> wrote:
>  > > I submitted this patch to the zen-sources Gentoo community and got
>  > >  much praise and has promptly been included.  This kind of thing have
>  > >  very likely already been done in other patchsets, but I haven't seen
>  > >  it around, so I've gone ahead and made one.  The idea is that one can
>  > >  enable -Os and various other options transparently through standard
>  > >  kernel configuration, so why bar the builder from any other options to
>  > >  pass on to gcc (et al)?  One can indeed add one's own flags in the
>  > >  Makefile, but this method is a good deal friendlier.
>
>  Does using this patch reduce the safety of the kernel build at all? i.e.
>  is it more likely to build different parts of the kernel with
>  incompatible options with this patch, compared to if the options were
>  specified in the Makefile?

There are a few places in the Makefile where options would need to be
entered.  This just brings those places together in a clean manner and
allows for one to set the flags via the configuration interface.
Though it would be excellent if the kernel had more gcc
micro-optimization (facilitated by such features as the upcoming gcc
4.3's -finstrument-functions-exclude-function-list option), general
CFLAGS used for the entire kernel do not impact the safety of the
kernel build, assuming that the options are sane.  It would be
interesting, however, to see an initiative to tune gcc flags for
important functions and  sections within the kernel for optimal
performance given some sort of envisioned usage.  (*hint, kernel devs,
hint*)

>
>
>  > >  I see that people who build a Linux kernel are largely of two types:
>  > >  ~the ones that understand and know enough that they could, with some
>  > >  nudging and learning, become bonafide kernel devs and
>  > >  ~the ones that understand it to some very basic degree and can get
>  > >  through configuring it without too much trouble (though with limited
>  > >  understanding)
>
>  I'm currently cleaning up the Kconfig help descriptions to try to help
>  the second group of people. Also I think there's a spectrum of
>  capabilities involved. I'd like kernel building to be a fun and useful
>  activity for a wider group of people :-)

I praise and applaud your efforts.

>
>
>  > >  Whilst all other kernel devs are hacking away
>  > >  at the rough and tumultuous innards of the kernel, a few people of
>  > >  less confidence and experience (people like me) could polish the
>  > >  outside to make it more appealing to more people.
>
>  Heh, that includes me too.
>
>
>  > >  ______
>  > >  diff -dur original/init/Kconfig modified/init/Kconfig
>  > >  --- original/init/Kconfig    2008-02-16 20:24:22.000000000 -0500
>  > >  +++ modified/init/Kconfig    2008-02-16 20:53:48.000000000 -0500
>
>  I've just started using StGit and it makes it a lot easier to make, send
>  and manage patches. You should take a look at it.
>
>
>  > >  @@ -487,6 +487,52 @@
>  > >        option.  If problems are observed, a gcc upgrade may be needed.
>  > >
>  > >        If unsure, say N.
>  > >  +
>  > >  +menu "Custom flags"
>  > >  +
>  > >  +config CUSTOM_CFLAGS
>  > >  +    string "Custom CFLAGS for kernel"
>  > >  +    default ""
>  > >  +    help
>  > >  +        You can use this to easily set custom gcc CFLAGS to be used for the
>  > >  +        entire kernel (including modules).
>  > >  +
>  > >  +        ONLY ADD CUSTOM CFLAGS IF YOU KNOW WHAT YOU ARE DOING
>  > >  +
>  > >  +        If unsure, leave blank.
>
>  Sorry, but I don't think we need shouting. There are a few options
>  already which have bad results if you unknowingly choose the wrong option,
>  like enabling EMBEDDED and turning off the BLOCK layer, yet the help
>  description doesn't shout.

Sorry about that.  I didn't mean to portray it as "shouting" so much
as a very visible and stern warning.

>
>  Can I suggest:
>
>
>         help
>           You can use this to easily set custom gcc CFLAGS to be used
>           for the entire kernel build process (including modules).
>
>           Compiler flags can be used for increasing or reducing
>           optimisation, enabling debugging, cross compilation
>           and so on.
>
>           If unsure, leave blank.

Something else that could be included is a link to the manual for the
(currently used) gcc's command flags
(http://gcc.gnu.org/onlinedocs/gcc-4.2.3/gcc/index.html#toc_Invoking-GCC)
or at least to the online docs, considering that specifying one
specific gcc version's manual would yield various issues.

>
>  The boilerplate "If unsure, leave blank" covers (or is meant to cover)
>  the situation where the user does not know what they are doing. It says
>  "If you don't know what you are doing, just leave this field blank,
>  and everything will be OK" ... except it is put in a non-threatening,
>  non-demeaning way.
>
>  The paragraph in the middle enhances the "help" component of the help
>  description, by saying why you might want to use that option.

I feel that perhaps it is a bit silly to put in such description, as
one using the flags should only do so in knowing specifically which
ones they wish to use and why ahead of time.  However, it cannot hurt
to put in more help documentation, so it's a fine suggestion.

>
>  > >  +config CUSTOM_LDFLAGS
>  > >  [...]
>  > >  +config CUSTOM_AFLAGS
>  > >  [...]
>  > >  +config CUSTOM_MAKEFLAGS
>  > >  [...]
>
>  Similar comments apply.
>
>  Nick.
>  --
>  PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
>  PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
>

Can anyone tell me if the implementation I chose looks alright?  The
kernel has an, understandably, large, complex, and tad messy
buildsystem, so it is troublesome to discover whether all the
appropriate codepaths are being hit that involve using these flags.


~Nicholas (Alex) Marquez
<nicholas.marquez@gatech.edu>
