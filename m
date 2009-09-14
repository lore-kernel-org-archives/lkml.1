Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbZINUtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbZINUtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933610AbZINUtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:49:22 -0400
Received: from 1wt.eu ([62.212.114.60]:48825 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933593AbZINUtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:49:21 -0400
Date: Mon, 14 Sep 2009 22:49:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Marcin Letyns <mletyns@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Nikos Chantziaras <realnc@arcor.de>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Phoronix CFS vs BFS bencharks
Message-ID: <20090914204905.GA28315@1wt.eu>
References: <20090906205952.GA6516@elte.hu> <4AAE10E6.2050403@arcor.de> <1252928133.22740.37.camel@marge.simson.net> <f42384a10909140727k463ff460q3859892dcb79bcc5@mail.gmail.com> <1252942335.12986.58.camel@marge.simson.net> <f42384a10909141214w1b3e7719j1a82363f7cb6fd3e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f42384a10909141214w1b3e7719j1a82363f7cb6fd3e@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 09:14:35PM +0200, Marcin Letyns wrote:
> 2009/9/14 Mike Galbraith <efault@gmx.de>
> >
> > On Mon, 2009-09-14 at 16:27 +0200, Marcin Letyns wrote:
> > > Hello,
> > >
> > > Disabling NEW_FAIR_SLEEPERS makes a lot of difference here in the
> > > Apache benchmark:
> > >
> > > 2.6.30.6-bfs: 7311.05
> > >
> > > 2.6.30.6-cfs-fair_sl_disabled: 8249.17
> > >
> > > 2.6.30.6-cfs-fair_sl_enabled: 4894.99
> >
> > Wow.
> >
> > Some loads like wakeup preemption (mysql+oltp), and some hate it.  This
> > load appears to REALLY hate it (as does volanomark, but that thing is
> > extremely overloaded).  How many threads does that benchmark run
> > concurrently?
> 
> >From the benchmark description:
> 
> This is a test of ab, which is the Apache Benchmark program. This test
> profile measures how many requests per second a given system can
> sustain when carrying out 500,000 requests with 100 requests being
> carried out concurrently.

Be careful not to run ab on the same machine as you run apache, otherwise
the numerous apache processes can limit ab's throughput. This is the same
reason as why I educate people so that they don't run a single-process
proxy in front of a multi-process/multi-thread web server. Apparently
it's not obvious to everyone.

Regards,
Willy

