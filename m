Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXBWSvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXBWSvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:51:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932627AbXBWSvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:51:07 -0500
Received: from mail.astral.ro ([193.230.240.11]:48427 "EHLO mail.astral.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933175AbXBWSvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:51:05 -0500
Message-ID: <45DF3795.3040005@astral.ro>
Date: Fri, 23 Feb 2007 20:51:01 +0200
From: Gergely Imre <imre.gergely@astral.ro>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, hancockr@shaw.ca
Subject: Re: irq balancing question
References: <45DED0D6.1040700@astral.ro>	 <1172241917.3241.4.camel@laptopd505.fenrus.org>	 <45DF012D.3080802@astral.ro> <1172246085.3241.24.camel@laptopd505.fenrus.org>
In-Reply-To: <1172246085.3241.24.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Arjan van de Ven wrote:
>> in fact i have two cards, and 4 CPUs, but i was interested in then answer
>> Robert gave, that only _some_ machines distribute interrupts in hardware.
>> software distribution is obviously not good. consider this scenario:
>>
>> you have one machine with 4 cpus, and two ethernet cards with a lot of
>> traffic on them. if you bind every card to one cpu, two of them are not used,
>> so you really use only half the power. not let's say you have so much traffic
>> (with limiting enabled, htb or something), that the two CPUs are on 100% all
>> the time, but the other two are doing nothing.
>>
>> now if you could balance that to all 4 cpus, you could use all the power AND
>> no cpu would be used 100%.
> 
> actually this will give you worse performance than only using 2 cores.
> The reason for this is twofold
> 1) If you rotate the irqs, TCP and IP packet fragments will arrive at
> different CPUs. This in turn means that a VERY expensive reassembly path
> gets taken, compared to local-cpu-only reassembly
> 2) If you rotate the irqs, you bounce cachelines between the caches ALL
> THE TIME, which is also very expensive.
> 
> Both make it more likely that you'll be slower than just using only 2
> cores...

and i guess it doesn't matter if the distribution is being done by the
hardware, from the point of view of the kernel, i would still get the
performance penalty.

and what if CPU0 and CPU1 is actually the same CPU, only duo core, and i'm
distributing interrupts to them, and with the other card to CPU2 and 3 (which
are part of the other physical CPU) ?

i'm just trying to figure it out, i have no real knowledge of the inner
kernel workings, so i dont know. but i really would like to use all 4 cores.
just how expensive is that reassembly path ?
