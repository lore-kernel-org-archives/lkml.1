Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbXETV0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbXETV0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbXETV0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:26:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:36039 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537AbXETV0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:26:36 -0400
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Daniel Walker <dwalker@mvista.com>, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, Paul Mackerras <paulus@samba.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <4650632B.1010702@genesi-usa.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com>
	 <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org>
	 <464C99FF.8080404@ru.mvista.com>
	 <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org>
	 <1179500217.20519.53.camel@imap.mvista.com>
	 <464DC0DC.7050809@ru.mvista.com>
	 <1179502773.20519.56.camel@imap.mvista.com>
	 <17998.28659.702653.237011@cargo.ozlabs.ibm.com>
	 <1179628991.20925.2.camel@imap.mvista.com>
	 <1179630190.32247.534.camel@localhost.localdomain>
	 <4650632B.1010702@genesi-usa.com>
Content-Type: text/plain
Date: Mon, 21 May 2007 07:25:38 +1000
Message-Id: <1179696339.32247.568.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So.. if we get enough clocksources into the tree, can any of those
> parts of the code be reworked to use clocksources/clockevents and
> hrtimers quickly and easily? I noticed the patch just posted does
> some of it.. but not as much as Ben just mentioned.

Well, some of these are expected to be small & fast and work in all sort
of crazy circumstances, like udelay etc... I'd rather keep that on top
of the TB. Do we have actual examples where the TB freq is changing ?
Beside, on powerpc, we don't have another clock source that is as fast
to access and we have userland using the TB for gettimeofday via the
vdso, so I'd say bad idea ... Just keep the damn thing fixed frequency.

> Or is it a development nightmare?
> 
> I'm fairly sure on a PPC970 box even though the decrementer is
> monotonic and never changes frequency, one day it just might, and
> it would be better to anticipate this (and allow people to
> distribute their timing requirements across an entire system
> and not just the CPU core anyway, which I think is probably a
> good thing from a system integration and possibly the point of
> view of redundancy..)

On a -sane- 970 box (which seems to be the case of all of them that
matter so far), the TB is sourced externally specifically for that
reason : to avoid it changing, The DEC is always derived the TB, so it's
not changing.

I don't have any plan to support somebody coming up with a HW design
broken enough to have a variable TB/DEC speed. If they do it, they
support it and they come up with patches that are acceptable (hint: that
will be hard !). Beside, it means the vDSO will not be useable for
gettimeofday on such a platform, which means it will have to fallback to
the syscall which is much slower.

Ben.


