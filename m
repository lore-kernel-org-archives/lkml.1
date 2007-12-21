Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbXLUW6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbXLUW6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbXLUW6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:58:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45978 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018AbXLUW6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:58:01 -0500
Date: Fri, 21 Dec 2007 23:54:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071221225413.GA26189@elte.hu>
References: <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> <20071221120908.GA15926@elte.hu> <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 21 Dec 2007, Peter Zijlstra wrote:
> 
> > BTW, does /proc/slabinfo exist again? I thought we set that as a 
> > requirement for SLUB to be the default and a full replacement for 
> > SLAB.
> 
> Well the information that would be exposed in /proc/slabinfo would 
> only be faked up stuff from SLUB. The queues that are described in 
> /proc/slabinfo do not exist f.e. (tunables do not make sense) and 
> there are more details available via /sys/kernel/slab.

Christoph, /proc/slabinfo is an _ABI_. You HAVE to provide it. slabtop 
relies on it, people use it every day to monitor memory consumption.

I'm really getting worried that you are apparently incapable of grasping 
such _SIMPLE_ concepts. Who the heck cares whether you put in zeros or 
whatever else in some of the fields? People use it to know how many 
objects are allocated and sure SLUB knows that count, sheesh. How on 
earth can you come up with a lame excuse like that? You dont like the 
'SLAB' portion of the name perhaps? Is it NIH again?

Really, if your behavior is representative of how our SLAB allocator 
will be maintained in the future then i'm very, very worried :-( You 
ignore and downplay clear-cut regressions, you insult and attack 
testers, you are incredibly stupid about user ABIs (or pretend to be so) 
and you distort and mislead all the way. What will you be able to do in 
the much less clear-cut cases??

	Ingo
