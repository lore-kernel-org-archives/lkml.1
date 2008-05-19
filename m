Return-Path: <linux-kernel-owner+w=401wt.eu-S1764312AbYESWec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764312AbYESWec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYESWeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:34:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49412 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbYESWeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:34:22 -0400
Message-ID: <4832006B.1030106@firstfloor.org>
Date: Tue, 20 May 2008 00:34:19 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I/O APIC: Timer through 8259A revamp
References: <Pine.LNX.4.55.0805180237350.10067@cliff.in.clinika.pl> <87hccubgni.fsf@basil.nowhere.org> <Pine.LNX.4.55.0805191459220.19879@cliff.in.clinika.pl> <483193B3.3090807@firstfloor.org> <Pine.LNX.4.55.0805192247230.19879@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0805192247230.19879@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Mon, 19 May 2008, Andi Kleen wrote:
> 
>>>  With the ACPI tables, hardware is modern enough the timer interrupt 
>>> should be directly available, but is usually wired in the way recommended 
>>> by the MP spec.
>> I originally had that assumption too, but in practice that doesn't seem
>> to be always the case unfortunately. Or sometimes the tests just fail
>> for whatever reason and they drop into the fallback path.
> 
>  Well, the fallback path was meant to be used with hardware suffering from
> limitations and not from broken configuration tables. 

I don't think it was wrong tables generally, but more screwy hardware.

The main table problem were with nvidia with the wrong timer overrides,
but that was handled elsewhere. And a long time ago ACPI couldn't handle
the VIA interrupt configuration properly, but that was also fixed later.

>> On the other hand with wider use of tickless kernels and hrtimers it might 
>> be tolerable to use non standard HZ,
> 
>  I don't think the value of HZ should be a problem anymore now that we
> have a separate user-visible HZ 

I wasn't worried about the units in sysctl, but about the minimum delay
time in select() and other timeout syscalls. And yes changing that
changes user behaviour significantly. And it's still HZ granuality.
I don't think anybody dared to change it to hrtimers yet because it has
potentially large impact on applications.

Of course you could probably define a "true user hz" that is emulated
with hrtimers even when the system tick is different. Problem is also
that a lot of systems don't support hrtimers yet because they have both
broken APIC timer and missing HPET.

-Andi

