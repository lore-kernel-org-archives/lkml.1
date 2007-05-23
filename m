Return-Path: <linux-kernel-owner+w=401wt.eu-S935281AbXEWQbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935281AbXEWQbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759403AbXEWQbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:31:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758032AbXEWQbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:31:24 -0400
Date: Wed, 23 May 2007 12:11:15 -0400 (EDT)
From: Jason Baron <jbaron@redhat.com>
X-X-Sender: jbaron@dhcp83-20.boston.redhat.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] lockdep: lock contention tracking
In-Reply-To: <1179932865.7019.90.camel@twins>
Message-ID: <Pine.LNX.4.64.0705231159310.22023@dhcp83-20.boston.redhat.com>
References: <20070523072618.129001605@chello.nl>  <20070523095807.407148940@chello.nl>
  <Pine.LNX.4.64.0705231035270.22023@dhcp83-20.boston.redhat.com>
 <1179932865.7019.90.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 May 2007, Peter Zijlstra wrote:

> On Wed, 2007-05-23 at 10:40 -0400, Jason Baron wrote:
> > On Wed, 23 May 2007, Peter Zijlstra wrote:
> > 
> > > Count lock contention events per lock class. Additionally track the first four
> > > callsites that resulted in the contention.
> > > 
> > 
> > I think that we need the total number of locking calls, not just the total 
> > number of *contended* locking calls, in order to make the data 
> > significant. Same for waittime. Yes, this pollutes the fastpath. In the 
> > contention case, its one extra addition, and for the waittime, its a call 
> > the sched_clock(). I don't think that's too much to pay for much more 
> > meaningful data.
> 
> The holdtime statistics add these numbers.
> 

ok, i see what you are saying...however, the 'waittime' statistic as 
implemented, is only recorded when we don't get the lock immediately. 
Thus, it's really measuring the waittime when there is lock contention. I 
understand that in the non-contended case we are only talking a a few 
cycles, but the fact that the non-contended case is not counted as another 
waittime of even zero length (so no measurement is required), might skew 
the stats a bit. For examples, if there was a lock that was almost never 
contended but one time happened to be contended for a long time, its 
average wait time would look really high.

thanks,

-Jason 
