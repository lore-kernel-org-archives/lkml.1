Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbXD1UC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbXD1UC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbXD1UC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:02:28 -0400
Received: from www.osadl.org ([213.239.205.134]:46422 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751602AbXD1UC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:02:27 -0400
Subject: Re: 2.6.21 known regressions (v2) (for -stable team)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Meyer <thomas.mey@web.de>
In-Reply-To: <46338DF8.8010901@m3y3r.de>
References: <463375E5.5040108@googlemail.com>
	 <1177779971.7646.271.camel@localhost.localdomain>
	 <46338DF8.8010901@m3y3r.de>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 22:04:31 +0200
Message-Id: <1177790671.7646.278.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 20:10 +0200, Thomas Meyer wrote:
> Thomas Gleixner schrieb:
> > On Sat, 2007-04-28 at 18:27 +0200, Michal Piotrowski wrote:
> >   
> >> Subject    : Bad interaction between dynticks and amarok?
> >> References : http://lkml.org/lkml/2007/4/26/307
> >> Submitter  : Thomas Meyer <thomas.mey@web.de>
> >> Status     : Unknow
> >>     
> >
> > Michal,
> >
> > I don't think this is a regression. What Thomas wanted to point out is,
> > that the amarok / sound device is making the positive effect of dynticks
> > moot, as it starts to trigger useless interrupts.
> >
> > Thomas, is my interpretation correct ? Did you check, which interrupt
> > was increasing - i.e. was it the soundcard one ?
> >   
> No, it wasn't the soundcard one. but i had this effect with amarok and
> audacious... so, i guessed... which was wrong.
> 
> It's the timer interrupt (+50-70 timer interrupts). But i'm not sure
> what both applications are doing, while they are "idle"...

Ok, so amarok is one of those applications which arm timers for no
obvious reason. If you enable CONFIG_TIMER_STATS in the kernel, you can
analyse the timer offenders via the /proc/timer_stats interface.

	tglx


