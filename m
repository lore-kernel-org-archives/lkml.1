Return-Path: <linux-kernel-owner+w=401wt.eu-S1751331AbZFOQoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbZFOQoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZFOQoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:44:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZFOQoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:44:15 -0400
Date: Mon, 15 Jun 2009 12:44:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Frysinger <vapier.adi@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH] asm-generic: drop HARDIRQ_BITS definition from
	hardirq.h
Message-ID: <20090615164415.GB14053@goodmis.org>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> <200906132318.19208.arnd@arndb.de> <8bd0f97a0906131725l214007fcpfa90e72b03cad2ac@mail.gmail.com> <200906142243.32409.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906142243.32409.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Note: I prefer email to rostedt@goodmis.org over srostedt@redhat.com,
  just because I don't read my RH email as often. ]

On Sun, Jun 14, 2009 at 10:43:31PM +0200, Arnd Bergmann wrote:
> linux/hardirq.h contains a fallback for HARDIRQ_BITS to 10
> if it's not defined, so it is pointless to define a default
> of 8 in asm/hardirq.h. There does not seem to be a good
> reason why an architecture would want to limit the number
> of hardirqs this way.

After reading the thread again (from the beginning) I have a better idea
of what you are talking about. But the above description is misleading.

The HARDIRQ_BITS has nothing to do with the number of IRQS, it has to
do with the number of nested irqs allowed. Heck, 8 should be goog enough.

But the only thing I object to about this patch is that discription.

> 
> Reported-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/asm-generic/hardirq.h |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
> On Sunday 14 June 2009, Mike Frysinger wrote:
> 
> Mike Frysinger wrote:
> > is there any downsides to using a "too large" value ?  i.e. if my
> > system has less than 256, does it make any difference at all if it's
> > set to 10 ?
> > -mike
> 
> None that I know of. I'm queuing this patch in my asm-generic tree now,
> unless Steven or someone else has a better idea.
> 
> 	Arnd <><
> 
> diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
> index 3d5d2c9..23bb4da 100644
> --- a/include/asm-generic/hardirq.h
> +++ b/include/asm-generic/hardirq.h
> @@ -11,19 +11,6 @@ typedef struct {
>  
>  #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
>  
> -#ifndef HARDIRQ_BITS
> -#define HARDIRQ_BITS	8
> -#endif
> -
> -/*
> - * The hardirq mask has to be large enough to have
> - * space for potentially all IRQ sources in the system
> - * nesting on a single CPU:
> - */
> -#if (1 << HARDIRQ_BITS) < NR_IRQS
> -# error HARDIRQ_BITS is too low!
> -#endif

For the content of the patch:

 Acked-by: Steven Rostedt <rostedt@goodmis.org>

Because it too is misleading.

The only reason I did not remove all arch defined HARDIQR_BITS and just default
it to 10 or 8, is because one of the archs had that hardcoded in the asm, and
I did not want to break it.

-- Steve

> -
>  #ifndef ack_bad_irq
>  static inline void ack_bad_irq(unsigned int irq)
>  {
> -- 
> 1.6.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
