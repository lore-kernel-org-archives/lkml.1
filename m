Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbXHBJtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbXHBJtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXHBJs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:48:59 -0400
Received: from ns.suse.de ([195.135.220.2]:48318 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbXHBJs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:48:58 -0400
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Andi Kleen <andi@firstfloor.org>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
References: <20070711214649.GK14435@v2.random>
	<alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
	<Pine.LNX.4.64.0707130415520.1818@scrub.home>
	<1184302024.6709.11.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0707131728070.1817@scrub.home>
	<1184389456.6632.13.camel@Homer.simpson.net>
	<Pine.LNX.4.64.0708010439050.1817@scrub.home>
	<p73wswfo0hf.fsf@bingen.suse.de>
	<Pine.LNX.4.64.0708011525560.1817@scrub.home>
	<alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
	<20070802045710.GA8720@1wt.eu>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Aug 2007 12:43:29 +0200
In-Reply-To: <20070802045710.GA8720@1wt.eu>
Message-ID: <p73643ynrn2.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

>(I remember it could not play with registers renaming, etc...).

This has changed in recent gccs. It doesn't force register pairs anymore.
Given the code is still not that good, but some of the worst sins are gone

> However, I undertand why Ingo chose to use 64 bits. It has the advantage
> that the numbers never wrap within 584 years. I'm well aware that it's
> very difficult to keep tasks ordered according to a key which can wrap.

If you define an appropiate window and use some macros for the comparisons
it shouldn't be a big problem.

> But if we consider that we don't need to be more precise than the return
> value from gettimeofday() that all applications use,

gettimeofday() has too strict requirements, that make it unnecessarily slow
for this task.

> every hour. We may accept to recompute all keys every hour.

You don't need to recompute keys; just use careful comparisons using
subtractions and a window. TCPs have done that for decades. 

> Have all keys use 32-bit resolution, and monitor the 32nd bit. All tasks

If you're worried about wrapping in one hour why is wrapping in two
hours not a problem? 

I have one request though. If anybody adds anything complicated
for this please make it optional so that 64bit platforms are not 
burdened by it.

-Andi
