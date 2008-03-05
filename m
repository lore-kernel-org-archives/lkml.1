Return-Path: <linux-kernel-owner+w=401wt.eu-S932744AbYCEXB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbYCEXB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765607AbYCEWzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:55:24 -0500
Received: from www.tglx.de ([62.245.132.106]:56431 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765304AbYCEWzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:55:20 -0500
Date: Wed, 5 Mar 2008 23:52:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Remy Bohmer <linux@bohmer.net>
cc: David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] atmel_tc clocksource/clockevent code
In-Reply-To: <3efb10970803051435y18f82903k729e2b2d1523d15c@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0803052349130.3099@apollo.tec.linutronix.de>
References: <1204636061-6275-1-git-send-email-hskinnemoen@atmel.com>  <1204636061-6275-2-git-send-email-hskinnemoen@atmel.com>  <3efb10970803041142l4a03dbb9uf11651d4cc7dde96@mail.gmail.com>  <200803041247.50877.david-b@pacbell.net> 
 <3efb10970803050317k68da7154w334561cc5efed637@mail.gmail.com>  <alpine.LFD.1.00.0803051742190.3099@apollo.tec.linutronix.de> <3efb10970803051435y18f82903k729e2b2d1523d15c@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Remy Bohmer wrote:
> Hello Thomas,
> 
> >  > Attached I have put a screendump of my ETM debugger. It shows a
> >  > complete flow of kernel function-calls of what happens on a timer
> >  > interrupt. In this example the complete sequence takes about 154 us.
> >  > Notice that the ETM is non-intrusive, and that the times are real and
> >  > accurate in this trace. (you can even see the effects of CPU-caches,
> >  > sometimes the same code just runs faster)
> >
> > Is there any chance to convert this to a text table? Following that
> >  png is pretty hard.
> 
> I will see what I can do, but this was the easiest way (it was just a
> print-screen;-) )
> But, will text-dump make it more clear? It could also contain the time
> each assembler instruction will take behind the routines...

text files can be parsed by scripts :)

> But, I will look into that tomorrow. (approx. 12 hours from now)

thnx
 
> >  > So, hires timestamps -> really really welcome.
> >  > hires timers -> there should be a (configurable) minimal resolution
> >  > that fits the hardware to not overload the CPU.
> >
> > clockevents let you set a minimum delta already. This can be set at
> >  runtime before registering the device.
> 
> But, I want to expose a bigger risk here.
> Apparently it is possible that a non privileged user can overload the
> system easily, by starting a high frequency periodic timer. The system
> will be that busy handling that timer that the system stops
> responding, thus it will result in some kind of Denial-of-Service
> situation, even on X86.

Wrong. The rearm condition is that the task is rescheduled. On any
platform.

Thanks,

	tglx
