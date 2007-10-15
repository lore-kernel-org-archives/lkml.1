Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbXJOHlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbXJOHlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 03:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXJOHlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 03:41:10 -0400
Received: from mx10.go2.pl ([193.17.41.74]:59020 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753741AbXJOHlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 03:41:09 -0400
Date: Mon, 15 Oct 2007 09:44:05 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071015074405.GA1875@ff.dom.local>
References: <20071012082534.GB1962@ff.dom.local> <alpine.LFD.0.999.0710120802160.6887@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710120802160.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 08:13:52AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 12 Oct 2007, Jarek Poplawski wrote:
...
> So no, there's no way a software person could have afforded to say "it 
> seems to work on my setup even without the barrier". On a dual-socket 
> setup with s shared bus, that says absolutely *nothing* about the 
> behaviour of the exact same CPU when used with a multi-bus chipset. Not to 
> mention another revisions of the same CPU - much less a whole other 
> microarchitecture.

Yes, I still can't believe this, but after some more reading I start
to admit such things can happen in computer "science" too... I've
mentioned a lost performance, but as a matter of fact I've been more
concerned with the problem of truth:

From: Intel(R) 64 and IA-32 Architectures Software Developer's Manual
Volume 3A:

   "7.2.2 Memory Ordering in P6 and More Recent Processor Families
    ...
    1. Reads can be carried out speculatively and in any order.
    ..."

So, it looks to me like almost the 1-st Commandment. Some people (like
me) did believe this, others tried to check, and it was respected for
years notwithstanding nobody had ever seen such an event.

And then, a few years later, we have this:

From: Intel(R) 64 Architecture Memory Ordering White Paper

    "2 Memory ordering for write-back (WB) memory
     ...
     Intel 64 memory ordering obeys the following principles:
     1. Loads are not reordered with other loads.
     ..."

I know, technically this doesn't have to be a contradiction (for not
WB), but to me it's something like: "OK, Elvis lives and this guy is
not real Paul McCartney too" in an official CIA statement!

...
> Also, please note that we didn't even just change the barriers immediately 
> when the docs came out. I want to do it soon - still *early* in the 2.6.24 
> development cycle - exactly because bugs happen, and if somebody notices 
> something strange, we'll have more time to perhaps decide that "oops, 
> there's something bad going on, let's undo this for the real 2.6.24 
> release until we can figure out the exact pattern".

I'm still so "dazed and confused" that I can't tell this (or anything)
is right...

Thanks very much for so extensive and sound explanation,

Jarek P.

PS: Btw, I apologize Helge for not trusting her: "verification by
testing would not be trivial" words.
