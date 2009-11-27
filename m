Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbZK0WSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbZK0WSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 17:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZK0WSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 17:18:53 -0500
Received: from www.tglx.de ([62.245.132.106]:50453 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbZK0WSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 17:18:52 -0500
Date: Fri, 27 Nov 2009 23:18:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED registered
 with setup_irq
In-Reply-To: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain>
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-881699030-1259357776=:24119"
Content-ID: <alpine.LFD.2.00.0911272236520.24119@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-881699030-1259357776=:24119
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.0911272236521.24119@localhost.localdomain>

On Fri, 27 Nov 2009, Uwe Kleine-König wrote:

> IRQF_DISABLED is not guaranteed on shared irqs.  There is already a
> warning in place for irqs registered with request_irq (introduced in
> 470c66239ef03).  Move it to __setup_irq, this way it triggers for both
> request_irq and setup_irq.
> 
> One irq that is now warned about is the timer tick on at91 (ARCH=arm).

And how does that help ? The interrupt is shared between the timer and
the debug port. There is nothing you can do about that.

The interupt handlers are called in order of setup. The AT91 timer
irq is set up first and if that's not the case then it needs to be
fixed and the only way to catch it is in the affected interrupt
handler.

Applying your patch does not change the hardware and will just result
in useless, annoying and confusing dmesg warnings.

> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Remy Bohmer <linux@bohmer.net>,
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
> Cc: Andrea Gallo <andrea.gallo@stericsson.com>,

Nice that you added me (and others) to that long list, but ...

> Cc: Thomas Gleixner <tglx@linutronix.de>,
------------------------------------------^

Thanks,

	tglx
--8323328-881699030-1259357776=:24119--
