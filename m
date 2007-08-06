Return-Path: <linux-kernel-owner+w=401wt.eu-S1761666AbXHFAo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761666AbXHFAo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 20:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXHFAoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 20:44:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41047 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbXHFAoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 20:44:19 -0400
Subject: Re: [PATCH] msleep() with hrtimers
From: Arjan van de Ven <arjan@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0708060150270.1817@scrub.home>
References: <15327.1186166232@lwn.net>
	 <Pine.LNX.4.64.0708032116340.1817@scrub.home>
	 <1186170407.3153.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708032152060.1817@scrub.home>
	 <1186185229.3153.11.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708040345530.1817@scrub.home>
	 <1186255149.2777.3.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060150270.1817@scrub.home>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 05 Aug 2007 17:43:03 -0700
Message-Id: <1186360983.2697.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > because a lot of parts of the kernel think and work in milliseconds,
> > it's logical and USEFUL to at least provide an interface that works on
> > milliseconds.
> 
> If the millisecond resolution is enough for these users, that means the 
> current msleep will work fine for them.

except that you get a 20ms minimum, and 10ms increment.

> This generalization is simply not true. First it requires the 
> HIGH_RES_TIMERS option to be enabled to really make a real difference.

so? you provide the best possible for the config options selected...


> > > If you don't like the hrsleep name, we can also call it nanosleep and so 
> > > match what we already do for userspace.
> > 
> > having a nanosleep *in addition* to msleep (or maybe nsleep() and
> > usleep() to have consistent naming) sounds reasonable to me.
> 
> We only need one sleep implementation of both and msleep is a fine name 
> for the current implementation - not only does it describe the unit, but 
> it also describe the best resolution one can expect from it.

that's... combining 2 independent things into one. That's not a really
good idea.


> I can give the question back, what do you have against simple timers, that 
> you want to make them as awkward as possible to use?

msleep() isn't about timers. The timer type used is an implementation
detail behind the interface!!!!

Timers are course resolution that is highly HZ-value dependent. For
cases where you want a finer resolution, the kernel now has a way to
provide that functionality... so why not use the quality of service this
provides..

> hrtimer have a higher usage cost depending on the clock source, so simply 
> using them only because they are the new cool kid in town doesn't make 
> sense.

no but they DO provide a much better quality of the api implementation;
instead of a 20ms timeout you get really close to what you asked for!

There have been drivers that did if (HZ<1000) mdelay(x); else msleep(x);
Yes that's horrible, but it's a clear sign that this matters.

>  It may not be that critical for a simple sleep implementation, but 
> that only means we should keep the API as simple as possible, that means 
> one low resolution, cheap msleep and one high resolution nanosleep is 
> enough. Why do you insist on making more complex than necessary?

ehm it was you who insisted on adding complexity to this; the initial
proposal was to just replace the msleep() implementation with one that
has a more gentle behavior (you ask for 1ms you get 1ms, not 20ms)

What really is your problem with that? "It may be more expensive on some
hardware?"

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

