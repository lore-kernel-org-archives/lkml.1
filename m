Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYJ3PKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYJ3PKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbYJ3PKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:10:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46363 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbYJ3PKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:10:41 -0400
Date: Thu, 30 Oct 2008 11:10:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Theodore Tso <tytso@mit.edu>
cc: =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Daniel Walker <dwalker@mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2 v3][RFC] trace: profile likely and unlikely
 annotations
In-Reply-To: <20081030145543.GC14744@mit.edu>
Message-ID: <alpine.DEB.1.10.0810301106360.4935@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu> <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com> <20081028143720.GD8869@mit.edu>
 <20081028074816.04193e04@infradead.org> <alpine.DEB.1.10.0810281050440.29482@gandalf.stny.rr.com> <alpine.DEB.1.10.0810291233580.13214@gandalf.stny.rr.com> <alpine.DEB.1.10.0810291833540.6145@gandalf.stny.rr.com> <20081030143238.GB7157@logfs.org>
 <20081030145543.GC14744@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Oct 2008, Theodore Tso wrote:

> On Thu, Oct 30, 2008 at 03:32:39PM +0100, J?rn Engel wrote:
> > On Wed, 29 October 2008 18:39:55 -0400, Steven Rostedt wrote:
> > >
> > >    69768    61064  87 __switch_to                    process_64.c         624
> > >    15557   115251 100 __switch_to                    process_64.c         594
> > >    15555   115227 100 __switch_to                    process_64.c         590
> > 
> > I may be out of school for a while, but that math sure looks odd.
> > 
> > > +	if (p->correct) {
> > > +		percent = p->incorrect * 100;
> > > +		percent /= p->correct;
> >                 percent /= p->correct + p->incorect;
> 
> And once you do the above fix, I don't think what is below is
> necessary any more.  :-)

Bah! Total brain-fart.  Thanks ;-)

> 
> > > +		/* No need to see huge numbers */
> > > +		if (percent > 100)
> > > +			percent = 100;
> 
> I would also calculate the percent correct rather than the percent
> incorrect, on the general theory that 100% good, 0% bad is easier for
> my little brain to understand, but that's just a minor thing...

I thought about whether or not to show percent correct or precent 
incorrect.  I chose, incorrect, just because it is easier to spot the 
trouble makers.  You can say, lets allow 25% incorrect, better than saying 
lets have a minimum of 75%.  I think the mind can pick out those that go 
over a number better than it can see those that are under a number.

Thanks,

-- Steve

