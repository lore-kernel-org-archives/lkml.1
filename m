Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbYBXJgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbYBXJgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 04:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYBXJg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 04:36:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:11589 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbYBXJgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 04:36:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GQtEGkpgY8osgWD8bGjn4GV8GDLipQ9BrlHSbJx+17i8DDfc3HVCJgo1o71rPm9neDys7/Jj7YGGJMsnEXrsxL8LeD4sRcTKHJsrL09/7se2WYh9qeDRtO4xmXEBO7W9H6kL7qc6ZaKltOqBNOwg6fJkRJ3mR1zVm7+M1aVVaRc=
Message-ID: <e367bd3e0802240136kf9d30b9xfbaa84fa3e05661d@mail.gmail.com>
Date: Sun, 24 Feb 2008 04:36:24 -0500
From: "Nicholas Marquez" <nicholas.marquez@gatech.edu>
To: "Nick Andrew" <nick@nick-andrew.net>
Subject: Re: [PATCH] More accessible usage of custom flags
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080223233906.GA18845@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com>
	 <e367bd3e0802231328l1eb928f5pe538264c3a42e3d2@mail.gmail.com>
	 <20080223220458.GA3496@tull.net>
	 <e367bd3e0802231428k11a7d8ddgdfafacfba4c4d078@mail.gmail.com>
	 <20080223233906.GA18845@tull.net>
X-Google-Sender-Auth: 3a831ba2ef341e9a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 6:39 PM, Nick Andrew <nick@nick-andrew.net> wrote:
> On Sat, Feb 23, 2008 at 05:28:23PM -0500, Nicholas Marquez wrote:
>  > First of all, thanks for the input!
>  >
>  > On Sat, Feb 23, 2008 at 5:04 PM, Nick Andrew <nick@nick-andrew.net> wrote:
>  > > On Sat, Feb 23, 2008 at 04:28:50PM -0500, Nicholas Marquez wrote:
>  >
>
> > There are a few places in the Makefile where options would need to be
>  > entered.  This just brings those places together in a clean manner and
>  > allows for one to set the flags via the configuration interface.
>  > Though it would be excellent if the kernel had more gcc
>  > micro-optimization (facilitated by such features as the upcoming gcc
>  > 4.3's -finstrument-functions-exclude-function-list option), general
>  > CFLAGS used for the entire kernel do not impact the safety of the
>  > kernel build, assuming that the options are sane.  It would be
>  > interesting, however, to see an initiative to tune gcc flags for
>  > important functions and  sections within the kernel for optimal
>  > performance given some sort of envisioned usage.  (*hint, kernel devs,
>  > hint*)
>
>  If there are some "common" optimisation flags or sets of flags then
>  maybe they could be turned on/off by invididual config options? There's
>  already CC_OPTIMIZE_FOR_SIZE sorta tagged as experimental. But then,
>  enumerating the allowable flags may limit the user's choices whereas I
>  take it you'd like to expand them.

Yes, I would like to expand them.  If possibly, I'd like to take out
the individual config options for gcc flags and integrate them into
the help description.  I feel that the redundancy would not only be
ugly, but possibly confusing.
- Show quoted text -


>
>
>  > >  > >  @@ -487,6 +487,52 @@
>  > >  > >        option.  If problems are observed, a gcc upgrade may be needed.
>  > >  > >
>  > >  > >        If unsure, say N.
>  > >  > >  +
>  > >  > >  +menu "Custom flags"
>  > >  > >  +
>  > >  > >  +config CUSTOM_CFLAGS
>  > >  > >  +    string "Custom CFLAGS for kernel"
>  > >  > >  +    default ""
>  > >  > >  +    help
>  > >  > >  +        You can use this to easily set custom gcc CFLAGS to be used for the
>  > >  > >  +        entire kernel (including modules).
>  > >  > >  +
>  > >  > >  +        ONLY ADD CUSTOM CFLAGS IF YOU KNOW WHAT YOU ARE DOING
>  > >  > >  +
>  > >  > >  +        If unsure, leave blank.
>  > >
>  > >  Sorry, but I don't think we need shouting. There are a few options
>  > >  already which have bad results if you unknowingly choose the wrong option,
>  > >  like enabling EMBEDDED and turning off the BLOCK layer, yet the help
>  > >  description doesn't shout.
>  >
>  > Sorry about that.  I didn't mean to portray it as "shouting" so much
>  > as a very visible and stern warning.
>
>  I'm hoping we don't need any stern warnings in the kernel configuration.
>  Although I expect configuring bogus gcc flags is going to break the
>  build far worse than selecting bad options otherwise. If the user
>  makes a mistake in CUSTOM_CFLAGS is the build going to fail with
>  a message "error in CUSTOM_CFLAGS" or is it going to spew out pages
>  of gcc error messages?  It is nice if error messages can point back
>  to the source of the error, so the user doesn't have to look through
>  the entire kernel configuration for what they did wrong.

I hadn't thought of that.  It would certainly be more useful than a
stern warning.  ^^;  Have you any ideas on how to implement such a
thing?  I would imagine a configure-script-like test on the flags to
make sure that gcc could take them correctly would be in order.  Then
one could also capture any warnings or errors that gcc outputs (such
as redundant flags, improper invocation, etc.), fail the build, and
output the messages.  As far as capturing dangerous flags for the
kernel (such as -ffast-math or -fmerge-all-constants), there could be
a blacklist... but that would depend on the gcc version used... :/
Perhaps the automated catching of errors and warnings would be best
alone.
>
>
>  > Something else that could be included is a link to the manual for the
>  > (currently used) gcc's command flags
>  > (http://gcc.gnu.org/onlinedocs/gcc-4.2.3/gcc/index.html#toc_Invoking-GCC)
>  > or at least to the online docs, considering that specifying one
>  > specific gcc version's manual would yield various issues.
>
>  "info gcc" will give all that information in far more detail than I
>  have time to read.

I believe you misunderstand.  I mean to include the link in the help
message.  Like how the links to the appropriate sites for device
drivers are included in their help messages.
>
>
>  > >  The boilerplate "If unsure, leave blank" covers (or is meant to cover)
>  > >  the situation where the user does not know what they are doing. It says
>  > >  "If you don't know what you are doing, just leave this field blank,
>  > >  and everything will be OK" ... except it is put in a non-threatening,
>  > >  non-demeaning way.
>  > >
>  > >  The paragraph in the middle enhances the "help" component of the help
>  > >  description, by saying why you might want to use that option.
>  >
>  > I feel that perhaps it is a bit silly to put in such description, as
>  > one using the flags should only do so in knowing specifically which
>  > ones they wish to use and why ahead of time.  However, it cannot hurt
>  > to put in more help documentation, so it's a fine suggestion.
>
>  Well, it can't be both silly and a fine suggestion. Does it dumb down
>  the kernel configuration process too much?

No, I feel that both adjectives are perfectly reconcilable, at least
in this case.  Again, more documentation couldn't hurt.  "Dumbing
down" kernel configuration may be less aesthetically pleasing to
purists, but that is a tiny price to pay for usability and a widening
of kernel builders.

>
>  I don't want a single person to say "I can't configure this kernel
>  because I don't know what to answer for the CUSTOM_CFLAGS question"
>  and I think the "If unsure, leave blank" at the bottom covers that
>  problem. But I assume you want to encourage experimentation; there
>  will be a person with a bit higher level of skill who might want
>  to start tweaking. Here's something they can start tweaking.
>
>

Safe experimentation, yes.  So I agree with you that adding various
statements in the help message can only do good.  Sorry for the
confusion.
- Hide quoted text -

>
>  Nick.
>  --
>  PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
>  PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
>

PS to Nick:  Sorry for the double-send. Didn't CC lkml;  a forward
would be ugly.
