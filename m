Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbZGRKjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbZGRKjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbZGRKjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:39:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41249 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbZGRKjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:39:45 -0400
Date: Sat, 18 Jul 2009 12:39:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>, rgetz@blackfin.uclinux.org,
       lethal@linux-sh.org, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when
	calculating the stack size
Message-ID: <20090718103935.GB11381@elf.ucw.cz>
References: <20090709101930.GJ10937@elf.ucw.cz> <20090704024606.GE1345@ucw.cz> <20090701120814.30741.10146.stgit@warthog.procyon.org.uk> <24530.1247050900@redhat.com> <20090704033429.GA1799@ucw.cz> <8bd0f97a0907081148vc716eeepfdaf8178b1ecbce1@mail.gmail.com> <24280.1247137151@redhat.com> <20090711213018.GA1425@ucw.cz> <8bd0f97a0907140515t2bc47674qac75ba93f8c9fdae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0907140515t2bc47674qac75ba93f8c9fdae@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-07-14 08:15:03, Mike Frysinger wrote:
> On Sat, Jul 11, 2009 at 17:30, Pavel Machek wrote:
> > On Thu 2009-07-09 11:59:11, David Howells wrote:
> >> Pavel Machek wrote:
> >> > > i really dont think this is realistic.  there is exactly one ldso that
> >> > > everyone uses under FDPIC ELF, and it needs a very minuscule stack.
> >> >
> >> > Not very realistic; but that argues that the patch is NOP.
> >> >
> >> > And if it _is_ realistic, the patch adds a bug.
> >>
> >> No, it doesn't.  The problem is that the loader, when it is linked, is given a
> >> sillyly large default stack size, and this causes the application to be given a
> >> much larger stack than is strictly necessary - a stack that is drawn from a
> >> limited pool of non-pageable RAM and that must be allocated as a contiguous
> >> lump.
> >
> > Fix the loader to only request as big stack as it needs?
> 
> and what if the loader needs a larger stack when run as an application
> ?  you could make the same exact argument for every library that an
> application has a DT_NEEDED tag for, or that it dlopen()'s.  but for
> the same reasons, it doesnt fly.
> 
> the only stack that should be checked is what the application itself
> says it needs.  the ldso has no way of knowing what functions exactly
> the application in question will be using (whether in the ldso itself
> or in any library), thus only the application itself knows what the
> stack usage will look like.

And the application has no way of knowing how much stack this
particular ldso needs. Too bad, it is all broken.

(And the solution of taking maximum of all involved parties still
looks best to me.)
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
