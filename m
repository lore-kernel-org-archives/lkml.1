Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbYAFJzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbYAFJzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 04:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYAFJzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 04:55:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39010 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYAFJzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 04:55:22 -0500
Date: Sun, 6 Jan 2008 10:55:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Message-ID: <20080106095501.GG26291@elte.hu>
References: <200801052042.56042.rjw@sisk.pl> <47801690.3090106@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47801690.3090106@rtr.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Lord <lkml@rtr.ca> wrote:

> Rafael J. Wysocki wrote:
>> This message contains a list of some regressions from 2.6.23 reported since
>> 2.6.24-rc1 was released, for which there are no fixes in the mainline I know
>> of.  If any of them have been fixed already, please let me know.
> ..
>> Subject		: 20000+ wake-ups/second in 2.6.24
>> Submitter	: Mark Lord <lkml@rtr.ca>
>> Date		: 2007-12-02 04:23
>> References	: http://lkml.org/lkml/2007/12/1/141
>> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9489
>> Handled-By	: Arjan van de Ven <arjan@infradead.org>
>>
> ..
>
> I have only seen that one once, and I think it was Arjan who said that 
> it has been observed rarely by other people as well. The bugzilla 
> entry is mostly just to track the darned thing, but it seems unlikely 
> that anyone will find/fix it for 2.6.24. No big deal, but it would be 
> good to have somebody knowledgeable in clocks/interrupts try and track 
> it down.
>
> I wonder if it's just a babbling IRQ on resume, before the driver has 
> run it's resume code or something ?

i've read the discussions, and i cannot see it analyzed anywhere _what_ 
causes the wakeups. And how are these wakeups counted? Is this based on 
powertop output:

 Wakeups-from-idle per second : 20.4     interval: 1.8s

? Somewhere i saw it mentioned that "the CPU throws out of C mode". What 
does that mean - does it mean we try to idle again and again, but we 
immediately return from C mode - while this all looks like "idle" time 
to the scheduler (so 'top' will show lots of idle time), but the ACPI 
wakeup counters are going up like mad? What is /proc/interrupts doing 
when this happens - is any of the irq sources going upwards?

	Ingo
