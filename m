Return-Path: <linux-kernel-owner+w=401wt.eu-S1764518AbZE1U5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764518AbZE1U5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760887AbZE1U5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:57:31 -0400
Received: from claw.goop.org ([74.207.240.146]:52889 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbZE1U5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:57:31 -0400
Message-ID: <4A1EFABA.7070600@goop.org>
Date: Thu, 28 May 2009 13:57:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu> <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de>
In-Reply-To: <20090528061702.GB6920@wotan.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> FWIW, we had to disable paravirt in our default SLES11 kernel.
> (admittedly this was before some of the recent improvements were
> made).

Yes, I think you'll find it worth trying with it enabled again.  The 
spinlock thing clearly slowed things down, but when that's disabled the 
difference to native is very small.

> But OTOH, almost any bit feature is going to cost performance. I don't
> think this is something new (as noted with CONFIG_SECURITY). It is
> just something people have to trade off and decide for themselves.
> If you make it configurable and keep performance as good as reasonably
> possible, then I don't think more can be asked.
>   

Yes, that's exactly my point.  If I've worked on a feature, I clearly 
want people to use that feature.   Part of making it useful is to make 
the distro/vendor/user decision to enable that feature as easy as 
possible, by making the tradeoffs simple.

But tradeoffs are always going to cut both ways: positive (kernel 
automatically works in a wider range of environments), and negative 
(performance questions, complexity, etc).  Ultimately its the distro's 
decision to enable a particular feature, and the distro's responsibility 
to cope with the consequences of that.

> If performance overhead is too much and/or too few users can take
> advantage of a feature, then distros can always special-case it. I
> think may did for pae...

I think that would be a clear sign of a problem.  The whole point of 
pvops is to avoid needing multiple kernel builds.

    J
