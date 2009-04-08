Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbZDHOYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbZDHOYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbZDHOYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:24:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50690 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbZDHOYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:24:34 -0400
Date: Wed, 8 Apr 2009 16:24:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Whitehouse <swhiteho@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       axboe@kernel.dk
Subject: Re: Multiple Tracers
Message-ID: <20090408142413.GF12931@elte.hu>
References: <1239197703.3359.25.camel@localhost.localdomain> <20090408135312.GR18581@elte.hu> <1239199899.3359.39.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239199899.3359.39.camel@localhost.localdomain>
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


* Steven Whitehouse <swhiteho@redhat.com> wrote:

> Hi,
> 
> On Wed, 2009-04-08 at 15:53 +0200, Ingo Molnar wrote:
> > * Steven Whitehouse <swhiteho@redhat.com> wrote:
> > 
> > > Hi,
> > > 
> > > A little while back I posted a RFC patch which added gfs2 glock 
> > > tracing to blktrace. There was a suggestion that I should look 
> > > instead at the generic tracing code and add a new tracer, but I've 
> > > come up with a couple of issues along the way.
> > > 
> > > I think from what I can see that its only possible to run a single 
> > > tracer at once, so running blktrace (for example) would preclude 
> > > me from also tracing gfs2's glocks at the same time. Also, I can 
> > > see no mechanism by which I could ensure the sequencing between 
> > > the blktrace and glock traces other than exporting the blktrace 
> > > sequence number, even if running multiple tracers at the same time 
> > > was possible.
> > 
> > There's a recent addition: the EVENT_TRACE() facility. Would that 
> > suit your purposes?
> > 
> > 	Ingo
> 
> If I can get both blktrace and glock trace info from it, then yes. 
> I thought that the blktrace output went either via the original 
> relayfs path, or via its own tracer so that it wasn't possible to 
> use it and the event trace facility at the same time, unless I use 
> blktrace via relayfs. From what I've read I thought that probably 
> the relayfs interface for blktrace might eventually be removed in 
> favour of the generic tracing interface, but I'm not 100% sure of 
> that, so perhaps someone can confirm the plans in that area?

Tom Zanussi (Cc:-ed) recently converted the blktrace tracepoints to 
a tracing framework - and i think much of that could be reused to 
add EVENT_TRACE() tracepoints to blktrace too.

Tom, what's your take on this?

In general, this is the direction we want to take: EVENT_TRACE() 
tracepoints that can be used in a generic way, in any tracer.

	Ingo
