Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXHDTUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXHDTUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 15:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765444AbXHDTUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 15:20:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55495 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765132AbXHDTUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 15:20:32 -0400
Subject: Re: [PATCH] msleep() with hrtimers
From: Arjan van de Ven <arjan@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0708040345530.1817@scrub.home>
References: <15327.1186166232@lwn.net>
	 <Pine.LNX.4.64.0708032116340.1817@scrub.home>
	 <1186170407.3153.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708032152060.1817@scrub.home>
	 <1186185229.3153.11.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708040345530.1817@scrub.home>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 04 Aug 2007 12:19:09 -0700
Message-Id: <1186255149.2777.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-04 at 05:00 +0200, Roman Zippel wrote:
> Hi,
> 
> On Fri, 3 Aug 2007, Arjan van de Ven wrote:
> 
> > > Actually the hrsleep() function would allow for submillisecond sleeps, 
> > > which might be what some of the 450 users really want and they only use
> > > msleep(1) because it's the next best thing.
> > > A hrsleep() function is really what makes most sense from an API 
> > > perspective.
> > 
> > I respectfully disagree. The power of msleep is that the unit of sleep
> > time is in the name; so in your proposal it would be hr_msleep or
> > somesuch. I much rather do the opposite in that case; make the "short"
> > name be the best implementation of the requested behavior, and have
> > qualifiers for allowing exceptions to that... least surprise and all
> > that.
> 
> hr_msleep makes no sense. Why should we tie this interface to millisecond 
> resolution?

because a lot of parts of the kernel think and work in milliseconds,
it's logical and USEFUL to at least provide an interface that works on
milliseconds.

> Your suggested msleep_approx makes not much sense to me either, since 
> neither interface guarantees anything and may "approximate" the sleep 
> (and if the user is surprised by that something else already went wrong).

an interface should try to map to the implementation that provides the
best implementation quality of the requested thing in general. That's
the hrtimers based msleep(). For cases where you're ok to compromise on
this behavior, you can add to the api.. it's the logical thing to do to
get the least surprises and the best normal behavior.

> If you don't like the hrsleep name, we can also call it nanosleep and so 
> match what we already do for userspace.

having a nanosleep *in addition* to msleep (or maybe nsleep() and
usleep() to have consistent naming) sounds reasonable to me.

Do you have something against hrtimer use in general? From your emails
on this msleep topic it sort of seems you do.... 
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

