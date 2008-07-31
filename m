Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYGaWSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYGaWSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYGaWSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:18:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47390 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYGaWS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:18:29 -0400
Date: Fri, 1 Aug 2008 00:17:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080731221744.GG23801@elte.hu>
References: <20080729172917.185593000@linux-os.sc.intel.com> <488FA318.3040905@zytor.com> <20080729232951.GB11223@linux-os.sc.intel.com> <488FAB2B.7050405@zytor.com> <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu> <20080730234102.GF11223@linux-os.sc.intel.com> <20080731212915.GH2729@elte.hu> <20080731215808.GB8563@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731215808.GB8563@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Thu, Jul 31, 2008 at 02:29:15PM -0700, Ingo Molnar wrote:
> > > Ingo, 2.6.25, 2.6.26 also reboots randomly with this config on my
> > > dual-socket system.
> > 
> > hmmm ....
> > 
> > a few guesses: perhaps I2C related (the randconfig turned on I2C bits)?
> > Do you have any way (hw test-kit) to figure out where the reboot comes
> > from - is it a triple fault caused by the kernel? Or some hardware
> > event?
> 
> Doh! I knew something was wrong with your randconfig :)
> 
> #
> # Watchdog Device Drivers
> #
> ....
> 
> CONFIG_PC87413_WDT=y
> CONFIG_60XX_WDT=y
> # CONFIG_SBC8360_WDT is not set
> CONFIG_CPU5_WDT=y
> CONFIG_SMSC37B787_WDT=y
> CONFIG_W83627HF_WDT=y
> CONFIG_W83697HF_WDT=y
> CONFIG_W83877F_WDT=y
> CONFIG_W83977F_WDT=y
> CONFIG_MACHZ_WDT=y
> CONFIG_SBC_EPX_C3_WATCHDOG=y
> 
> Kernel was enabling watchdog, with out the userspace having the 
> heartbeat daemon....

I never had function hw watchdog support on this box - so i guess the 
2.6.27-rc1 kernel started supporting it - cool.

This was unfortunate timing i guess - when i removed xsave i didnt get 
the reboot :-/

> randconfig is really not a good way to test! I can't even ssh to the 
> box with this config (something else is missing in the config!)

it is a randconfig tailored to my testboxes, it might not work out of 
box on yours :-)

randconfig is an excellent way of testing kernels, that testbox can run 
strings of hundreds (sometimes thousands) of random kernels without 
hitting any kernel bug. I had to resolve a large number of real kernel 
bugs (and a handful of glitches like this hardware watchdog thing) to 
get so far though.

> Anyhow, with watchdog removed, it works just fine. (both xsave and 
> non-xsave kernels)

Great, thanks. I've re-integrated tip/x86/xsave into x86/master and have 
pushed out the result.

	Ingo
