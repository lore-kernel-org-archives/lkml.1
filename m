Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZEVTAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZEVTAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZEVTAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:00:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38723 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbZEVTAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:00:23 -0400
Message-ID: <4A16F62B.40207@zytor.com>
Date: Fri, 22 May 2009 11:59:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Michael S. Zick" <lkml@morethan.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org> <20090522183622.GA8385@elte.hu>
In-Reply-To: <20090522183622.GA8385@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Michael S. Zick <lkml@morethan.org> wrote:
> 
>> Found in the bit-rot for 32-bit, x86, Uni-processor builds:
>>
>> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
>> index f6aa18e..3c790ef 100644
>> --- a/arch/x86/include/asm/alternative.h
>> +++ b/arch/x86/include/asm/alternative.h
>> @@ -35,7 +35,7 @@
>>                 "661:\n\tlock; "
>>
>>  #else /* ! CONFIG_SMP */
>> -#define LOCK_PREFIX ""
>> +#define LOCK_PREFIX "\n\tlock; "
>>  #endif
> 
> What is your motivation for this change? At first sight this makes 
> the UP kernel a bit larger and a bit smaller. Are you fixing some 
> real regression/bug here?
> 

That looks very odd indeed.  The whole point of the LOCK_PREFIX macro is
to squelch it on UP (locks that should not be squelched on UP should not
be annotated LOCK_PREFIX.)

	-hpa

