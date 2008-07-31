Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbYGaWwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbYGaWwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759776AbYGaWut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:50:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759719AbYGaWus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:50:48 -0400
Date: Fri, 1 Aug 2008 00:50:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080731225004.GD22426@elte.hu>
References: <20080729232951.GB11223@linux-os.sc.intel.com> <488FAB2B.7050405@zytor.com> <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu> <20080730234102.GF11223@linux-os.sc.intel.com> <20080731212915.GH2729@elte.hu> <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221435.GS23938@one.firstfloor.org> <20080731221924.GD8563@linux-os.sc.intel.com> <alpine.LFD.1.10.0807311531271.3277@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807311531271.3277@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > But thats not what I see with for ex with, w83627hf_wdt.c
> > 
> > Its done at the module_init time. (while I thought it should be 
> > really done when some user level app opens the device, probably its 
> > poorly written to take care if the kernel panics before starting 
> > userland. but kernel can even die before the watchdog driver load 
> > aswell ;-)
> 
> Yeah, that's a _really_ broken watchdog timer driver. There's no way 
> that it's correct to start the watchdog at init time, at least when 
> compiled in.
> 
> It also looks to me like it's not even probing for the hardware - it's 
> just assuming it's there. That's scary. Am I missing something?
> 
> It really shouldn't be activated until it's opened. And it really 
> shouldn't just write to ports randomly without checking that they make 
> sense...

there are a handful of old ISA-ish drivers that can crash randconfig 
kernels in various ways. [indefinite lockups, crashes, stomped-over 
hardware, non-working keyboard, etc.]

I mapped most of them out via many months of trial-and-error - but it 
would still be nice to have some separate config option to disable the 
known ones. CONFIG_ALLOW_NON_GENERIC or something like that - which i 
would unset in the randconfig runs.

( They are not CONFIG_BROKEN per se, because often it's hardware that
  cannot be probed in any reliable way - the driver just assumes it's 
  there. )

	Ingo
