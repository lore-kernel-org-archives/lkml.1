Return-Path: <linux-kernel-owner+w=401wt.eu-S1764622AbXJOWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764622AbXJOWXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXJOWXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:23:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39570 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXJOWX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:23:29 -0400
Date: Tue, 16 Oct 2007 00:23:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] scsi: fix crash in gdth_timeout()
Message-ID: <20071015222306.GA19773@elte.hu>
References: <20071015165534.GA17833@elte.hu> <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org> <4713A9FA.4050209@garzik.org> <4713B4E7.2050001@panasas.com> <20071015192703.GA7279@elte.hu> <alpine.LFD.0.999.0710151232430.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710151232430.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 15 Oct 2007, Ingo Molnar wrote:
> > 
> > heh. Incidentally i was thinking about using KVM for automated 
> > testing.
> 
> Using emulators to test device drivers is almost certain to be 
> pointless.

something like that wont enable 100% coverage (or even reasonable 
coverage for most hardware), so it's no replacement for actual hard 
testing, but it could push out the domain of minimally tested code quite 
a bit and increase the quality of the kernel. Races are always tough and 
so are bugs on the side of the hardware, but it's the silly boot-time 
crash showstoppers and "device does not work anymore" mistakes that 
causes us to lose most of the testers and early adopters.

I'm not really worried about the 1% of bugs that are tough to find and 
fix (because they are actually fun to find and fix), i'm worried about 
the 99% easy and boring bugs - because they annoy users just as much as 
the exciting bugs do. If we fix them faster then there's more time (and 
more tester stamina) left for the harder to find bugs.

so i think adding redundancy in form of a simplified hw emulator can 
certainly not hurt and fundamentally increases robustness - and it will 
definitely reduce the chance for a whole host of stupid bugs that are 
not in the hardware but are in the ~4 million lines of Linux driver 
codebase. Limits and scalability would also be testable: "if i put 32 of 
these networking cards into a Linux box, will the Linux driver blow up".

not that i think this is realistic for any significant portion of the 
hardware currently - unless some hw maker starts doing it. But KVM will 
have a good portion of the core PC platform emulated (APIC, etc.) - and 
that's a nice step forward already.

	Ingo
