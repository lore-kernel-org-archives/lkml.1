Return-Path: <linux-kernel-owner+w=401wt.eu-S935297AbXEWRXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935297AbXEWRXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756735AbXEWRXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:23:36 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:63722 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756240AbXEWRXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:23:36 -0400
Subject: Re: [PATCH 3/7] lockdep: lock contention tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0705231159310.22023@dhcp83-20.boston.redhat.com>
References: <20070523072618.129001605@chello.nl>
	 <20070523095807.407148940@chello.nl>
	 <Pine.LNX.4.64.0705231035270.22023@dhcp83-20.boston.redhat.com>
	 <1179932865.7019.90.camel@twins>
	 <Pine.LNX.4.64.0705231159310.22023@dhcp83-20.boston.redhat.com>
Content-Type: text/plain
Date: Wed, 23 May 2007 19:23:31 +0200
Message-Id: <1179941011.7019.103.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 12:11 -0400, Jason Baron wrote:
> On Wed, 23 May 2007, Peter Zijlstra wrote:
> 
> > On Wed, 2007-05-23 at 10:40 -0400, Jason Baron wrote:
> > > On Wed, 23 May 2007, Peter Zijlstra wrote:
> > > 
> > > > Count lock contention events per lock class. Additionally track the first four
> > > > callsites that resulted in the contention.
> > > > 
> > > 
> > > I think that we need the total number of locking calls, not just the total 
> > > number of *contended* locking calls, in order to make the data 
> > > significant. Same for waittime. Yes, this pollutes the fastpath. In the 
> > > contention case, its one extra addition, and for the waittime, its a call 
> > > the sched_clock(). I don't think that's too much to pay for much more 
> > > meaningful data.
> > 
> > The holdtime statistics add these numbers.
> > 
> 
> ok, i see what you are saying...however, the 'waittime' statistic as 
> implemented, is only recorded when we don't get the lock immediately. 
> Thus, it's really measuring the waittime when there is lock contention. I 
> understand that in the non-contended case we are only talking a a few 
> cycles, but the fact that the non-contended case is not counted as another 
> waittime of even zero length (so no measurement is required), might skew 
> the stats a bit. For examples, if there was a lock that was almost never 
> contended but one time happened to be contended for a long time, its 
> average wait time would look really high.

I'm not seeing how or why this is a problem. The number of contentions
is reported on the same line, so it should be obvious.

Your definition of wait-time is also obtainable from the numbers, one
would just divide waittime-total by acquisitions, instead of
contentions.




