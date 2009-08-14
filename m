Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZHNIRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZHNIRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 04:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZHNIRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 04:17:51 -0400
Received: from www.tglx.de ([62.245.132.106]:46908 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbZHNIRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 04:17:50 -0400
Date: Fri, 14 Aug 2009 10:17:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@fifo99.com>
Subject: Re: [patch 02/14] remove clocksource inline functions
In-Reply-To: <20090814101013.43e88657@skybase>
Message-ID: <alpine.LFD.2.00.0908141015540.1283@localhost.localdomain>
References: <20090813154034.613706651@de.ibm.com> <20090813154159.634291990@de.ibm.com> <1250201674.7149.3.camel@localhost.localdomain> <20090814101013.43e88657@skybase>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, Martin Schwidefsky wrote:
> On Thu, 13 Aug 2009 15:14:34 -0700
> john stultz <johnstul@us.ibm.com> wrote:
> > So you'll need to preserve the cycle_last = 0 line.
> 
> Whoa, now that is subtle. Good spotting. I would prefer to reset the 
> cycle_last in a resume function though:
> 
> Index: linux-2.6/arch/x86/kernel/tsc.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/tsc.c
> +++ linux-2.6/arch/x86/kernel/tsc.c
> @@ -744,10 +744,16 @@ static cycle_t __vsyscall_fn vread_tsc(v
>  }
>  #endif
> 
> +static void resume_tsc(void)
> +{
> +       clocksource_tsc.cycle_last = 0;
> +}
> +
>  static struct clocksource clocksource_tsc = {
>         .name                   = "tsc",
>         .rating                 = 300,
>         .read                   = read_tsc,
> +       .resume                 = resume_tsc,
>         .mask                   = CLOCKSOURCE_MASK(64),
>         .shift                  = 22,
>         .flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
> 
> That puts the subtlety where it belongs.

Ack.

	tglx
