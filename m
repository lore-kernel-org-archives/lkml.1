Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbXGKWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbXGKWKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761997AbXGKWKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:10:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761817AbXGKWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:10:30 -0400
Date: Wed, 11 Jul 2007 15:09:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@suse.de>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <20070711214649.GK14435@v2.random>
Message-ID: <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
 <20070711211638.GE18767@one.firstfloor.org>
 <20070711214649.GK14435@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Andrea Arcangeli wrote:
>
> I'm going to change topic big time because your sentence above
> perfectly applies to the O(1) scheduler too.

I disagree to a large degree.

We almost never have problems with code you can "think about".

Sure, bugs happen, but code that everybody runs the same generally doesn't 
break. So a CPU scheduler doesn't worry me all that much. CPU schedulers 
are "easy".

What worries me is interfaces to hardware that we know looks different for 
different people. That means that any testing that one person has done 
doesn't necessarily translate to anything at *all* on another persons 
machine.

The timer problems we had when merging the stuff in 2.6.21 just scarred 
me. I'd _really_ hate to have to go through that again. And no, the 
"gradual" thing where the patch that actually *enables* something isn't 
very gradual at all, so that's the absolutely worst kind of thing, because 
then people can "git bisect" to the point where it got enabled and tell us 
that's where things broke, but that doesn't actually say anything at all 
about the patch that actually implements the new behaviour.

So the "enable" kind of patch is actually the worst of the lot, when it 
comes to hardware.

When it comes to pure software algorithms, and things like schedulers, 
you'll still obviously have timing issues and tuning, but generally things 
*work*, which makes it a lot easier to debug and describe.

		Linus
