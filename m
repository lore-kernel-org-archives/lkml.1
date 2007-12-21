Return-Path: <linux-kernel-owner+w=401wt.eu-S1757682AbXLUV4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbXLUV4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXLUV4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:56:13 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53026 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753254AbXLUV4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:56:13 -0500
Date: Fri, 21 Dec 2007 13:56:11 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071221163337.GA8660@elte.hu>
Message-ID: <Pine.LNX.4.64.0712211350540.3795@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
 <20071221120908.GA15926@elte.hu> <20071221122628.GA18002@elte.hu>
 <Pine.LNX.4.64.0712210818360.29372@schroedinger.engr.sgi.com>
 <20071221163337.GA8660@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007, Ingo Molnar wrote:

> > There are patches pending to address these issues. AFAICT Intel is 
> > testing if the regression is still there. There is no way for me to 
> > verify what is going on there and there is the constant difficulty of 
> > getting detailed information about what is going on at Intel. Every 
> > couple of month I get a result from that test. Its a really crappy 
> > situation where a lot of confusing information is passed around.
> 
> of course there is a way to find out, and that's why i mailed you: fix 
> the hackbench regression and i'm quite sure you'll improve the TPC-C 
> numbers as well. It shows the same kind of overhead in the profile and 
> takes just a few seconds to run. Are your pending SLUB patches in 
> 2.6.24-rc5-mm1 already?

The tests that I wrote emulate the test behavior that was described to me 
by me.

The fixes in 2.6.24-rc5-mm1 improved those numbers. See 
http://lkml.org/lkml/2007/10/27/245 which I quoted earlier to you. 
However, I have no TPC-C setup here and from what I hear it takes weeks to 
run and requires a large support team for tuning.

You can find the slab test suite for that at

http://git.kernel.org/?p=linux/kernel/git/christoph/vm.git;a=shortlog;h=tests

AFAICT the fixes in 2.6.25-rc5-mm1 result in double the alloc performance 
(fastpath) of SLAB.

There are fixes that are not merged yet (the cpu alloc patchset) that 
seem to make that factor 3 because we can use the segment register to 
avoid per cpu array lookups in the fast path.
