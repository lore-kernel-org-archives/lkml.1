Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYKCNsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYKCNsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYKCNsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:48:15 -0500
Received: from mail.atmel.fr ([81.80.104.162]:58564 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbYKCNsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:48:15 -0500
Message-ID: <490F00F5.3020709@atmel.com>
Date: Mon, 03 Nov 2008 14:47:33 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Peter Zijlstra <peterz@infradead.org>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2.6.28-rc2] at91_mci: workaround lockdep
References: <200810271426.27110.david-b@pacbell.net> <1225213442.15763.20.camel@lappy.programming.kicks-ass.net> <200810281022.42803.david-b@pacbell.net>
In-Reply-To: <200810281022.42803.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell :
> On Tuesday 28 October 2008, Peter Zijlstra wrote:
>> On Mon, 2008-10-27 at 14:26 -0700, David Brownell wrote:
>>> From: David Brownell <dbrownell@users.sourceforge.net>
>>>
>>> Lockdep reported a problem in the at91_mci driver ... in this case, the
>>> issue is with lockdep, not with the driver. ...
>>>
>>> When __flush_dcache_aliases() returns -- inlined into flush_dcache_page(),
>>> above -- it re-enables IRQs ... since that evidently may only be called with
>>> IRQs enabled.  That's OK since the (unshared) IRQ handler doesn't ask for IRQs
>>> to be disabled.   Except ... that lockdep went and disabled them, then went on
>>> to complains about the breakage *it* caused!
>>>
>>> Workaround: depend on LOCKDEP=n ... 
>> In all previous such cases it was deemed the IRQ handler should deal
>> with whatever it gets.
> 
> In which case I'll wait until someone changes that IRQ handler (or that
> ARM MM utility, or lockdep), and give up using AT91 platforms for sanity
> testing kernel changes; lockdep is important, when it doesn't lie.

Changing IRQ handler in this driver... seem to be a big work.

Well, Dave, I tend to acknowledge your patch above as the IRQ for MCI is 
indeed a dedicated line (no need for IRQF_SHARED).

Are you ok with this ?

Regards,
-- 
Nicolas Ferre

