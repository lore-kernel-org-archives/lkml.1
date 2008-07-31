Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbYGaWnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbYGaWnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYGaWmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:42:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786AbYGaWmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:42:47 -0400
Date: Thu, 31 Jul 2008 15:38:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       =?ISO-8859-15?Q?P=E1draig_Brady?= <P@draigBrady.com>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
In-Reply-To: <20080731221924.GD8563@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.1.10.0807311531271.3277@nehalem.linux-foundation.org>
References: <20080729172917.185593000@linux-os.sc.intel.com> <488FA318.3040905@zytor.com> <20080729232951.GB11223@linux-os.sc.intel.com> <488FAB2B.7050405@zytor.com> <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu> <20080730234102.GF11223@linux-os.sc.intel.com>
 <20080731212915.GH2729@elte.hu> <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221435.GS23938@one.firstfloor.org> <20080731221924.GD8563@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Suresh Siddha wrote:
> On Thu, Jul 31, 2008 at 03:14:35PM -0700, Andi Kleen wrote:
> > > Kernel was enabling watchdog, with out the userspace having the
> > > heartbeat daemon....
> > 
> > Watchdog are  normally only armed when someone opens the device
> > first.
> 
> But thats not what I see with for ex with, w83627hf_wdt.c
> 
> Its done at the module_init time. (while I thought it should be
> really done when some user level app opens the device, probably
> its poorly written to take care if the kernel panics before starting userland.
> but kernel can even die before the watchdog driver load aswell ;-)

Yeah, that's a _really_ broken watchdog timer driver. There's no way that 
it's correct to start the watchdog at init time, at least when compiled 
in.

It also looks to me like it's not even probing for the hardware - it's 
just assuming it's there. That's scary. Am I missing something?

It really shouldn't be activated until it's opened. And it really 
shouldn't just write to ports randomly without checking that they make
sense...

			Linus
