Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbYESM1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbYESM1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbYESM1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:27:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36457 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbYESM1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:27:06 -0400
Date: Mon, 19 May 2008 14:26:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] I/O APIC: AEOI timer acknowledgement clean-ups
Message-ID: <20080519122651.GA11318@elte.hu>
References: <Pine.LNX.4.55.0805170427440.4049@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0805170427440.4049@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> The code that used to be in do_slow_gettimeoffset() that relied on the 
> IRR bit of the master 8259A PIC for IRQ0 to check the state of the 
> output timer 0 of the PIT is no longer there.  As a result, there is 
> no need to use the POLL command to acknowledge the timer interrupt in 
> the "8259A Virtual Wire", except for the NMI watchdog when the 
> i82489DX APIC is used (this is because this particular APIC treats 
> NMIs as level-triggered and keeping the input asserted would keep 
> motherboard NMI sources held off for too long).  Remove the unneeded 
> bits and adjust comments accordingly.

applied to latest -tip, thanks Maciej!

>  It seems to work for me with the NMI watchdog routed through the I/O 
> APIC.  The next step should move the bits from timer_interrupt() to 
> nmi_watchdog_tick() where they now belong, but let's check nothing 
> breaks for people first.

ok.

	Ingo
