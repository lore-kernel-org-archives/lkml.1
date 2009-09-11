Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZIKH6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZIKH6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbZIKH6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:58:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36539 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945AbZIKH6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:58:30 -0400
Date: Fri, 11 Sep 2009 09:58:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [long] Another BFS versus CFS shakedown
Message-ID: <20090911075832.GG18599@kernel.dk>
References: <200909090142.41738.elendil@planet.nl> <20090911062032.GB27833@elte.hu> <200909110904.50487.elendil@planet.nl> <20090911071710.GB18599@kernel.dk> <20090911075331.GA14489@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911075331.GA14489@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Fri, Sep 11 2009, Frans Pop wrote:
> > > On Friday 11 September 2009, Ingo Molnar wrote:
> > > > Note, the one you used was a still buggy version of latt.c producing
> > > > bogus latency numbers - you will need the fix to it attached below.
> > > 
> > > Yes, I'm aware of that and have already copied Jens' latest version.
> > 
> > BTW, I put it in a git repo, it quickly gets really confusing with so
> > many version going around. So that can be accessed here:
> > 
> > git://git.kernel.dk/latt.git
> > 
> > and as with my other repos, snapshots are automatically generated every
> > hour when new commits have been made. To get the very latest latt and
> > not have to use git, download:
> > 
> > http://brick.kernel.dk/snaps/latt-git-latest.tar.gz
> 
> Btw., your earlier latt reports should be discarded as invalid due 
> to that bug.

Yes

> With the fixed latt.c version the mainline latencies (both 
> worst-case and average) were reported to be better after the poll() 
> bug got fixed, so in that area, for this kind of measurement, 
> mainline seems to be working well.
> 
> [ What happened is that the poll() bug was creating false latencies
>   in the mainline scheduler tests. (BFS avoided measuring that bug
>   incidentally, by its agressive balancer moved the wakee tasks away
>   from the buggy busy-looping poll() looping parent task. Two
>   instances of latt.c would possibly have shown similar latencies.) ]
> 
> I see you added new 'work generator' changes to latt.c now, will 
> check/validate that version of latt.c too.

I did, it's a simple 'generate random data and compress it' work piece
for each client. You can control the amount of work with -x, which sets
the kb of data it'll work on. Stats are generated both for wakeup
latency, and work processing latency.

-- 
Jens Axboe

