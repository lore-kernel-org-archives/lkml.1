Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbZEFLzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbZEFLzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbZEFLyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:54:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34403 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758748AbZEFLyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:54:38 -0400
Date: Wed, 6 May 2009 13:54:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4/jbd2: remove stray markers
Message-ID: <20090506115421.GN25203@elte.hu>
References: <20090506104436.GA24047@lst.de> <20090506110354.GG25203@elte.hu> <20090506114051.GA4964@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506114051.GA4964@mit.edu>
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

> On Wed, May 06, 2009 at 01:03:54PM +0200, Ingo Molnar wrote:
> > 
> > > Ted, I think you have some TRAVE_EVENT patches for ext4 pending, 
> > > but is it okay to queue up this removal in the tracing tree?  That 
> > > way we can remove the markers leftovers there completely as soon 
> > > as the 2.6.31 merge window opens.
> > 
> > i think these markers are still in active use, so i'd not remove 
> > them before Ted's TRACE_EVENT() changes are included. We can/should 
> > do that in a single topic - in a work flow that suits Ted best.
> 
> My complaint with Cristoph's is that it will conflict with patches 
> I have pending which replaces the markers with tracepoints --- and 
> I *am* using the tracepoints actively.  The only reason why these 
> patches aren't in -stable is they have a dependency one of 
> Rostedt's changes.  (Not a syntactic dependency, but if we merge 
> in the wrong order, and the rcu_read_lock/unlock() calls aren't 
> around the TP_PRINTK callpoint, then in certain CONFIG_PREEMPT 
> configurations and if there is more than one active ext4 
> filesystem while the ext4 or jbd2 tracepoints are active, there's 
> a potential race.)

That's OK.

> > We can do a -git based special-purpose topic branch in -tip, or 
> > we can do it in tip/tracing, or we can pull a (-git based) 
> > branch from Ted. Or we can delay it all to the v2.6.31 merge 
> > window. Ted's choice.
> 
> My plan was to wait for the tracing patches to get pushed during 
> the 2.6.31 merge tree, at which point I would then push my changes 
> which replace the markers with TRACE_EVENT changes.  So no matter 
> which way we do this, the ext4 markers will be gone by the end of 
> the 2.6.31 merge window.

That's a perfectly fine approach.

> Christoph, if you have some desire to completely remove the 
> CONFIG_MARKERS support code, and I'm holding up your ability to do 
> work, I can take the ext4 TRACE_EVENT patches, and queue them up 
> in tip/tracing.  It's less work than if we take your markers 
> removal patches, since then I would have to resolve all of the 
> conflicts with my patches which replace all of the ext4 and jbd2 
> markers with TRACE_EVENTS macros.
> 
> My preference is for the former, mainly because my patches are 
> already set up for that, and I'm a lazy bastard; the latter 
> wouldn't be much work, though.  I'm guessing your preference would 
> be for the latter?

No, lets delay this to the v2.6.31 merge window. I'd like to remove 
markers - but not at the cost of making life harder for others and 
at the cost of creating inter-dependencies on such a level.

I objected to markers back when they were merged in a rather 
haphazard way, but i'll object to any haphazard removal just as much 
;-) The .31 merge window will open in about a month.

	Ingo
