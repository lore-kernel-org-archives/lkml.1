Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbXFPOwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbXFPOwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 10:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbXFPOwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 10:52:11 -0400
Received: from build.arklinux.osuosl.org ([140.211.166.26]:49902 "EHLO
	mail.arklinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbXFPOwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 10:52:10 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jun 2007 10:52:10 EDT
From: Bernhard Rosenkraenzer <bero@arklinux.org>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch-mm 01/25] NOHZ: Fix nox x86 dyntick idle handling
Date: Sat, 16 Jun 2007 16:36:50 +0200
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, Len Brown <lenb@kernel.org>,
       Dave Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de> <20070616101636.556333444@inhelltoy.tec.linutronix.de>
In-Reply-To: <20070616101636.556333444@inhelltoy.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706161636.50661.bero@arklinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007, Thomas Gleixner wrote:

> +#if defined(CONFIG_NO_HZ) && !defined(CONFIG_NONIRQ_WAKEUP)
> +	/* Make sure that timer wheel updates are propagated */
> +	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
> +		tick_nohz_stop_sched_tick();a
> +#endif
>  	preempt_enable_no_resched();
>  }

The bit above breaks the build for a CONFIG_NO_HZ build without 
CONFIG_NONIRQ_WAKEUP -- please remove the extra "a" after 
tick_nohz_stop_sched_tick(); before applying this.

Regards,
bero
