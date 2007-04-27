Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbXD0AWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbXD0AWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXD0AWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:22:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755233AbXD0AWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:22:32 -0400
Date: Thu, 26 Apr 2007 17:22:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <1177630366.25960.100.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.98.0704261716270.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
  <20070426040806.GJ3468@stusta.de>  <20070426125802.GL3468@stusta.de>
 <1177630366.25960.100.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Thomas Gleixner wrote:
> 
> Maybe we need to coordinate changes better. 2.6.21 got three big updates
> which affected suspend/resume - one of them is my fault. But fiddling
> out which one of those - we had nested problems as well - makes it quite
> hard to grok them in time, especially if they happen only on one
> reporters system.

Yes. _If_ we had known how painful the timer changes would end up being, 
we'd probably have done them separately from everything else.

That is the kind of thing that looks obvious in hindsight: merge stuff 
that is questionable and scary alone, and don't do anything else that 
release cycle.

But while the timer code is obviously pretty core, I think everybody 
expected it to be a lot easier to merge (and it had existed as patches in 
various forms for some time).

So we simply didn't know beforehand that it was going to cause the kinds 
of regressions it did cause (and in fact, some of the regressions were 
initially blamed on other things entirely - some of them looked like IO 
regressions).

Water under the bridge. It's also easy to say in hindsight that something 
should have been merged separately and been given a release cycle all its 
own.

			Linus
