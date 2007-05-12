Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbXELUNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbXELUNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbXELUNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:13:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:35610 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbXELUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g3ZV85Hnq1SbmHV05EazuPk5TXGfjCZ6/NqCTPFWsYI0wDOliYH5jVK4PZnDTaf0s0xmGmBsLKDTeyq4Q3sk1w1URs28nNOfW9ox6ux+7J8CQmlq1FTXSP+s2bViVOL6mKvWDTV6VvP2/7JjyHuExa741rBrY0yQ0TZQO3nNdUQ=
Message-ID: <38b2ab8a0705121313k37be467cy55402b490101ac9c@mail.gmail.com>
Date: Sat, 12 May 2007 22:13:43 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: tglx@linutronix.de
Subject: Re: clockevent questions
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1178982892.22481.183.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0705120754l281f54eevd1e91e2f01fff6f2@mail.gmail.com>
	 <1178982892.22481.183.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for answering so quickly !

On 5/12/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> Francis,
>
> On Sat, 2007-05-12 at 16:54 +0200, Francis Moreau wrote:
> > I'm trying to use clocksource and clockevent new subsystem. My
> > platform has a timer that I'd like to use both as a clocksource and a
> > clockevent devices.
>
> See arch/i386/kernel/hpet.c
>

thanks for the pointer

> > This timer is continueous in sense that it can run
> > without any interruption
>
> -ENOPARSE
>
> Has your timer a free running counter and a match register based event
> mechanism ?
>

yes

> > so I assume I can flag the clocksource device
> > with "CLOCK_SOURCE_IS_CONTINUOUS". However I noticed that clockevent
> > device can be stopped by using "set_mode()" method. Are these two
> > behaviours compatible ?
>
> the clock event stop only stops the event mechanism, it does not stop
> the counter.
>
> See arch/i386/kernel/hpet.c
>

OK. I got it now, In my initial plan, I was thinking to stop the
counter to stop the event. But that's not the right thing to do. It
seems that I should disable event interrupt instead.

> > Another question is that I have another embedded 16 bits timer that I
> > would like to use. Since the timer is only 16 bits, the maximum
> > interval is tiny, My question if a user ask for a clockevent device
> > using an interval is bigger that 2^16, the clockevent system doesn't
> > return an error. Instead it silently reduce the interval to 2^16. Is
> > this correct ? if so why ?
>
> Yes, it is correct. The generic timer code requests an event in the
> future. It does not care, whether the hardware device can handle that or
> not. So the clock event code limits the delta to the maximum delta the
> device can handle. The interrupt fires and the generic timer code
> reschedules the event with the remaining delta time.
>

Thanks again for explanations. Could you give me a pointer of this reschedules ?

-- 
Francis
