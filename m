Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZK3VZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZK3VZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZK3VZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:25:20 -0500
Received: from www.tglx.de ([62.245.132.106]:59003 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbZK3VZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:25:19 -0500
Date: Mon, 30 Nov 2009 22:23:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
In-Reply-To: <20091130195129.GA19172@pengutronix.de>
Message-ID: <alpine.LFD.2.00.0911302216030.24119@localhost.localdomain>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain> <20091130195129.GA19172@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1107247360-1259616228=:24119"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1107247360-1259616228=:24119
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 30 Nov 2009, Uwe Kleine-König wrote:
> I think there is
> 
>  3) you can only benefit from decent priority hardware if irqs are
>     processed while irqs are enabled.
> 
> I think 
> 
> 	git grep handle_fasteoi_irq
> 
> gives an overview here: some hits in arch/powerpc, arch/sparc and
> arch/x86/kernel/apic/io_apic.c.  (There is handle_prio_irq in

No. That handler is not an indicator for prio hardware actively used
in the sense of allowing higher prio interrupts to interrupt a current
running lower priority one. It can be used when the irq controller
does not fire the interrupt again before the eoi acknowledge has been
done.

Thanks,

	tglx
--8323328-1107247360-1259616228=:24119--
