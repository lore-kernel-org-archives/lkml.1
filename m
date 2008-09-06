Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYIFRIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYIFRIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYIFRId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:08:33 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:60319 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYIFRId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:08:33 -0400
Message-ID: <48C2B90C.8000205@colorfullife.com>
Date: Sat, 06 Sep 2008 19:08:28 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/cpu.c: Move the CPU_DYING notifiers
References: <200808311809.m7VI9whf014532@mail.q-ag.de> <20080906164949.GB4856@elte.hu>
In-Reply-To: <20080906164949.GB4856@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Manfred Spraul <manfred@colorfullife.com> wrote:
>   
>> -	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
>> -				param->hcpu);
>>  	/* Ensure this CPU doesn't handle any more interrupts. */
>>  	err = __cpu_disable();
>>  	if (err < 0)
>>  		return err;
>>  
>> +	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
>> +				param->hcpu);
>>     
>
> hm, doesnt this break things like CPU cross-calls done in CPU_DYING 
> callbacks?
>   
We are within stop_machine(). No other cpu is running. As fas as I can 
see no cross-calls are possible.

Which scenario do you think about?

--
    Manfred
