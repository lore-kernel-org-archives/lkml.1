Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYANQQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYANQQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYANQQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:16:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbYANQQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:16:22 -0500
Date: Mon, 14 Jan 2008 17:16:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ed Tomlinson <edt@aei.ca>
Cc: Matthew <jackdachef@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of
	32bit applications(binaries) on 64bit system (Gentoo)
Message-ID: <20080114161610.GE15542@elte.hu>
References: <200801102122.51507.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801102122.51507.edt@aei.ca>
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


* Ed Tomlinson <edt@aei.ca> wrote:

> >> - if yes, does booting with "nmi_watchdog=2 idle=poll" give you a
> >>   working NMI watchdog? (working NMI watchdog means the NMI counts 
> >>   increase for all cores in /proc/interrupts).
> 
> > booting with the above gives me an incrementing NMI counter in 
> > /proc/interrupts
> 
> Ingo,
> 
> Is there anything else that needs to be set in the kernel config for 
> the nmi watchdog to trigger?
> 
> I ask because I just had a hang but nothing showed on the _serial_ 
> console - I waited a couple of minutes before rebooting....  Is there 
> any other way to verify the watchdog is working?

if you cause a hard lockup intentionally via an infinite irqs-off loop:
  
# cat > lockupcli.c
main ()
{
	iopl(3);
	for (;;) asm("cli");
}
Ctrl-D
make lockupcli
./lockupcli

does the NMI watchdog properly trigger? If not, does booting with 
idle=poll change the situation?

	Ingo
