Return-Path: <linux-kernel-owner+w=401wt.eu-S1030609AbXCGOsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030609AbXCGOsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030795AbXCGOsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:48:53 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:20391 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030609AbXCGOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:48:52 -0500
Date: Wed, 7 Mar 2007 06:48:16 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Bill Irwin <bill.irwin@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
Message-ID: <20070307144816.GQ18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Hugh Dickins <hugh@veritas.com>, Chuck Ebbert <cebbert@redhat.com>,
	Andi Kleen <andi@firstfloor.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <45E5913D.3080505@redhat.com> <20070228204144.GA32316@one.firstfloor.org> <20070304015031.GA4224@holomorphy.com> <45EDBA1B.8050007@redhat.com> <Pine.LNX.4.64.0703061937450.19813@blonde.wat.veritas.com> <20070306203432.GD18774@holomorphy.com> <1173241715.3236.16.camel@laptopd505.fenrus.org> <20070307064423.GH18774@holomorphy.com> <1173270892.3176.4.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173270892.3176.4.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 22:44 -0800, Bill Irwin wrote:
>> What do you see as the obstacle to eliminating nested IRQ's?

On Wed, Mar 07, 2007 at 04:34:52AM -0800, Arjan van de Ven wrote:
> political will, or maybe just the lack of convincing people so far

Political issues are significantly more difficult to resolve than
technical ones.


On Tue, 2007-03-06 at 22:44 -0800, Bill Irwin wrote:
>>  It doesn't
>> seem so far out to test for being on the interrupt stack and defer the
>> call to do_IRQ() until after the currently-running instance of do_IRQ()
>> has returned, or to move to per-irq stacks modulo special arrangements
>> for the per-cpu IRQ's. Or did you have other methods in mind?

On Wed, Mar 07, 2007 at 04:34:52AM -0800, Arjan van de Ven wrote:
> it's simpler...
> irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
> { 
>         irqreturn_t ret, retval = IRQ_NONE;
>         unsigned int status = 0;
> 
>         handle_dynamic_tick(action);
>    
>         if (!(action->flags & IRQF_DISABLED))
>                 local_irq_enable_in_hardirq();
> 
> just removing the if() and the explicit IRQ enabling already makes irqs no longer nest...

I can see why that would raise eyebrows. I can see getting bashed
mercilessly with interrupt latency concerns as a result here. Can you
suggest any defenses?


-- wli
