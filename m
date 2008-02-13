Return-Path: <linux-kernel-owner+w=401wt.eu-S1764853AbYBMFsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764853AbYBMFsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYBMFsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:48:32 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:47326 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbYBMFsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:48:31 -0500
Message-ID: <47B28473.9070605@qualcomm.com>
Date: Tue, 12 Feb 2008 21:47:31 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>, gregkh@suse.de,
       Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@tv-sign.ru>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull for -mm] CPU isolation extensions (updated2)
References: <47B11C45.6060408@qualcomm.com> <1202842788.6247.58.camel@lappy> <Pine.LNX.4.58.0802122335530.30573@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0802122335530.30573@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Steven Rostedt wrote:
> On Tue, 12 Feb 2008, Peter Zijlstra wrote:
>>> Rusty - Stop machine.
>>>    After doing a bunch of testing last three days I actually downgraded stop machine
>>>    changes from [highly experimental] to simply [experimental]. Pleas see this thread
>>>    for more info: http://marc.info/?l=linux-kernel&m=120243837206248&w=2
>>>    Short story is that I ran several insmod/rmmod workloads on live multi-core boxes
>>>    with stop machine _completely_ disabled and did no see any issues. Rusty did not get
>>>    a chance to reply yet, I hopping that we'll be able to make "stop machine" completely
>>>    optional for some configurations.
> 
> This part really scares me. The comment that you say you have run several
> insmod/rmmod workloads without kstop_machine doesn't mean that it is still
> safe. A lot of races that things like this protect may only happen under
> load once a month. But the fact that it happens at all is reason to have
> the protection.
> 
> Before taking out any protection, please analyze it in detail and report
> your findings why something is not needed. Not just some general hand
> waving and "it doesn't crash on my box".
Sure. I did not say lets disable it. I was hopping we could and I wanted to see what Rusty 
Russell has to say about this.

> Besides that, kstop_machine may be used by other features that can have an
> impact.
Yes it is. I missed a few. Nick and Dave already pointed out CPU hotplug. 
I looked around and found more users. So disabling stop machine completely is definitely out.

> Again, if you have a system that cant handle things like kstop_machine,
> than don't do things that require a kstop_machine run. All modules should
> be loaded, and no new modules should be added when the system is
> performing critical work. I see no reason for disabling kstop_machine.
I'm considering that option. So far it does not seem practical. At least the way we use those
machines at this point. If we can prove that at least not halting isolation CPUs is safe that'd
be better.

Max
