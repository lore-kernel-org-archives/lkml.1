Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXCDOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXCDOg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932817AbXCDOg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:36:56 -0500
Received: from 1wt.eu ([62.212.114.60]:4937 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837AbXCDOgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:36:55 -0500
Date: Sun, 4 Mar 2007 15:36:38 +0100
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu  scheduler
Message-ID: <20070304143638.GG943@1wt.eu>
References: <200703041800.53360.kernel@kolivas.org> <200703042346.04051.kernel@kolivas.org> <200703040825.42047.gene.heskett@gmail.com> <200703050049.50149.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703050049.50149.kernel@kolivas.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Con !

On Mon, Mar 05, 2007 at 12:49:49AM +1100, Con Kolivas wrote:
> On Monday 05 March 2007 00:25, Gene Heskett wrote:
> > On Sunday 04 March 2007, Con Kolivas wrote:
> > >On Sunday 04 March 2007 23:24, Gene Heskett wrote:
> > >> On Sunday 04 March 2007, Con Kolivas wrote:
> > >> >On Sunday 04 March 2007 22:08, Gene Heskett wrote:
> > >> >> On Sunday 04 March 2007, Con Kolivas wrote:
> > >> >> >This message is to announce the first general public release of
> > >> >> > the "Rotating Staircase DeadLine" cpu scheduler.
> > >> >>
> > >> >> I assume to test this, we select the deadline scheduler?
> > >> >
> > >> >No, only the "deadline" in the name is shared. This is a cpu process
> > >> > scheduler whereas the deadline scheduler you're thinking of is an
> > >> > I/O scheduler. To test this you just patch it in and it replaces the
> > >> > current mainline cpu scheduler (the same way the staircase cpu
> > >> > scheduler in -ck replaces it).
> > >>
> > >> Oh, then I tried to put the -ck1 patch on top of that, and blew the
> > >> tree up.  I'd built it the first time with the deadline scheduler as
> > >> the default while I was waiting on your reply.
> > >
> > >Yes, sorry. This is mutually exclusive with the -ck1 patch. It is a
> > > standalone piece of code.
> >
> > I just this instant got it booted, what with building a driver for nvidia
> > and all.  I'll let you know what I think in a few hours after I've gotten
> > a feel for it.
> 
> Great, thanks.
> 
> Just to make it clear. The purpose of this scheduler is at all costs to 
> maintain absolute fairness no matter what type of load it is put under. This 
> means that if you heavily load up your machine without the use of 'nice' then 
> your interactive tasks _will_ slow down proportionately to the amount of cpu 
> you use. So doing make -j4 for example will make any other task started in 
> taht presence run precisely 1/5th speed, but they will still be responsive, 
> have low latency (and audio shouldn't skip for example). 
> 
> There will be times when the mainline scheduler feels more interactive than 
> this scheduler, and that is because it has significant unfairness granted 
> towards interactive tasks. This degree of unfairness in an effort to maintain 
> interactivity has been criticised and causes problems in certain environments 
> with both loss of fairness, relative starvation and is not entirely 
> predictable. 
> 
> This was designed to be robust for any application since linux demands a 
> general purpose scheduler design, while preserving interactivity, instead of 
> optimising for one particular end use.

Well, I haven't tested it yet, but your design choices please me. As you
know, I've been one of those encountering big starvation problems with
the original scheduler, making 2.6 unusable for me in many situations. I
welcome your work and want to thank you for the time you spend trying to
fix it.

Keep up the good work,
Willy

PS: I've looked at your graphs, I hope you're on the way to something really
    better than the 21 first 2.6 releases !

