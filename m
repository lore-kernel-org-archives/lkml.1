Return-Path: <linux-kernel-owner+w=401wt.eu-S1762189AbXEOHYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189AbXEOHYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbXEOHX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:23:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:37102 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbXEOHX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:23:58 -0400
Subject: Re: [patch 4/4] powerpc 2.6.21-rt1: reduce scheduling latency by
	changing tlb flush size
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <200705141640.02561.arnd@arndb.de>
References: <yyi3b1zapqa.wl@toshiba.co.jp>
	 <1179125506.22481.297.camel@localhost.localdomain>
	 <yyitzuf9857.wl@toshiba.co.jp>  <200705141640.02561.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 15 May 2007 17:23:09 +1000
Message-Id: <1179213789.32247.166.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 16:40 +0200, Arnd Bergmann wrote:
> On Monday 14 May 2007, Tsutomu OWA wrote:
> > --- linux-2.6.21-rt1/include/asm-powerpc/tlbflush.h     2007-04-26 12:08:32.000000000 +0900
> > +++ rt/include/asm-powerpc/tlbflush.h   2007-05-14 16:12:47.000000000 +0900
> > @@ -25,7 +25,12 @@ struct mm_struct;
> >  #include <linux/percpu.h>
> >  #include <asm/page.h>
> >  
> > +#if defined(CONFIG_PPC_CELLEB) && defined(CONFIG_PREEMPT_RT)
> > +/* Since tlb flush takes long time on Celleb, reduce it to 1 when Celleb && RT */
> > +#define PPC64_TLB_BATCH_NR 1
> > +#else
> >  #define PPC64_TLB_BATCH_NR 192
> > +#endif /* defined(CONFIG_PPC_CELLEB) && defined(CONFIG_PREEMPT_RT) */
> 
> With this code, you get silent side-effects of enabling PPC_CELLEB
> along with another platform.
> 
> Maybe instead you should change the hpte_need_flush() to always flush
> when running on the celleb platform and PREEMPT_RT is enabled.

I think it's wrong either way.... Maybe we can make it a variable and
measure how much we can reasonably do in a given time frame at
boot ? :-) Since it depends wether there's an hypervisor etc...

Ben.


