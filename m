Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbYESOvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbYESOvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYESOvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:51:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40220 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYESOvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:51:00 -0400
Message-ID: <483193B3.3090807@firstfloor.org>
Date: Mon, 19 May 2008 16:50:27 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I/O APIC: Timer through 8259A revamp
References: <Pine.LNX.4.55.0805180237350.10067@cliff.in.clinika.pl> <87hccubgni.fsf@basil.nowhere.org> <Pine.LNX.4.55.0805191459220.19879@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0805191459220.19879@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  With the ACPI tables, hardware is modern enough the timer interrupt 
> should be directly available, but is usually wired in the way recommended 
> by the MP spec.

I originally had that assumption too, but in practice that doesn't seem
to be always the case unfortunately. Or sometimes the tests just fail
for whatever reason and they drop into the fallback path.

>  That is the output of the master 8259A goes to INT0 of 
> the I/O APIC (or is only connected to local APICs) and the timer is routed 
> to INT2.  

There are already a couple of wiring differences in common chipsets.
Mostly hurts on the fallback path especially when multiple sources are 
enabled (then you might end up with duplicated interrupts, happened often
on ATI systems)

>  The use of the local APIC timer as a replacement was recommended back
> then,

That was before CPU power saving was invented I guess @)

> but I think IRQ8 from the RTC was also a good solution, 

Trouble on Linux is that RTC doesn't support any of the traditional HZ 
values. I considered writing a RTC driver back then, but didn't do
it because of this. 

On the other hand with wider use of tickless kernels and hrtimers it might 
be tolerable to use non standard HZ,

-Andi
