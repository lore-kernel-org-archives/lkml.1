Return-Path: <linux-kernel-owner+w=401wt.eu-S1759166AbXFAIEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166AbXFAIEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 04:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbXFAIDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 04:03:55 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20364 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbXFAIDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 04:03:53 -0400
Date: Fri, 1 Jun 2007 10:02:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Anand Jahagirdar <anandjigar@gmail.com>, security@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Patch related with Fork Bombing Atack
Message-ID: <20070601080243.GN32105@kernel.dk>
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com> <200706010325.23185.dhazelton@enter.net> <20070601073020.GL32105@kernel.dk> <200706010400.56222.dhazelton@enter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706010400.56222.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01 2007, Daniel Hazelton wrote:
> On Friday 01 June 2007 03:30:20 Jens Axboe wrote:
> > On Fri, Jun 01 2007, Daniel Hazelton wrote:
> > > On Friday 01 June 2007 02:48:59 Anand Jahagirdar wrote:
> > > > On 5/31/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > On Thu, May 31 2007, Anand Jahagirdar wrote:
> > > > > > 2) Printk message in my patch will definitely help
> > > > > > Administrator/Root User to detect which particular user is trying
> > > > > > fork bombing attack on his machine by looking at /var/log/messages
> > > > > > or dmesg . he can take action against that particular user and kill
> > > > > > his processes.
> > > > >
> > > > > You just opened a DoS possibility for any user, they can now flood
> > > > > the syslog instead.
> > > >
> > > > Jens Axboe
> > > >
> > > >      when they try to flood the syslog using fork bombing attack,
> > > > their messge will be printed only once in syslog and it will show how
> > > > many times it has repeated. due to this he will not able to flood the
> > > > syslog.and i am using only one single variable in my printk messge so
> > > > it is quite not possible to flood the syslog.
> > > >
> > > >    am i missing something??
> > > >
> > > > anand
> > >
> > > Most definately. Each printk() call outputs to syslog - which means
> > > that every time your code outputs its message there is another line in
> > > the logs. It then becomes possible to use that to flood the syslog.
> >
> > I think Anand is assuming that because syslog may coalesce identical
> > messages into "repeated foo times" in the messages file, that it's not a
> > dos. That is of course wrong.
> 
> Well... The problem, IMHO, isn't the logfiles flood-filling the disc
> but the klogd -> syslogd communications sucking down processor
> bandwidth and memory.  A quick grep of the sources shows that the
> kernel doesn't do that nifty "repeated foo times" bit, but the
> userspace syslogd. That's what that closing tagline in my previous
> response to this thread was all about - the whole fact that the
> "repeated foo times" thing is from the userspace component of the
> syslog system. Any program fed the massive amount of input starting a
> recursive forkbomb would generate with the kernel doing this "I've
> detected a forkbomb" printk would start to lag as it struggled to keep
> up - so it starts using more and more processor until its stopped the
> machine from doing anything *but* process those messages. (Oh, wait -
> I just described the DoS that happens when the syslog gets flooded -
> silly me!)

Yep, otherwise there would be no need to have introduced
printk_ratelimit().

-- 
Jens Axboe

