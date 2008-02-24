Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYBXMu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYBXMu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 07:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYBXMur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 07:50:47 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:35994 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1750886AbYBXMuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 07:50:46 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 24 Feb 2008 23:50:11 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Nicholas Marquez <nicholas.marquez@gatech.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] More accessible usage of custom flags
Message-ID: <20080224125011.GB18845@tull.net>
References: <e367bd3e0802161852v1265f101h86326b16362dd860@mail.gmail.com> <e367bd3e0802231328l1eb928f5pe538264c3a42e3d2@mail.gmail.com> <20080223220458.GA3496@tull.net> <e367bd3e0802231428k11a7d8ddgdfafacfba4c4d078@mail.gmail.com> <20080223233906.GA18845@tull.net> <e367bd3e0802240136kf9d30b9xfbaa84fa3e05661d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e367bd3e0802240136kf9d30b9xfbaa84fa3e05661d@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 04:36:24AM -0500, Nicholas Marquez wrote:
> Yes, I would like to expand them.  If possibly, I'd like to take out
> the individual config options for gcc flags and integrate them into
> the help description.  I feel that the redundancy would not only be
> ugly, but possibly confusing.

If you allow CUSTOM_CFLAGS and friends (as an open-ended set of flags for
the compiler) then yes, having config options like CC_OPTIMIZE_FOR_SIZE
is redundant and should be removed.

Alternately, don't have a CUSTOM_CFLAGS and expand on the set of config
options which set individual compiler flags.  They could be in their
own menu, a bunch of checkboxes to tweak GCC's various optimisation
algorithms and/or warnings. That's certainly going to be friendlier
for the not-very-experienced kernel builder, if less flexible than
CUSTOM_CFLAGS.

> >  I'm hoping we don't need any stern warnings in the kernel configuration.
> >  Although I expect configuring bogus gcc flags is going to break the
> >  build far worse than selecting bad options otherwise. If the user
> >  makes a mistake in CUSTOM_CFLAGS is the build going to fail with
> >  a message "error in CUSTOM_CFLAGS" or is it going to spew out pages
> >  of gcc error messages?  It is nice if error messages can point back
> >  to the source of the error, so the user doesn't have to look through
> >  the entire kernel configuration for what they did wrong.
> 
> I hadn't thought of that.  It would certainly be more useful than a
> stern warning.  ^^;  Have you any ideas on how to implement such a
> thing?  I would imagine a configure-script-like test on the flags to
> make sure that gcc could take them correctly would be in order.  Then
> one could also capture any warnings or errors that gcc outputs (such
> as redundant flags, improper invocation, etc.), fail the build, and
> output the messages.  As far as capturing dangerous flags for the
> kernel (such as -ffast-math or -fmerge-all-constants), there could be
> a blacklist... but that would depend on the gcc version used... :/

I think that's a very interesting idea. Yes, you can test the flags by
compiling and linking a simple program. If it fails, your flags are
bad. You can stop the build right there and say "fix your flags".

The build could also capture the GCC warning/error output and
post-process it. Certain types of warnings might be suppressed,
or cause the build to fail (based on selected config options). My
kernel builds always show a handful of "may be used uninitialised" or
similar ... I just assume that those warnings are harmless. It is best
of course that these warnings don't occur at all, and I expect kernel
developers to fix them when they get a chance.  The idea in this
paragraph would be desirable to me, independent of how the CFLAGS are
specified.


> >  > Something else that could be included is a link to the manual for the
> >  > (currently used) gcc's command flags
> >  > (http://gcc.gnu.org/onlinedocs/gcc-4.2.3/gcc/index.html#toc_Invoking-GCC)
> >  > or at least to the online docs, considering that specifying one
> >  > specific gcc version's manual would yield various issues.
> >
> >  "info gcc" will give all that information in far more detail than I
> >  have time to read.
> 
> I believe you misunderstand.  I mean to include the link in the help
> message.  Like how the links to the appropriate sites for device
> drivers are included in their help messages.

No, I think I understood correctly. If you tell the user to go to that
long URL then you run the risk of pointing to the documentation for a
different version of GCC. On the other hand, if you tell them to type
"info gcc" then they will see the documentation for the version of GCC
which they have installed. And it's also a lot friendlier to write:
"Type 'info gcc' to see a full list of the compiler options".

> >  > I feel that perhaps it is a bit silly to put in such description, as
> >  > one using the flags should only do so in knowing specifically which
> >  > ones they wish to use and why ahead of time.  However, it cannot hurt
> >  > to put in more help documentation, so it's a fine suggestion.
> >
> >  Well, it can't be both silly and a fine suggestion. Does it dumb down
> >  the kernel configuration process too much?
> 
> No, I feel that both adjectives are perfectly reconcilable, at least
> in this case.  Again, more documentation couldn't hurt.  "Dumbing
> down" kernel configuration may be less aesthetically pleasing to
> purists, but that is a tiny price to pay for usability and a widening
> of kernel builders.

I'm looking to find a balance among the competing objectives. Time
will tell with any improvements. I'm also hoping for an aesthetically
pleasing config menu -- perhaps someone else can take on the challenge of
restructuring it to improve the ordering, structure and names of options.

> PS to Nick:  Sorry for the double-send. Didn't CC lkml;  a forward
> would be ugly.

No prob.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
