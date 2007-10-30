Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbXJ3Rwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbXJ3Rwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXJ3Rwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:52:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbXJ3Rw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:52:29 -0400
Date: Tue, 30 Oct 2007 10:50:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create kinst/ or ki/ directory ?
In-Reply-To: <20071030172442.GA4477@Krystal>
Message-ID: <alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org>
References: <20071029215138.GA4233@Krystal> <20071029154741.cb093f55.rdunlap@xenotime.net>
 <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal>
 <472667F3.3000505@garzik.org> <20071030172442.GA4477@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Mathieu Desnoyers wrote:
>
> * Jeff Garzik (jeff@garzik.org) wrote:
> ...
> > Pick a shorter word like probes or profile or what... or better yet... 
> > just leave most things in their current directories.
> ...
> 
> 
> How about something along the
> 
> kinst or ki
> 
> lines ?
> 
> (for "kernel instrumentation")

No, that's horrible.

Also, in general, why do people want to have an "instrumentation" thing? 
Yes, you can put random things into the same box, but that doesn't make 
them be the same thing. Personally, I don't think "instrumentation" is 
very useful at all. I consider "profiling" and "markers" to be two 
fundamentally different things, and putting them both in the same box does 
not make them any more similar. 

Yes, technically they are both "instrumentation", but hey, technically the 
VM and the VFS layer are both "infrastructure", but we don't put *those* 
in a "infrastructure" subdirectory.

In other words, the fact that two different things share some attribute 
does not mean that they should be collapsed together by that attribute, 
does it?

I think "instrumentation" was/is a particularly bad thing to group things 
by. It doesn't actually tell you anything about the thing, and it's not 
even true that some people are interested in "instrumentation"  and others 
aren't. 

For example: I think profiling support is something REALLY FUNDAMENTAL. 
It's something each and every developer should generally care about, and 
OProfile should be considered an indispensable tool for any developer, on 
par with something like gdb.

In contrast, we should *not* expect most people to do any kernel markers 
etc. That's a very esoteric thing.

So I actually think that the current Kconfig.instrumentation should be 
*removed*. Rather than adding more groupings based on that fundamentally 
flawed premise of false commonality.

		Linus
