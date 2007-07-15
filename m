Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXGOAUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXGOAUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 20:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765751AbXGOAUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 20:20:35 -0400
Received: from mx28.mail.ru ([194.67.23.67]:26697 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760763AbXGOAUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 20:20:35 -0400
Date: Sun, 15 Jul 2007 04:15:15 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pda_power: clean up irq, timer, return usage
Message-ID: <20070715001515.GA3641@zarina>
Reply-To: cbou@mail.ru
References: <20070714231204.GA23582@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070714231204.GA23582@havoc.gtf.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 07:12:04PM -0400, Jeff Garzik wrote:
> 
> Clean up pda_power interrupt handling:

Nice, thanks! Just few cosmetic comments.

> Prior to this patch, the driver would pass information it needed
> to the interrupt handler dev_id pointer, and then prompt forget it
> ever did so, recreating that same information after a couple passes
> through the timer-based state machine.
> 
> This patch removes the redundant checks by passing the
> pda_power_supply[] pointer through the state machine.  The current
> code passed 'irq' through the state machine, as an index to recreate
> the pointer, when we could more simply pass around the pointer itself.
> 
> Additionally, bogus "return;" statements were removed.

My preference is to use "return;" statements in functions returning
void, even if functions is very small. It's just sugar for my eyes,
to really see exit points. . Without returns I've feeling that
something is missing there. Yes, my oddity.

Plus, so far CodingStyle does not say anything about non obligatory
return statements.

These should be "fixed" too, though:
~/linux-2.6$ grep -h "return;" -A1 -r drivers/ arch/ | grep "^}$" | \
wc -l
1354

Obviously, drivers/ata is almost pure (3). ;-)

Either way, I prefer to leave alone these "return;"s, until CodingStyle
permits them.

> This patch makes it easier to remove the 'irq' argument in the future,
> in addition to cleaning up the driver today.
> 
> P.S.  Where are the MAINTAINERS entries for this driver, and
> drivers/power in general?

I'll send patch shortly.

> +	void *power_supply = (void *) power_supply_ptr;
                                     ^
I guess common practice is not to put space here.

> +	charger_timer.data = (unsigned long) power_supply;

And here.


I'll correct this, and will apply to battery2-2.6.git.

Thanks!

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
