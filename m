Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbZCYNwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbZCYNwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbZCYNwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:52:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58433 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbZCYNwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:52:13 -0400
Date: Wed, 25 Mar 2009 10:51:42 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] blktrace: fix the original blktrace
Message-ID: <20090325135142.GD10928@ghostprotocols.net>
References: <49C9F700.9070609@cn.fujitsu.com> <49C9F796.9040503@cn.fujitsu.com> <20090325101451.GK2341@elte.hu> <20090325101747.GL27476@kernel.dk> <20090325114720.GA9762@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325114720.GA9762@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 25, 2009 at 12:47:20PM +0100, Ingo Molnar escreveu:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Mar 25 2009, Ingo Molnar wrote:
> > > 
> > > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > > 
> > > > Currently the original blktrace, which is using relay and is used 
> > > > via ioctl, is broken. You can use ftrace to see the output of 
> > > > blktrace, but user-space blktrace is unusable.
> > > 
> > > good catch, thanks Li!
> > > 
> > > Jens, Arnaldo, do these fixes look good to you too?
> > 
> > Look fine, but I'm very worried about the state of the current 
> > code. I mean, this last round of fixes got the timestamp correct 
> > and made blktrace work again. [...]
> 
> Correct. I tested it on a 16way box (see the blkparse output below). 
> If you can see any sort of anomaly please let us know so we can fix 
> it.
> 
> > [...] Those are something that should have been caught even before 
> > the whole thing was posted, let alone merged. When do you plan on 
> > pushing this upstream? Looks like 2.6.31 to me, it's clearly not 
> > ready for 2.6.30 by any stretch.
> 
> Well, apparently nobody tried ioctl based blktrace+blkparse on -tip 
> or linux-next in the past ~1 month. The relayfs portion was (meant 
> to be) kept largely untouched but this bug still crept in.
> 
> Li started looking into it and found the bug. I tested the ftrace 
> plugin side regularly, but you are right that this bug took too long 
> to find (over a month) - from now on i'll check the ioctl side more 
> regularly too, for all tracing and relayfs changes as well.

I got sidetracked by other stuff and didn't managed to continue working
on it, but at the same time testing by somebody else is needed. There is
no bug-free code, let alone in the first iteration, even less for
something I wasn't familiar with and depended on people like Li to do a
careful review.

Li fixed bugs and continued the work, getting things I wanted working
and made the initial steps to get done, like being able to just fed
trace_pipe into blkparse and get the same result as btrace.

So I apologise for not having continued working on it more often to
catch myself the bugs I introduced, and give a big thank you to Li for
the thorough review, bugfixes and improvements.

- Arnaldo
