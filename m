Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbZCZXD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbZCZXD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZCZXDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:03:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbZCZXDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:03:44 -0400
Date: Fri, 27 Mar 2009 00:02:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326230240.GA18808@elte.hu>
References: <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326152815.GB6239@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326152815.GB6239@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Mar 26, 2009 at 03:03:12PM +0100, Ingo Molnar wrote:
> > 
> > I still see similarly bad latencies in Vim:
> > 
> 
> When you say "similarly bad", how many seconds were you seeing?  I 
> understand that from the user's perspective, the 120 seconds you 
> saw with ext3 isn't going to be that different from 15 seconds 
> (which seems to be the maximum commit time in the jbd2 history 
> file you sent me), but I'm curious if what you saw was just as bad 
> with ext4, or was it somewhat better (i.e., 120 seconds vs 15 or 
> so).  Or were you also seeing a net time to save the file using 
> vim of around 120 seconds with ext4?

It was in the minute range, iirc. It was totally unusable 
interactively. I wrote the vim-test script during that workload and 
i'm still getting annoyed thinking back at the experience. Is that 
enough to consider it bad? :-)

This isnt me streaming gigs of data in and out of the system 
dirtying 90% of all RAM. This is a trivial workload barely 
scratching the RAM and CPU capabilities of the system.

Do you have a non-tweaked default Fedora install somewhere? These 
kinds of delays in Vim were easily reproducible in the last 5 years 
and i saw it reported frequently on various lists.

Have you tried to reproduce it? Have you tried CONFIG_LATENCYTOP? We 
implemented that kernel feature specifically to make it easy for 
developers to instrument their kernel and keep system latencies 
down. This isnt some oddball workload or oddball system. These 
latencies are reproducible on just about any Linux development 
system i ever tried with ext3.

And the thing is, to 99.9% of the people it doesnt matter how 
scalable we are to 16000 CPUs or whether a directory with 1 million 
files in it takes 10 or 200 msecs to parse.

But it gives a permanent impression how much delay basic everyday 
operations on the system have. So latency optimizations (and i use 
the term losely here) have to be the primary development metric in 
Linux IMHO. ( If i were doing filesystem development i'd sure 
already have my low-latency filesystem patchset ;-)

	Ingo
