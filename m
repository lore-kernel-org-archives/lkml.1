Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYGBUkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYGBUkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYGBUkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:40:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63781 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbYGBUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:40:04 -0400
Date: Wed, 2 Jul 2008 16:40:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: benh@kernel.crashing.org, Arjan van de Ven <arjan@linux.intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
In-Reply-To: <1215030120.3330.42.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0807021635470.22840@gandalf.stny.rr.com>
References: <1214916335.20711.141.camel@pasglop>  <486B0298.5030508@linux.intel.com>
 <1214977447.21182.33.camel@pasglop>  <1215007896.3330.6.camel@localhost.localdomain>
  <20080702200047.GA385@goodmis.org> <1215030120.3330.42.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2 Jul 2008, James Bottomley wrote:
> >
> > I think doing a "mini scheduler" inside a workgroup thread would be a
> > major hack.  We would have to have hooks into the normal scheduler to
> > let the mini-scheduler know something is blocking, and then have that
> > scheduler do some work. Not to mention that we need to handle
> > preemption.
>
> Not necessarly ... a simplistic round robin is fine.

Coming from the RT world I was hoping for something that we could have
better control of prioritizing the tasks ;-)

>
> The work to detect the "am I being blocked" has already been done for
> some of the aio patches, so I'm merely suggesting another use for it.

Hmm, I didn't realize this. I'll have to go look at that code.

>
> Isn't preemption an orthogonal problem ... it will surely exist even in
> the threadpool approach?

I was just thinking that the scheduler would need to differentiate between
being blocked and being preempted. Seems that anytime a task would sleep
(outside preemption) the mini-scheduler would need to schedule the next
task.

>
> > Having a thread pool sounds much more reasonable and easier to
> > implement.
>
> Easier to implement, yes.  Easier to program, unlikely, and coming with
> a large amount of overhead, definitely.

Hmm, I'd argue about the "easier to program" part, but the overhead I,
unfortunately, have to argee with you.

>
> > BTW, if something like this is implemented, I think that it should be a
> > replacement for softirqs and tasklets.


-- Steve

