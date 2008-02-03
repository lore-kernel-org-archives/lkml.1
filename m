Return-Path: <linux-kernel-owner+w=401wt.eu-S933812AbYBCFf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbYBCFf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 00:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYBCFfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 00:35:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51829 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbYBCFfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 00:35:20 -0500
Date: Sun, 3 Feb 2008 06:35:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080203053507.GA21681@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <20080202193202.GB31621@elf.ucw.cz> <20080202193843.GB32039@elte.hu> <200802021837.17777.david-b@pacbell.net> <20080203050537.GA18942@elte.hu> <20080203051425.GA20740@elte.hu> <20080203051953.GA21183@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203051953.GA21183@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> i didnt have all RTC drivers enabled (it was a randconfig .config i 
> started out with) - but this did not appear to cure the problem. New 
> bootlog and new config attached.

i disabled all hpet items in the .config on the theory that they might 
interfere - but that didnt change the end result:

 [   23.893598] Calling initcall 0xc0c518b0: be_sleepy+0x0/0x170()
 [   23.901601] PM: no wakelarm-capable RTC
 [   23.905599] initcall 0xc0c518b0: be_sleepy+0x0/0x170() returned 0.
 [   23.910879] initcall 0xc0c518b0 ran for 3 msecs: be_sleepy+0x0/0x170()

so close, yet so far away :-)

i also disabled ACPI in the .config, which caused this:

 [   13.300838] Calling initcall 0xc0c32370: cmos_init+0x0/0x20()
 [   13.307063] initcall 0xc0c32370: cmos_init+0x0/0x20() returned -19.
 [   13.312840] initcall 0xc0c32370 ran for 0 msecs: cmos_init+0x0/0x20()

is that expected?

btw., small observation: from looking at the bootlog it's not apparent 
to me what kind of "RTC hardware" there is on this box. It's standard PC 
stuff, so i suspect what covers it is: CONFIG_RTC_DRV_CMOS=y, which 
says:

 [   14.900938] Calling initcall 0xc0c6f9c0: cmos_init+0x0/0x10()
 [   14.909178] pnp: the driver 'rtc_cmos' has been registered
 [   14.912945] rtc_cmos 00:04: disabling not supported
 [   14.916940] rtc_cmos: probe of 00:04 failed with error -16
 [   14.920959] initcall 0xc0c6f9c0: cmos_init+0x0/0x10() returned 0.
 [   14.926220] initcall 0xc0c6f9c0 ran for 11 msecs: cmos_init+0x0/0x10()

it might make sense to emit something like:

  PC-style RTC detected.

so that people know that your cool new RTC code is in action. Also, it's 
not apparent what the effects of that failure message is. When we fail 
something then users generally want to know: was it fatal, is it a 
warning, and what the limitations of that error condition are.

	Ingo
