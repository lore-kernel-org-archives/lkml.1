Return-Path: <linux-kernel-owner+w=401wt.eu-S933762AbXGZTc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbXGZTc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761772AbXGZTcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:32:18 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3395 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500AbXGZTcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:32:17 -0400
Date: Thu, 26 Jul 2007 15:31:45 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, wwoods@redhat.com
Subject: Re: [PATCH] core_pattern: Add ability for core_pattern to parse arguments when pattern is a pipe
Message-ID: <20070726193145.GC5701@hmsreliant.homelinux.net>
References: <20070726173923.GA5701@hmsreliant.homelinux.net> <20070726114832.faf14bb0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726114832.faf14bb0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 11:48:32AM -0700, Andrew Morton wrote:
> On Thu, 26 Jul 2007 13:40:19 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > 	Currently, core dumps can be redirected to a pipe by placing the
> > following string template in /proc/sys/kernel/core_pattern:
> > |<path/to/application>
> > This patch extends this ability, allowing the core_pattern to contain arguments
> > to be passed as an argv array to the userspace helper application.  It also add
> > a format specifier, %c, which allows the RLIM_CORE value of the crashing
> > application to be passed on the command line, since RLIMIT_CORE is reduced to
> > zero when execing the userspace helper
> 
> This all seems to be getting a bit nutty.  Who needs this feature
> and what will they do with it, etc?
> 
Why nutty?  Ubuntu has had apport for a bit now, which monitors the system for
crashed process and attempts to help the user auto-file a bugreport with a
relevant distro based on its configuration.  Ubuntu has implemented lots of
their functionality with some patches that they never pushed upstream (and IMHO,
have some security issues).  This is my attempt to do what their doing sanely,
so the other distro's (primarily fedora) can take advantage of this technology.
Will Woods (who has been copied on this set of patches) can give you more detail
if you like.   As for this specific feature, I wanted to include it for the same
reason that I mentioned above.  core_pattern, when set to a pipe, reduces
RLIMIT_CORE to zero.  This patch lets you pass the real core limit value
directly to the application in the event it wants to save the core to disk, but
still wishes to respect the original ulimit value.

> You have a few open-coded kstrdup()s in there, btw.  And an open-coded
> free_argv_array() on the error path.  And a lot of checkpatch warnings.
I don't see what you're referring to.  free_argv_array is only called if it was
initially setup (keyed of the same ispipe variable), and all the memory for the
strcpy's in format_corename_argv is unwound and freed in the out_free label of
the same function on error.  If there is somethign I'm missing, please let me
know, I'm happy to fix it.

I know its been a large number of patches over the last few days, and I'm sorry
for that.  I've been trying to break this up into a sane amount of discrete
chunks that don't depend on one another.  If you would prefer that I roll them
up into a larger patch, I'm happy to do that as well.  Just let me know.

Thanks & Regards
Neil

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
