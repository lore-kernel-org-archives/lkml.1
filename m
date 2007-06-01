Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbXFAHbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbXFAHbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXFAHba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:31:30 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20058 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbXFAHba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:31:30 -0400
Date: Fri, 1 Jun 2007 09:30:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Anand Jahagirdar <anandjigar@gmail.com>, security@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Patch related with Fork Bombing Atack
Message-ID: <20070601073020.GL32105@kernel.dk>
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com> <20070531134611.GZ32105@kernel.dk> <25ae38200705312348r3cd02c90h5080617fa1f0a987@mail.gmail.com> <200706010325.23185.dhazelton@enter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706010325.23185.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01 2007, Daniel Hazelton wrote:
> On Friday 01 June 2007 02:48:59 Anand Jahagirdar wrote:
> > On 5/31/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > On Thu, May 31 2007, Anand Jahagirdar wrote:
> > > > 2) Printk message in my patch will definitely help Administrator/Root
> > > > User to detect which particular user is trying fork bombing attack on
> > > > his machine by looking at /var/log/messages or dmesg . he can take
> > > > action against that particular user and kill his processes.
> > >
> > > You just opened a DoS possibility for any user, they can now flood the
> > > syslog instead.
> >
> > Jens Axboe
> >
> >      when they try to flood the syslog using fork bombing attack,
> > their messge will be printed only once in syslog and it will show how
> > many times it has repeated. due to this he will not able to flood the
> > syslog.and i am using only one single variable in my printk messge so
> > it is quite not possible to flood the syslog.
> >
> >    am i missing something??
> >
> > anand
> 
> Most definately. Each printk() call outputs to syslog - which means
> that every time your code outputs its message there is another line in
> the logs. It then becomes possible to use that to flood the syslog.

I think Anand is assuming that because syslog may coalesce identical
messages into "repeated foo times" in the messages file, that it's not a
dos. That is of course wrong.

-- 
Jens Axboe

