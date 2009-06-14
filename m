Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZFNKME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZFNKME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZFNKLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:11:55 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33368 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZFNKLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:11:55 -0400
Date: Sun, 14 Jun 2009 19:11:11 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: akpm <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open when supported
Message-ID: <20090614101111.GG832@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	akpm <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> <8bd0f97a0906130348p474faf57yeb729aa07059c599@mail.gmail.com> <20090614093725.GD832@linux-sh.org> <8bd0f97a0906140255h295b393dl3165fff4c0a6baf6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0906140255h295b393dl3165fff4c0a6baf6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 05:55:44AM -0400, Mike Frysinger wrote:
> On Sun, Jun 14, 2009 at 05:37, Paul Mundt wrote:
> > On Sat, Jun 13, 2009 at 06:48:52AM -0400, Mike Frysinger wrote:
> >> On Fri, Jun 12, 2009 at 07:29, Mike Frysinger wrote:
> >> > If the port does not support HAVE_PERF_COUNTERS, then they can't support
> >> > the perf_counter_open syscall either. ??Rather than forcing everyone to add
> >> > an ignore (or suffer the warning until they get around to implementing
> >> > support), only whine about the syscall when applicable.
> >> >
> >> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >>
> >> Andrew: could you pick this up since Ingo acked it now ?
> 
> btw, Sam said he would pick it up via the kbuild tree
> 
> > I fail to see why this is necessary? cond_syscall() takes care of this in
> > the not implemented case, the same as every other syscall backing some
> > feature that has yet to be implemented.
> 
> i dont think we should go hassling every arch maintainer when a new
> syscall is added that requires arch-specific support for optional
> features (especially when said features are debug in nature).  if
> wiring up the syscall is the only work because the code is all common
> (like the pread/pwrite functions), then np of course.

Perhaps not, but I do prefer to have the script whine at me when a new
syscall pops up, just so I know when I have to start caring about a new
feature. New syscalls that are handled by cond_syscall() are trivially
dropped in to the syscall table to get rid of these warnings, regardless
of whether you have any intention of really supporting the feature or
not. If a generic implementation becomes available, then it can be
supported without having to backtrack and update place-holders.

These are not things I want to see silenced just because you don't
presently feel compelled to wire up the entry on your platform.

The fact the perf counter stuff has no real generic support, or even the
present infrastructure to support it on pretty much every 32-bit platform
that isn't x86 is more an issue with -tip development methodology than
anything to do with the syscall bits.

Of course if it had been handled properly then the generic software
counters would have been actually implemented generically and
subsequently made available from the stub and the HAVE_xxx would be
reserved for architecture-specific counters. Unfortunately these days
"generic" generally seems to imply "can be made generic if someone else
bothers to actually do the work, assuming they can find any documentation
in the first place".
