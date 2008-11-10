Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYKJI7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYKJI7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbYKJI7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:59:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36569 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbYKJI7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:59:21 -0500
Date: Mon, 10 Nov 2008 09:58:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081110085846.GG22392@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <1226243805.27361.1283784629@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226243805.27361.1283784629@webmail.messagingengine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> Hi all,
> 
> I have spent some time trying to find out how expensive the 
> segment-switching patch was. I have only one computer available at 
> the time: a "Sempron 2400+", 32-bit-only machine.
> 
> Measured were timings of "hackbench 10" in a loop. The average was 
> taken of more than 100 runs. Timings were done for two seperate 
> boots of the system.

hackbench is _way_ too noisy to measure such cycle-level differences 
as irq entry changes cause. It also does not really stress interrupts 
- it only stresses networking, the VFS and the scheduler.

a better test might have been to generate a ton of interrupts, but 
even then it's _very_ hard to measure it properly. The best method is 
what i've suggested to you early on: run a loop in user-space and 
observe irq costs via RDTSC, as they happen. Then build a histogram 
and compare the before/after histogram. Compare best-case results as 
well (the first slot of the histogram), as those are statistically 
much more significant than a noisy average.

Measuring such things in a meaningful way is really tricky business. 
Using hackbench to measure IRQ entry micro-costs is like trying to 
take a photo of a delicate flower at night, by using an atomic bomb as 
the flash-light: you certainly get some sort of effect to report, but 
there's not many nuances left in the picture to really look at ;-)

	Ingo
