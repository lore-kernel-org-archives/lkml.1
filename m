Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYBWWGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYBWWGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 17:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYBWWG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 17:06:27 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:47173 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751940AbYBWWG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 17:06:27 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 24 Feb 2008 09:04:58 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Nicholas Marquez <nicholas.marquez@gatech.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] More accessible usage of custom flags
Message-ID: <20080223220458.GA3496@tull.net>
References: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com> <e367bd3e0802231328l1eb928f5pe538264c3a42e3d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e367bd3e0802231328l1eb928f5pe538264c3a42e3d2@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 04:28:50PM -0500, Nicholas Marquez wrote:
> Does anyone else have any input on this?  Tips, suggestions, ideas,
> comments, constructive criticism, anything at all.  I am, however,
> trying to avoid a flame war.

I missed it the first time you posted it, so thanks for resending.

> On Sat, Feb 16, 2008 at 9:52 PM, Nicholas Marquez
> <nicholas.marquez@gatech.edu> wrote:
> > I submitted this patch to the zen-sources Gentoo community and got
> >  much praise and has promptly been included.  This kind of thing have
> >  very likely already been done in other patchsets, but I haven't seen
> >  it around, so I've gone ahead and made one.  The idea is that one can
> >  enable -Os and various other options transparently through standard
> >  kernel configuration, so why bar the builder from any other options to
> >  pass on to gcc (et al)?  One can indeed add one's own flags in the
> >  Makefile, but this method is a good deal friendlier.

Does using this patch reduce the safety of the kernel build at all? i.e.
is it more likely to build different parts of the kernel with
incompatible options with this patch, compared to if the options were
specified in the Makefile?

> >  I see that people who build a Linux kernel are largely of two types:
> >  ~the ones that understand and know enough that they could, with some
> >  nudging and learning, become bonafide kernel devs and
> >  ~the ones that understand it to some very basic degree and can get
> >  through configuring it without too much trouble (though with limited
> >  understanding)

I'm currently cleaning up the Kconfig help descriptions to try to help
the second group of people. Also I think there's a spectrum of
capabilities involved. I'd like kernel building to be a fun and useful
activity for a wider group of people :-)

> >  Whilst all other kernel devs are hacking away
> >  at the rough and tumultuous innards of the kernel, a few people of
> >  less confidence and experience (people like me) could polish the
> >  outside to make it more appealing to more people.

Heh, that includes me too.

> >  ______
> >  diff -dur original/init/Kconfig modified/init/Kconfig
> >  --- original/init/Kconfig    2008-02-16 20:24:22.000000000 -0500
> >  +++ modified/init/Kconfig    2008-02-16 20:53:48.000000000 -0500

I've just started using StGit and it makes it a lot easier to make, send
and manage patches. You should take a look at it.

> >  @@ -487,6 +487,52 @@
> >        option.  If problems are observed, a gcc upgrade may be needed.
> >
> >        If unsure, say N.
> >  +
> >  +menu "Custom flags"
> >  +
> >  +config CUSTOM_CFLAGS
> >  +    string "Custom CFLAGS for kernel"
> >  +    default ""
> >  +    help
> >  +        You can use this to easily set custom gcc CFLAGS to be used for the
> >  +        entire kernel (including modules).
> >  +
> >  +        ONLY ADD CUSTOM CFLAGS IF YOU KNOW WHAT YOU ARE DOING
> >  +
> >  +        If unsure, leave blank.

Sorry, but I don't think we need shouting. There are a few options
already which have bad results if you unknowingly choose the wrong option,
like enabling EMBEDDED and turning off the BLOCK layer, yet the help
description doesn't shout.

Can I suggest:

	help
	  You can use this to easily set custom gcc CFLAGS to be used
	  for the entire kernel build process (including modules).

	  Compiler flags can be used for increasing or reducing
	  optimisation, enabling debugging, cross compilation
	  and so on.

	  If unsure, leave blank.

The boilerplate "If unsure, leave blank" covers (or is meant to cover)
the situation where the user does not know what they are doing. It says
"If you don't know what you are doing, just leave this field blank,
and everything will be OK" ... except it is put in a non-threatening,
non-demeaning way.

The paragraph in the middle enhances the "help" component of the help
description, by saying why you might want to use that option.

> >  +config CUSTOM_LDFLAGS
> >  [...]
> >  +config CUSTOM_AFLAGS
> >  [...]
> >  +config CUSTOM_MAKEFLAGS
> >  [...]

Similar comments apply.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
