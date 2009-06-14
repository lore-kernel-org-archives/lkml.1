Return-Path: <linux-kernel-owner+w=401wt.eu-S1758354AbZFNLUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354AbZFNLUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbZFNLUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:20:47 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47227 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbZFNLUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:20:47 -0400
Date: Sun, 14 Jun 2009 20:20:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: akpm <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open when supported
Message-ID: <20090614112002.GA14963@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	akpm <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> <8bd0f97a0906130348p474faf57yeb729aa07059c599@mail.gmail.com> <20090614093725.GD832@linux-sh.org> <8bd0f97a0906140255h295b393dl3165fff4c0a6baf6@mail.gmail.com> <20090614101111.GG832@linux-sh.org> <8bd0f97a0906140355y3661aa89o9a62a89f38fac5a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0906140355y3661aa89o9a62a89f38fac5a5@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 06:55:45AM -0400, Mike Frysinger wrote:
> On Sun, Jun 14, 2009 at 06:11, Paul Mundt wrote:
> > Perhaps not, but I do prefer to have the script whine at me when a new
> > syscall pops up, just so I know when I have to start caring about a new
> > feature.
> 
> assuming you can find any useful info about said feature ;)
> 
> > These are not things I want to see silenced just because you don't
> > presently feel compelled to wire up the entry on your platform.
> 
> i disagree, but i guess it doesnt matter if the arch maintainers dont
> all agree here.
> 
That is a secondary issue. For most people the script whining about an
unimplemented syscall is the first indication that anything new has been
added that needs to be looked at. This has been an invaluable addition
and I will oppose any attempts to restrict that functionality. If it
whines, you do need to look at it, whether you care about supporting it
or not. This script whines for everyone and requires action by every
architecture maintainer, and simply disabling it in the script because
you don't care about it is not helpful.

As far as new features and syscalls go, documentation is the exception,
rather than the norm. And this is really not an issue, so long as a
the generic implementation exists and does something useful. You have
some HAVE_xxx stub for when you have some degree of support beyond what
it can handle generically.

This distinction is only blurry in the perf counter subsystem because no
one bothered devising a generic implementation for it, instead suggesting
that platforms need to do special enabling logic for something that
should theoretically be generic. This is a total departure from what the
HAVE_xx symbols have meant in the past, and I don't like the fact that
this just happened silently without any discussion. But this also seems
to be a pretty common occurence for things coming in from -tip when
applied in a non-x86 context.

> if we can agree on centralizing arch/Kconfig for HAVE_xxx stubs, we
> could add a checkpatch that errors out if said stub lacks a help line
> -- the assumption being the help text would point to arch details and
> not some other document (design rational, user interface, methodology,
> etc...).  of course, this also relies on the assumption of people
> filtering via checkpatch.pl ...

arch/Kconfig exists for architecture-specific HAVE_xxx stubs, and ought
to have some mention of where to look for wiring up said stub. Individual
features that may or may not be supported by the entire architecture are
best off defined within the Kconfig they are used in.

Having to hunt down new HAVE_xxx stubs is almost as tedious as having to
hunt down the required support interface that goes along with them. In
practice I generally just select HAVE_foo and see where the build blows
up to figure out what I have to do first. But this of course assumes you
have some visibility of new HAVE_xxx stubs.
