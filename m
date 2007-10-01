Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbXJANMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbXJANMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbXJANJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:09:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48006 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbXJANJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:09:55 -0400
Date: Mon, 1 Oct 2007 15:09:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86_64 and AMD with C1E
Message-ID: <20071001130953.GC17357@one.firstfloor.org>
References: <20071001101532.025d652f@localhost> <p73r6kf6uwz.fsf@bingen.suse.de> <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> No, it boot and work normally. The only thing i bother, is the additional

Ok you want an additional feature; not a bug fixed.

Please make that always clear.

> 260 timer interrupts per seconds.
> Here is short result:
> 
> c1e enabled:
>   -- power consumption about 23 watts
>   -- there is only C1 power state enabled
>   -- there are about 260 timer interrupts per seconds

If you want less timer interrupts in a standard kernel
a simple way is to compile with CONFIG_HZ=100

> tested with x86_64(2.6.22, 2.6.23-rc8, 2.6.23-rc8-hrt1), i386(2.6.21, 2.6.22,
> 2.6.23-rc5-hrt1)

There is normally a threshold above which you don't save significantly
more power by doing less timer interrupts. You can test this 
by doing the CONFIG_HZ=100 above.

Also as a warning: most simple methods of measuring power (like
watching battery consumption) are fairly imprecise and can
have large systematic errors.

Normally reducing the timer interrupts significantly only helps
on longer latency sleep modi; which is C2+ where the latency
of going in/out of the sleep is reaching towards half of 
the timer period. But that is not the case on the AMD C1e
implementations as far as I know -- they're fairly fast.

> c1e disabled:
>   -- power consumption about 27 watts

Don't do this then.

> I want to reduce the power consumption of my notebook. I see the 2
> possibility:
>   -- remove 260 additional timer interrupts (c1e enabled case )

It's unclear it will really help all that much. Most likely
you'll get more bang for the buck by disabling other devices.
e.g. reducing the backlight or unloading USB/firewire/sound
can do wonders.

>   -- force enable C1, C2 and C3 states  (c1e disabled case)

If the BIOS doesn't announce it the platform doesn't implement it.

-Andi
