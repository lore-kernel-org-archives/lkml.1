Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbYFLO35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbYFLO35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYFLO3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:29:50 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38011 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751472AbYFLO3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:29:49 -0400
Date: Thu, 12 Jun 2008 09:28:52 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCHv4] SGI UV: TLB shootdown using broadcast assist unit
Message-ID: <20080612142852.GA28430@sgi.com>
References: <E1K6lqI-0006pX-JQ@eag09.americas.sgi.com> <200806122235.29888.nickpiggin@yahoo.com.au> <20080612125605.GA26760@sgi.com> <200806122318.45397.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806122318.45397.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Thu, Jun 12, 2008 at 11:18:45PM +1000, Nick Piggin wrote:
> On Thursday 12 June 2008 22:56, Cliff Wickman wrote:
> > Hi Nick,
> >
> > On Thu, Jun 12, 2008 at 10:35:29PM +1000, Nick Piggin wrote:
> > > On Thursday 12 June 2008 22:23, Cliff Wickman wrote:
> 
> > > For someone not too familiar with low level x86 (or UV) code, can
> > > you explain why you are hooking at this point? I mean, what it
> > > looks like is either a performance improvement, or for some reason
> > > UV does not support send_IPI_mask out to CPUs "not on the local node".
> >
> > Yes, a performance improvement.  The UV machine has hardware for
> > broadcasting messages to a set of nodes (represented in a bit mask).  The
> > messages will raise interrupts at each of the target nodes and provide
> > the message - all in one step.
> > (IPI is supported.  In fact this patch falls back to the IPI method
> >  if all the cpus on the remote nodes do not respond.)
> 
> Thanks, that makes it perfectly clear to me now (the intent, not
> the details of the code :))
> 
> So long as this raises a maskable interrupt on each target CPU, it
> doesn't break x86's lockless get_user_pages :)
> 
> 
> > > If the former, what sort of improvement to you expect / see?
> >
> > Good question.  The hardware does not exist yet.  But using IPI there
> > would be one set of packets exchanged to deliver the interrupts and
> > another set to pull over the flush address, just to start the operation.
> > I expect the improvement to be significant.
> 
> Ah, so you can send a small message with the IPI, and that can be
> decoded and used by the target without invoking the cc protocol.
> Seems like pretty sweet functionality.
> 
> I guess TLB flushing is an obvious candidate, but it could be
> quite useful for other operations as well. I wonder if it couldn't
> be used to create a slightly more advanced API (than send_IPI)
> which other platforms can just implement using cache coherency for
> the payload...
> 
> For example, some classes of smp_call_function could use this too.

Jack Steiner's thought as well.  But I haven't considered any yet. If
you care to nominate any other such uses for this hardware mechanism
I'd like to hear your ideas.

> 
> But for now I don't see anything wrong with getting this patch
> upstream and looking to generalise it later.

-Cliff
-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
