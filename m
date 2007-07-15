Return-Path: <linux-kernel-owner+w=401wt.eu-S932707AbXGOA3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbXGOA3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 20:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbXGOA3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 20:29:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47477 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760763AbXGOA3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 20:29:12 -0400
Message-ID: <46996A53.6000807@garzik.org>
Date: Sat, 14 Jul 2007 20:29:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: cbou@mail.ru
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pda_power: clean up irq, timer, return usage
References: <20070714231204.GA23582@havoc.gtf.org> <20070715001515.GA3641@zarina>
In-Reply-To: <20070715001515.GA3641@zarina>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> On Sat, Jul 14, 2007 at 07:12:04PM -0400, Jeff Garzik wrote:
>> Clean up pda_power interrupt handling:
> 
> Nice, thanks! Just few cosmetic comments.
> 
>> Prior to this patch, the driver would pass information it needed
>> to the interrupt handler dev_id pointer, and then prompt forget it
>> ever did so, recreating that same information after a couple passes
>> through the timer-based state machine.
>>
>> This patch removes the redundant checks by passing the
>> pda_power_supply[] pointer through the state machine.  The current
>> code passed 'irq' through the state machine, as an index to recreate
>> the pointer, when we could more simply pass around the pointer itself.
>>
>> Additionally, bogus "return;" statements were removed.
> 
> My preference is to use "return;" statements in functions returning
> void, even if functions is very small. It's just sugar for my eyes,
> to really see exit points. . Without returns I've feeling that
> something is missing there. Yes, my oddity.
> 
> Plus, so far CodingStyle does not say anything about non obligatory
> return statements.
> 
> These should be "fixed" too, though:
> ~/linux-2.6$ grep -h "return;" -A1 -r drivers/ arch/ | grep "^}$" | \
> wc -l
> 1354
> 
> Obviously, drivers/ata is almost pure (3). ;-)
> 
> Either way, I prefer to leave alone these "return;"s, until CodingStyle
> permits them.

CodingStyle is not the end-all of rulebooks.  See repeated messages by 
Linus, me, and others on the subject.  CodingStyle intentionally does 
not list a rule for every possible C code incarnation.

It's the general style to avoid these return statements in new code.  It 
makes the page longer, meaning less code to review.  It tends to trip up 
people making bombing runs through drivers, and searching for return 
statements in their favorite editor.

If you consider how many void functions there are in the kernel, 1354 is 
the obvious minority, being far smaller than "millions."  Please follow 
what -millions- of void functions already do in the kernel.


>> This patch makes it easier to remove the 'irq' argument in the future,
>> in addition to cleaning up the driver today.
>>
>> P.S.  Where are the MAINTAINERS entries for this driver, and
>> drivers/power in general?
> 
> I'll send patch shortly.
> 
>> +	void *power_supply = (void *) power_supply_ptr;
>                                      ^
> I guess common practice is not to put space here.

incorrect.  a space goes there, as I put it.


>> +	charger_timer.data = (unsigned long) power_supply;
> 
> And here.

ditto.

