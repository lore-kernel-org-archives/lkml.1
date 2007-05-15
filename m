Return-Path: <linux-kernel-owner+w=401wt.eu-S1761733AbXEOHi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733AbXEOHi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbXEOHix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:38:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:49265 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbXEOHiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:38:52 -0400
Subject: Re: [patch 4/4] powerpc 2.6.21-rt1: reduce scheduling latency by
	changing tlb flush size
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <yyips5261pt.wl@toshiba.co.jp>
References: <yyi3b1zapqa.wl@toshiba.co.jp>
	 <1179125506.22481.297.camel@localhost.localdomain>
	 <yyitzuf9857.wl@toshiba.co.jp> <200705141640.02561.arnd@arndb.de>
	 <yyips5261pt.wl@toshiba.co.jp>
Content-Type: text/plain
Date: Tue, 15 May 2007 17:38:27 +1000
Message-Id: <1179214707.32247.177.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +
> +#ifdef CONFIG_PREEMPT_RT
> +	/*
> +	 * Since flushing tlb needs expensive hypervisor call(s) on celleb,
> +	 * always flush it on RT to reduce scheduling latency.
> +	 */
> +	if (machine_is(celleb)) {
> +		flush_tlb_pending();
> +		return;
> +	}
> +#endif /* CONFIG_PREEMPT_RT */
> +
>  	if (i >= PPC64_TLB_BATCH_NR)
>  		flush_tlb_pending();
>  }

Any reason to do that only on celleb ? :-)

Also, we might want to still batch, though in smaller amount. Have you measured
the time it takes ? We might want to modulate the amount based on wether we
are using native hash tables or an hypervisor.

Ben.


