Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYJ3Oz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYJ3Oz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYJ3Ozu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:55:50 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41467 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753343AbYJ3Ozu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:55:50 -0400
Date: Thu, 30 Oct 2008 10:55:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20081030145543.GC14744@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Mike Snitzer <snitzer@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Daniel Walker <dwalker@mvista.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu> <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com> <20081028143720.GD8869@mit.edu> <20081028074816.04193e04@infradead.org> <alpine.DEB.1.10.0810281050440.29482@gandalf.stny.rr.com> <alpine.DEB.1.10.0810291233580.13214@gandalf.stny.rr.com> <alpine.DEB.1.10.0810291833540.6145@gandalf.stny.rr.com> <20081030143238.GB7157@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081030143238.GB7157@logfs.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 03:32:39PM +0100, Jörn Engel wrote:
> On Wed, 29 October 2008 18:39:55 -0400, Steven Rostedt wrote:
> >
> >    69768    61064  87 __switch_to                    process_64.c         624
> >    15557   115251 100 __switch_to                    process_64.c         594
> >    15555   115227 100 __switch_to                    process_64.c         590
> 
> I may be out of school for a while, but that math sure looks odd.
> 
> > +	if (p->correct) {
> > +		percent = p->incorrect * 100;
> > +		percent /= p->correct;
>                 percent /= p->correct + p->incorect;

And once you do the above fix, I don't think what is below is
necessary any more.  :-)

> > +		/* No need to see huge numbers */
> > +		if (percent > 100)
> > +			percent = 100;

I would also calculate the percent correct rather than the percent
incorrect, on the general theory that 100% good, 0% bad is easier for
my little brain to understand, but that's just a minor thing...

					- Ted
