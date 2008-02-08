Return-Path: <linux-kernel-owner+w=401wt.eu-S935273AbYBHB0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273AbYBHB0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 20:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760834AbYBHB03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 20:26:29 -0500
Received: from fmailhost04.isp.att.net ([207.115.11.54]:38824 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbYBHB01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 20:26:27 -0500
X-Originating-IP: [72.147.214.119]
Date: Thu, 7 Feb 2008 19:26:23 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: MM kernels 2.6.24-rc*-mm*, 2.6.24-mm1: gnome-terminal stuck in
 tty_poll
Message-ID: <20080207192623.0471f08e@osprey.hogchain.net>
In-Reply-To: <1202415887.6274.40.camel@lappy>
References: <1202326722.7488.46.camel@localhost>
	<47AA68AA.3090009@bellsouth.net>
	<20080206182329.b0956b4a.akpm@linux-foundation.org>
	<1202413744.6274.26.camel@lappy>
	<1202415887.6274.40.camel@lappy>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 21:24:47 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Thu, 2008-02-07 at 20:49 +0100, Peter Zijlstra wrote:
> > On Wed, 2008-02-06 at 18:23 -0800, Andrew Morton wrote:
> > > On Wed, 06 Feb 2008 20:10:50 -0600 "J. K. Cliburn"
> > > <jacliburn@bellsouth.net> wrote:
> > > 
> > > > Zan Lynx wrote:
> > > > 
> > > > > gnome-terminal gets stuck.
> > > > 
> > > > I began seeing this very thing around 2.6.24 time.  (Fedora 8,
> > > > vanilla kernel.)  I could usually cause the gnome terminal to
> > > > hang if I rapidly resized the window while executing make
> > > > check-headers.
> 
> Weird, .24 proper doesn't have that patch. 

Yeah, my reference to "around 2.6.24 time" was simply a gross
demarcation along the passage of time rather than an indictment of
2.6.24 itself.

I began noticing gnome-terminal hangs during kernel builds a couple of
weeks ago, but I ignored them, thinking it'd be fixed with a Fedora
package update.  When that didn't happen, I began looking for the
culprit in the kernel in earnest this past Saturday.

> What exact fedora kernel was that (so I can look at it).

I didn't use a Fedora kernel; I bisected Linus' git current as of
Saturday Feb 2, using 2.6.24 as the "good" side of the bisect.  It took
the better part of two days to whittle down the throng, but by Sunday
night I'd settled on the 37bb6cb4 hrtimer commit.  My last act before
going to bed that night was to reset the bisect, revert the commit, and
rebuild.  I couldn't get gnome-terminal to hang using that rebuilt
kernel.

The next morning I went out of town for a couple of days, only to return
to find my workstation dead after some weather-related power outages.
I just got it back online tonight.

> Which is even weirder, because the provided trace indicates
> schedule_timeout()

The trace isn't from me; it's from Zan.  He's running -mm, I'm not, if
that makes a difference.

>         
>         Call Trace:
>          [schedule_timeout+149/208] schedule_timeout+0x95/0xd0
>          [<ffffffff8057dde5>] schedule_timeout+0x95/0xd0
>          [tty_poll+145/160] tty_poll+0x91/0xa0
>          [<ffffffff80430f11>] tty_poll+0x91/0xa0
>          [do_sys_poll+617/880] do_sys_poll+0x269/0x370
>          [<ffffffff802bbe69>] do_sys_poll+0x269/0x370
>          [__pollwait+0/304] __pollwait+0x0/0x130
>          [<ffffffff802bcb30>] __pollwait+0x0/0x130

Now that my computer is back on the air again, I'll be happy to help
track this down.  Just tell me what to do.

Jay
