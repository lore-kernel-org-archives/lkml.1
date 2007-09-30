Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbXI3Ojb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbXI3Ojb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 10:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbXI3OjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 10:39:24 -0400
Received: from www.tglx.de ([62.245.132.106]:42148 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbXI3OjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 10:39:23 -0400
X-Greylist: delayed 1902 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2007 10:39:22 EDT
Date: Sun, 30 Sep 2007 16:06:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
X-X-Sender: tglx@localhost.localdomain
To: Andi Kleen <ak@suse.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [REGRESSION from 2.6.23-rc8] (was: Re: 2.6.23-rc4-mm1 and
 -rc6-mm1: boot failure on HP nx6325, related to clockevents)
In-Reply-To: <200709301158.17823.ak@suse.de>
Message-ID: <alpine.LFD.0.9999.0709301542410.3142@localhost.localdomain>
References: <200709231257.12213.rjw@sisk.pl> <1190842476.23376.57.camel@chaos> <alpine.LFD.0.999.0709261521440.3579@woody.linux-foundation.org> <200709301158.17823.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007, Andi Kleen wrote:

>>> OK, this explains 2) and 3). I just looked into the code and the logic
>>> vs. noapictimer on SMP is completely broken.
>
> noapictimer really doesn't make any sense on non SMP imho with the old
> timer architecture. That is why I never bothered to implement it.
> It's purely a UP hack.

It does not matter whether it makes sense to you or not. It is a command 
line option which bricks systems. There is neither an explanation in 
Dokumentation/kernel-parameters.txt nor a check in the code, which 
disables this completely.

It makes a lot of sense even with the existing architecture. Trouble 
shooting a box, where the local apic timer does not work correctly is not 
an UP only requirement.

Yes, it is a hack, a _bad_ hack.

>> ..and thanks for the explanation.
>>
>> Thanks for finding it so quickly guys. Sounds like this will be fixed
>> properly in 2.6.24 with the x86 merge (which hopefully brings in the hrt
>> patch too)
>
> There is nothing really to fix currently.  Clockevents changes behaviour
> majorly (always using APIC timers without irq 0 backups[1]) and that causes
> problems that need new workarounds and new fixes (surprise surprise!)
>
> That merge would probably fix a few more such "Thomas doesn't understand
> the code" bugs I guess because he hacks much more on i386 than x86-64;
> but if the overall result will be really better is a totally different
> question.

I understand the code quite well. I'm just surprised from time to time by 
interesting hacks in the so clean x8664 tree.

> [1]  Or let's call it "I trust all my time to the CPU" and no more southrbridge
> aka put all eggs in one basket. Given the trends in CPU power saving that
> is a quite dangerous strategy.

No, it's not dangerous. We spent quite some time to make the clock events 
layer flexible enough to handle the current problems and the design allows 
to add more infrastructure when necessary. The maybe new (mis)features of 
upcoming CPUs need to be addressed with or without clock events and they 
need to be done careful and not by random hacks.

       tglx
