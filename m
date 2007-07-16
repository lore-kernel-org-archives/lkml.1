Return-Path: <linux-kernel-owner+w=401wt.eu-S1765102AbXGPQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765102AbXGPQIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759349AbXGPQIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:08:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:22039 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759166AbXGPQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Afn8ullzd/IcI4UfCOuKM2cKEOZCJ6GPtnxAXfbiMJE1oeJxponH9N34Ww84kFzqwEnmmzfLrE6cx3VwCkSR4gvzsFm5J4eqUfqYT6ZN3RsNU90a4xgLltVPuczL4Bm5/vYAxRgVUHYZNbNTCtwU8tA89/U0Eej0txb4q5tV/Bk=
Message-ID: <29495f1d0707160908x32704c7o41ab7857ceac1558@mail.gmail.com>
Date: Mon, 16 Jul 2007 09:08:05 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH/RFC] msleep() with hrtimers
Cc: "Roman Zippel" <zippel@linux-m68k.org>, "Jonathan Corbet" <corbet@lwn.net>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <2c0942db0707160857s25cbce19j7f057b14e74651e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21003.1184596954@lwn.net>
	 <Pine.LNX.4.64.0707161654130.1817@scrub.home>
	 <2c0942db0707160857s25cbce19j7f057b14e74651e8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> On 7/16/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> > On Mon, 16 Jul 2007, Jonathan Corbet wrote:
> > > > One possible problem here is that setting up that timer can be
> > > > considerably more expensive, for a relative timer you have to read the
> > > > current time, which can be quite expensive (e.g. your machine now uses the
> > > > PIT timer, because TSC was deemed unstable).
> > >
> > > That's a possibility, I admit I haven't benchmarked it.  I will say that
> > > I don't think it will be enough to matter - msleep() is not a hot-path
> > > sort of function.  Once the system is up and running it almost never
> > > gets called at all - at least, on my setup.
> >
> > That's a bit my problem - we have to consider other setups as well.
> > Is it worth converting all msleep users behind their back or should we
> > just a provide a separate function for those who care?
>
> As a driver author (2.4 timeframe, embedded platform, see gitinc.com
> for the hardware description), I would rather msleep did what it says
> it's going to do. If the current one can wait 20 times longer than you
> ask for, then that's just broken.

Well, before these changes, the only guarantee msleep() could make,
just like the only guarantee schedule_timeout() could make, was that
it would not return early. The 1-jiffy sleep was always tough to deal
with, because of rounding and such. And it's simply exacerbated with
HZ=100. It's not technically 20 times longer in all cases, it's 2
jiffies longer, which depends on HZ, so varies from 2 msecs longer to
20 msecs longer.

Thanks,
Nish
