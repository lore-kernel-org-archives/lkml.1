Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYBWXjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYBWXjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYBWXjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:39:40 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:33760 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1753662AbYBWXjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:39:39 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 24 Feb 2008 10:39:06 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Nicholas Marquez <nicholas.marquez@gatech.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] More accessible usage of custom flags
Message-ID: <20080223233906.GA18845@tull.net>
References: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com> <e367bd3e0802231328l1eb928f5pe538264c3a42e3d2@mail.gmail.com> <20080223220458.GA3496@tull.net> <e367bd3e0802231428k11a7d8ddgdfafacfba4c4d078@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e367bd3e0802231428k11a7d8ddgdfafacfba4c4d078@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 05:28:23PM -0500, Nicholas Marquez wrote:
> First of all, thanks for the input!
> 
> On Sat, Feb 23, 2008 at 5:04 PM, Nick Andrew <nick@nick-andrew.net> wrote:
> > On Sat, Feb 23, 2008 at 04:28:50PM -0500, Nicholas Marquez wrote:
>
> There are a few places in the Makefile where options would need to be
> entered.  This just brings those places together in a clean manner and
> allows for one to set the flags via the configuration interface.
> Though it would be excellent if the kernel had more gcc
> micro-optimization (facilitated by such features as the upcoming gcc
> 4.3's -finstrument-functions-exclude-function-list option), general
> CFLAGS used for the entire kernel do not impact the safety of the
> kernel build, assuming that the options are sane.  It would be
> interesting, however, to see an initiative to tune gcc flags for
> important functions and  sections within the kernel for optimal
> performance given some sort of envisioned usage.  (*hint, kernel devs,
> hint*)

If there are some "common" optimisation flags or sets of flags then
maybe they could be turned on/off by invididual config options? There's
already CC_OPTIMIZE_FOR_SIZE sorta tagged as experimental. But then,
enumerating the allowable flags may limit the user's choices whereas I
take it you'd like to expand them.

> >  > >  @@ -487,6 +487,52 @@
> >  > >        option.  If problems are observed, a gcc upgrade may be needed.
> >  > >
> >  > >        If unsure, say N.
> >  > >  +
> >  > >  +menu "Custom flags"
> >  > >  +
> >  > >  +config CUSTOM_CFLAGS
> >  > >  +    string "Custom CFLAGS for kernel"
> >  > >  +    default ""
> >  > >  +    help
> >  > >  +        You can use this to easily set custom gcc CFLAGS to be used for the
> >  > >  +        entire kernel (including modules).
> >  > >  +
> >  > >  +        ONLY ADD CUSTOM CFLAGS IF YOU KNOW WHAT YOU ARE DOING
> >  > >  +
> >  > >  +        If unsure, leave blank.
> >
> >  Sorry, but I don't think we need shouting. There are a few options
> >  already which have bad results if you unknowingly choose the wrong option,
> >  like enabling EMBEDDED and turning off the BLOCK layer, yet the help
> >  description doesn't shout.
> 
> Sorry about that.  I didn't mean to portray it as "shouting" so much
> as a very visible and stern warning.

I'm hoping we don't need any stern warnings in the kernel configuration.
Although I expect configuring bogus gcc flags is going to break the
build far worse than selecting bad options otherwise. If the user
makes a mistake in CUSTOM_CFLAGS is the build going to fail with
a message "error in CUSTOM_CFLAGS" or is it going to spew out pages
of gcc error messages?  It is nice if error messages can point back
to the source of the error, so the user doesn't have to look through
the entire kernel configuration for what they did wrong.

> Something else that could be included is a link to the manual for the
> (currently used) gcc's command flags
> (http://gcc.gnu.org/onlinedocs/gcc-4.2.3/gcc/index.html#toc_Invoking-GCC)
> or at least to the online docs, considering that specifying one
> specific gcc version's manual would yield various issues.

"info gcc" will give all that information in far more detail than I
have time to read.

> >  The boilerplate "If unsure, leave blank" covers (or is meant to cover)
> >  the situation where the user does not know what they are doing. It says
> >  "If you don't know what you are doing, just leave this field blank,
> >  and everything will be OK" ... except it is put in a non-threatening,
> >  non-demeaning way.
> >
> >  The paragraph in the middle enhances the "help" component of the help
> >  description, by saying why you might want to use that option.
> 
> I feel that perhaps it is a bit silly to put in such description, as
> one using the flags should only do so in knowing specifically which
> ones they wish to use and why ahead of time.  However, it cannot hurt
> to put in more help documentation, so it's a fine suggestion.

Well, it can't be both silly and a fine suggestion. Does it dumb down
the kernel configuration process too much?

I don't want a single person to say "I can't configure this kernel
because I don't know what to answer for the CUSTOM_CFLAGS question"
and I think the "If unsure, leave blank" at the bottom covers that
problem. But I assume you want to encourage experimentation; there
will be a person with a bit higher level of skill who might want
to start tweaking. Here's something they can start tweaking.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
