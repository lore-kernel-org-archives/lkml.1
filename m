Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbZDQP3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbZDQP3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbZDQP3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:29:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:39772 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838AbZDQP3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:29:10 -0400
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0904171100510.21575@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
	 <1239951613.23397.4107.camel@laptop>
	 <alpine.DEB.1.10.0904170941020.11877@qirst.com>
	 <1239977776.23397.4590.camel@laptop>
	 <alpine.DEB.1.10.0904171021360.20239@qirst.com>
	 <1239979901.23397.4638.camel@laptop>
	 <alpine.DEB.1.10.0904171100510.21575@qirst.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 17:28:57 +0200
Message-Id: <1239982137.23397.4684.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 11:04 -0400, Christoph Lameter wrote:
> On Fri, 17 Apr 2009, Peter Zijlstra wrote:
> 
> > And a random 1us cutoff, is well, random.
> 
> Its got to be somewhere.

No it doesn't, a cutoff is useless. If I steal cputime at units below
the cutoff I can, in the limit, steal up to 100% cpu time and you'd not
notice.

> > If you want to reduce interrupts, that's fine, but not counting an
> > interrupt because its below the magic 1us marker sounds a bit, well,
> > magic -- might work for you, might not for me on another machine, might
> > even be compiler dependent.
> 
> The point is to reduce the interrupts of user space application. Hardware
> interrupts etc are something else. Maybe I should not use the term
> interrupt. Cpu unavailability? Cache pollution?

The thing is, a 1us cut-off, or any other cut-off, doesn't tell you
_anything_ about availablity what so ever.

> > So 5 <1us interruption are not at all accounted, whereas a single 1>us
> > interruption is. I'd rather get rid of those 5 than try and shave a bit
> > of the one, if you get what I mean.
> 
> Ok. We can set the threshold lower and see how that goes.

Pointless. See above.

> > Furthermore, yes the scheduler is one of those jiffy tick users, but
> > there are more. We can do ntp/gtod things in there, there is process
> > accounting, there is some RCU machinery, timers etc..
> 
> Again things were fine before the scheduler changed.

Sure, it might be the scheduler, it might not be. I'm perfectly fine
with it being the scheduler, but show me where you're spending your time
and we can try and do something about it.

> Could we defer interrupts if a single process is running on a cpu and
> there is no other process on the runqueue and no other use of the timer
> interrupt?

If you can resolve all dependencies on the jiffy tick, maybe. Last time
I looked there were too many.

