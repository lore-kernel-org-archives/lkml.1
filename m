Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbXGPP5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbXGPP5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758092AbXGPP5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:57:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:5537 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbXGPP5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Ds/wDH4+ga4/dAOVlMHASq16r1XLBSRMYhjpc7V5zHHi4vJLqw9kqIEIPb9QqQ9OqiuwxSRdAX4dKLClfCk9kyjiJNfUg7VDdw/rjuw73MjnTpJVJYisBYDG4lrzpxaCGJuX+9U9QGf6b9Pook0DqqMpYVLX6nW5j9oVraoXsVw=
Message-ID: <2c0942db0707160857s25cbce19j7f057b14e74651e8@mail.gmail.com>
Date: Mon, 16 Jul 2007 08:57:22 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
Cc: "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0707161654130.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21003.1184596954@lwn.net>
	 <Pine.LNX.4.64.0707161654130.1817@scrub.home>
X-Google-Sender-Auth: 24ef4ff9717e420d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> On Mon, 16 Jul 2007, Jonathan Corbet wrote:
> > > One possible problem here is that setting up that timer can be
> > > considerably more expensive, for a relative timer you have to read the
> > > current time, which can be quite expensive (e.g. your machine now uses the
> > > PIT timer, because TSC was deemed unstable).
> >
> > That's a possibility, I admit I haven't benchmarked it.  I will say that
> > I don't think it will be enough to matter - msleep() is not a hot-path
> > sort of function.  Once the system is up and running it almost never
> > gets called at all - at least, on my setup.
>
> That's a bit my problem - we have to consider other setups as well.
> Is it worth converting all msleep users behind their back or should we
> just a provide a separate function for those who care?

As a driver author (2.4 timeframe, embedded platform, see gitinc.com
for the hardware description), I would rather msleep did what it says
it's going to do. If the current one can wait 20 times longer than you
ask for, then that's just broken.

> > > One question here would be, is it really a problem to sleep a little more?
> >
> > "A little more" is a bit different than "twenty times as long as you
> > asked for."  That "little bit more" added up to a few seconds when
> > programming a device which needs a brief delay after tweaking each of
> > almost 200 registers.
>
> Which driver is this? I'd like to look at this, in case there's some other
> hidden problem.

"Hidden problem"? Lots of hardware has quiescent wait-time
requirements, to guarantee that whatever is going on it it's little
state machine head finally reaches a stable state. Waiting for those
changes to take effect before starting the next set of register
reprogramming is a common requirement -- on the hardware I've worked
with at least.

Ray
