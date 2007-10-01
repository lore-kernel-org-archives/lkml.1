Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbXJAOkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbXJAOkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbXJAOkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:40:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:25881 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbXJAOkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:40:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=STHQ8JQF5bunN6PQ5hK/KtiNU+dkqt8gl6wDoRuTUL5Cb5L1XPGffcht3hyFFYMS2q15/9JF83HVoMVlsFEGr2lNboB+YOVrFtrO9u0M9/yGsrITlKa15DIgF5qWvibf9IKwDF00J6UVWiU3L8boxevextwtoQI4f0Ls9J8dTPg=
Message-ID: <b70f2f960710010740x56683c38ma2c16f57a128cccf@mail.gmail.com>
Date: Mon, 1 Oct 2007 18:40:01 +0400
From: "Mikhail Kshevetskiy" <mikhail.kshevetskiy@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: x86_64 and AMD with C1E
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20071001130953.GC17357@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001101532.025d652f@localhost>
	 <p73r6kf6uwz.fsf@bingen.suse.de>
	 <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com>
	 <20071001130953.GC17357@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/1, Andi Kleen <andi@firstfloor.org>:
> > No, it boot and work normally. The only thing i bother, is the additional
>
> Ok you want an additional feature; not a bug fixed.
>
> Please make that always clear.
>
> > 260 timer interrupts per seconds.
> > Here is short result:
> >
> > c1e enabled:
> >   -- power consumption about 23 watts
> >   -- there is only C1 power state enabled
> >   -- there are about 260 timer interrupts per seconds
>
> If you want less timer interrupts in a standard kernel
> a simple way is to compile with CONFIG_HZ=100

i use NOHZ enabled kernel for test. I just noticed that i have the
same timer interrupts as if NOHZ was not selected (e.g. 2.6.22/x86_64)

> > tested with x86_64(2.6.22, 2.6.23-rc8, 2.6.23-rc8-hrt1), i386(2.6.21, 2.6.22,
> > 2.6.23-rc5-hrt1)
>
> There is normally a threshold above which you don't save significantly
> more power by doing less timer interrupts. You can test this
> by doing the CONFIG_HZ=100 above.
>
> Also as a warning: most simple methods of measuring power (like
> watching battery consumption) are fairly imprecise and can
> have large systematic errors.
>
> Normally reducing the timer interrupts significantly only helps
> on longer latency sleep modi; which is C2+ where the latency
> of going in/out of the sleep is reaching towards half of
> the timer period. But that is not the case on the AMD C1e
> implementations as far as I know -- they're fairly fast.

AMD say: C1E is a Stop Grant state like C3 supported by dual core
mobile processors.
The difference between C1E and C3 is that transition into C1E is not
initiated by the
operating system. The C1E state is initiated by an I/O transaction to
the chipset when
both cores transition into the C1 state.

> > c1e disabled:
> >   -- power consumption about 27 watts
>
> Don't do this then.
>
> > I want to reduce the power consumption of my notebook. I see the 2
> > possibility:
> >   -- remove 260 additional timer interrupts (c1e enabled case )
>
> It's unclear it will really help all that much. Most likely
> you'll get more bang for the buck by disabling other devices.
> e.g. reducing the backlight or unloading USB/firewire/sound
> can do wonders.
>
> >   -- force enable C1, C2 and C3 states  (c1e disabled case)
>
> If the BIOS doesn't announce it the platform doesn't implement it.

I think, it should support C1 and C2 at least.
