Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbZDIIOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbZDIIOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZDIIN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:13:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48134 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996AbZDIINy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:13:54 -0400
Subject: Re: Multiple Tracers
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       axboe@kernel.dk
In-Reply-To: <1239255478.6839.64.camel@tropicana>
References: <1239197703.3359.25.camel@localhost.localdomain>
	 <20090408135312.GR18581@elte.hu>
	 <1239199899.3359.39.camel@localhost.localdomain>
	 <20090408142413.GF12931@elte.hu>  <1239255478.6839.64.camel@tropicana>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Thu, 09 Apr 2009 09:15:09 +0100
Message-Id: <1239264909.3373.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-04-09 at 00:37 -0500, Tom Zanussi wrote:
> Hi,
> 
> On Wed, 2009-04-08 at 16:24 +0200, Ingo Molnar wrote:
> > * Steven Whitehouse <swhiteho@redhat.com> wrote:
> > 
> > > Hi,
> > > 
> > > On Wed, 2009-04-08 at 15:53 +0200, Ingo Molnar wrote:
> > > > * Steven Whitehouse <swhiteho@redhat.com> wrote:
> > > > 
> > > > > Hi,
> > > > > 
> > > > > A little while back I posted a RFC patch which added gfs2 glock 
> > > > > tracing to blktrace. There was a suggestion that I should look 
> > > > > instead at the generic tracing code and add a new tracer, but I've 
> > > > > come up with a couple of issues along the way.
> > > > > 
> > > > > I think from what I can see that its only possible to run a single 
> > > > > tracer at once, so running blktrace (for example) would preclude 
> > > > > me from also tracing gfs2's glocks at the same time. Also, I can 
> > > > > see no mechanism by which I could ensure the sequencing between 
> > > > > the blktrace and glock traces other than exporting the blktrace 
> > > > > sequence number, even if running multiple tracers at the same time 
> > > > > was possible.
> > > > 
> > > > There's a recent addition: the EVENT_TRACE() facility. Would that 
> > > > suit your purposes?
> > > > 
> > > > 	Ingo
> > > 
> > > If I can get both blktrace and glock trace info from it, then yes. 
> > > I thought that the blktrace output went either via the original 
> > > relayfs path, or via its own tracer so that it wasn't possible to 
> > > use it and the event trace facility at the same time, unless I use 
> > > blktrace via relayfs. From what I've read I thought that probably 
> > > the relayfs interface for blktrace might eventually be removed in 
> > > favour of the generic tracing interface, but I'm not 100% sure of 
> > > that, so perhaps someone can confirm the plans in that area?
> > 
> > Tom Zanussi (Cc:-ed) recently converted the blktrace tracepoints to 
> > a tracing framework - and i think much of that could be reused to 
> > add EVENT_TRACE() tracepoints to blktrace too.
> > 
> > Tom, what's your take on this?
> > 
> > In general, this is the direction we want to take: EVENT_TRACE() 
> > tracepoints that can be used in a generic way, in any tracer.
> > 
> 
> Yeah, the EVENT_TRACE() tracepoints can be mixed any way you want by
> just enabling the ones you want to see:
> 
[lots of useful explanation cut here]

Thanks for the low down on this. Thats exactly what I need to know to
answer my question. I will continue to work on trace events support for
GFS2 and when I'm done with that, I may look at other things such as
blktrace if nobody has beaten me to it in the mean time,

Steve.



