Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbXG1Nr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbXG1Nr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 09:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbXG1NrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 09:47:17 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3799 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbXG1NrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 09:47:17 -0400
Date: Sat, 28 Jul 2007 09:46:27 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Martin Pitt <martin.pitt@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       wwoods@redhat.com, Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe
Message-ID: <20070728134627.GA10006@hmsreliant.homelinux.net>
References: <20070727200746.GC18946@hmsreliant.homelinux.net> <20070728092355.GA5808@piware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070728092355.GA5808@piware.de>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 11:23:55AM +0200, Martin Pitt wrote:
> Hi Neil,
> 
> thanks a lot for your work on this!
> 
> Neil Horman [2007-07-27 16:08 -0400]:
> > Hey
> > 	Patch 2/3 of my core_pattern enhancements.  This patch is a rewrite of
> > my previous post for this enhancement.  It uses jeremy's split_argv/free_argv
> > library functions to translate core_pattern into an argv array to be passed to
> > the user mode helper process.  
> > [...]
> >   	if (ispipe) {
> >  		core_limit = RLIM_INFINITY;
> > +		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
> 
> I just want to mention a potential problem with this: If you first
> expand the macros (from pattern to corename) and then split corename
> into an argv, then this breaks macro expansions containing spaces.
> This mostly affects the executable name, of course.
> 
I never intended for this core_pattern argument passing to be able to expand
macros, other than the macros specified by the core_pattern code.  If you want
it to do that, we can address that with a later patch.

> In fact we considered this macro approach when doing the original
> patches in the Ubuntu kernel, but we eventually used environment
> variables because they are much easier and more robust to implement
> than doing a robust macro expansion (i. e. first split core_pattern
> into an argv and then call the macro expansion for each element).
> 
I disagree. While it might be nice to be able to specify environment variables
as command line arguments, it would be much easier to just let the core_pattern
executable inherit the crashing processes environment.  we don't do that
currently, but we easily could.  That way any information that the crashing
process wants the dying process to know can be inherited and vetted easily by
apport (or whatever the core_pattern points to).  I'll do a patch later for that
if you don't like it.

> I would love to use macros instead since it looks a bit cleaner, and
> personally I do not care about the "executable name" macro for Apport
> [1] (I grab it from /proc/pid/exe), but I wanted to mention this
> possible caveat before it goes upstream.
> 
If you don't want to use a given macro, fine, don't use it.  If you want to use
a macro, thats fine too, but I really don't want to offer the ability to pass
macro's in core_pattern (it really just makes the parsing too hairy and prone to
error).  If you want to pass macros to apport, or whatever, we'll just let the
user mode helper inherit the crashing processes environment.  Its much easier
work, just as usefull, and more importantly, can be done later as a separate
piece of work.

Regards
Neil


> Thank you,
> 
> Martin
> 
> [1] https://wiki.ubuntu.com/Apport
> 
> -- 
> Martin Pitt        http://www.piware.de
> Ubuntu Developer   http://www.ubuntu.com
> Debian Developer   http://www.debian.org



-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
