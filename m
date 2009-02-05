Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbZBEIBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbZBEIBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZBEIBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:01:11 -0500
Received: from relay.parallels.com ([195.214.232.42]:47419 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbZBEIBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:01:10 -0500
From: Kirill Korotaev <dev@parallels.com>
To: Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Date: Thu, 5 Feb 2009 11:01:07 +0300
Subject: Re: [PATCH] x86: fix hpet timer reinit for x86_64
Thread-Topic: [PATCH] x86: fix hpet timer reinit for x86_64
Thread-Index: AcmG1TNNUgumlXiATbqPubaEwBGh2gAkrLio
Message-ID: <C5B07773.B781%dev@parallels.com>
In-Reply-To: <20090204134933.GC17024@elte.hu>
Accept-Language: en-US, ru-RU
Content-Language: en
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On 2/4/09 4:49 PM, "Ingo Molnar" <mingo@elte.hu> wrote:

> 
> 
> * Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> There's a small problem with hpet_rtc_reinit function - it checks
>> for the
>>       hpet_readl(HPET_COUNTER) - hpet_t1_cmp > 0
>> to continue increasing both the HPET_T1_CMP (register) and the
>> hpet_t1_cmp (variable).
>> 
>> But since the HPET_COUNTER is always 32-bit, if the hpet_t1_cmp
>> is 64-bit this condition will always be FALSE once the latter hits
>> the 32-bit boundary, and we can have a situation, when we don't
>> increase the HPET_T1_CMP register high enough.
>> 
>> The result - timer stops ticking, since HPET_T1_CMP becomes less,
>> than the COUNTER and never increased again.
>> 
>> The solution is to cut the upper 32-bit from the hpet_t1_cmp
>> variable to make the comparison to HPET_COUNTER correct.
>> 
>> Reported-by: Kirill Korotaev <dev@openvz.org>
>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> applied to tip/timers/urgent, thanks Pavel!
> 
> I'm wondering, what symptoms were seen due to the bug? Did system time stop,
> or did it become erratic, or were there outright lockups?

Symptoms were observed in user space. An application doing read() on
/dev/rtc blocked sometimes for a long periods of time (as turned out - until
counter gets wrap around).

Regards,
Kirill

