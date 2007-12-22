Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbXLVTPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbXLVTPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 14:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXLVTPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 14:15:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59174 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbXLVTPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 14:15:18 -0500
Date: Sat, 22 Dec 2007 20:09:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222190933.GA2958@elte.hu>
References: <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de> <20071222100326.GF26157@elte.hu> <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > > It's definitely not a stable ABI. slabtop tends to exit without 
> > > any error message on any slabinfo version number increase and I've 
> > > seen that happen several times in not so old kernels.
> > 
> > so because we sucked in the past we can continue to suck? ;)
> 
> Well, I do have to admit that I'm not a huge fan of /proc/slabinfo, 
> and the fact that there hasn't been a lot of complaints about it going 
> away does seem to imply that it wasn't a very important ABI.
> 
> I'm the first to stand up for backwards compatibility, but I also try 
> to be realistic, and so far nobody has really complained about the 
> fact that /proc/slabinfo went away on any grounds but on the general 
> principle of "it was a user-visible ABI".
> 
> We've changed user-visible ABI's in the past in the hope that they 
> weren't actually used. Sometimes it worked, sometimes it didn't. In 
> this case, I think it still has the potential of working.
> 
> That said, I'm not a *huge* fan of /sys/slab/ either. I can get the 
> info I as a developer tend to want from there, but it's really rather 
> less convenient than I'd like. It is really quite hard, for example, 
> to get any kind of "who actually uses the most *memory*" information 
> out of there.

Yes, i agree that me calling it an 'ABI' stretches the term - we dont 
want to put ourselves into a forced compatibility corner in every case 
where /proc does something really stupid. But /proc/slabinfo is being 
used, slabtop is installed and deployed, so why break it unnecessarily? 
It's not like we couldnt remove /proc/slabinfo later on, via the normal 
route of feature removal. I think Pekka's patch that adds /proc/slabinfo 
is simple and reasonable enough for 2.6.24.

We can get rid of /proc/slabinfo but then it should i think be done via 
the normal route of Documentation/feature-removal-schedule.txt. Was 
there any particular problem with /proc/slabinfo, at least as far as the 
read-only access that slabtop does goes? I dont think there was. So why 
should we go out on a limb _not_ providing it when there's a patch 
available, etc. I just googled a bit and people _have_ asked about 
slabtop availability, and the impression was that it would be offered by 
the time SLUB becomes the default. (and this was mentioned by others in 
this discussion)

I'd also not rely on the fact that only a few people are complaining. 
Most people, even 2.6.24-rc early adopters, still use SLAB because early 
adopters typically use their .23 .config and do a 'make oldconfig' - 
which picks up SLAB. So SLUB use will become more widespread only once 
2.6.24 is out and is packaged in distros. Distros will likely pick SLUB 
if there's no performance worries and if it's the default. Fedora 
rawhide already uses SLUB.

	Ingo
