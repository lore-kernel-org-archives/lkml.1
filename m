Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXI3J6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXI3J6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 05:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXI3J6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 05:58:23 -0400
Received: from ns.suse.de ([195.135.220.2]:60387 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbXI3J6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 05:58:22 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION from 2.6.23-rc8] (was: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents)
Date: Sun, 30 Sep 2007 11:58:17 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200709231257.12213.rjw@sisk.pl> <1190842476.23376.57.camel@chaos> <alpine.LFD.0.999.0709261521440.3579@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709261521440.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301158.17823.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> > OK, this explains 2) and 3). I just looked into the code and the logic
> > vs. noapictimer on SMP is completely broken.

noapictimer really doesn't make any sense on non SMP imho with the old
timer architecture. That is why I never bothered to implement it.
It's purely a UP hack.
 
> ..and thanks for the explanation.
> 
> Thanks for finding it so quickly guys. Sounds like this will be fixed 
> properly in 2.6.24 with the x86 merge (which hopefully brings in the hrt 
> patch too)

There is nothing really to fix currently.  Clockevents changes behaviour
majorly (always using APIC timers without irq 0 backups[1]) and that causes
problems that need new workarounds and new fixes (surprise surprise!)

That merge would probably fix a few more such "Thomas doesn't understand
the code" bugs I guess because he hacks much more on i386 than x86-64;
but if the overall result will be really better is a totally different
question.

-Andi

[1]  Or let's call it "I trust all my time to the CPU" and no more southrbridge
aka put all eggs in one basket. Given the trends in CPU power saving that
is a quite dangerous strategy.
