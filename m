Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYIFROj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYIFROj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYIFROb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:14:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33156 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbYIFROa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:14:30 -0400
Date: Sat, 6 Sep 2008 19:13:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/cpu.c: Move the CPU_DYING notifiers
Message-ID: <20080906171345.GH4856@elte.hu>
References: <200808311809.m7VI9whf014532@mail.q-ag.de> <20080906164949.GB4856@elte.hu> <48C2B90C.8000205@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C2B90C.8000205@colorfullife.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Manfred Spraul <manfred@colorfullife.com> wrote:

> Ingo Molnar wrote:
>> * Manfred Spraul <manfred@colorfullife.com> wrote:
>>   
>>> -	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
>>> -				param->hcpu);
>>>  	/* Ensure this CPU doesn't handle any more interrupts. */
>>>  	err = __cpu_disable();
>>>  	if (err < 0)
>>>  		return err;
>>>  +	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
>>> +				param->hcpu);
>>>     
>>
>> hm, doesnt this break things like CPU cross-calls done in CPU_DYING  
>> callbacks?
>>   
>
> We are within stop_machine(). No other cpu is running. As fas as I can 
> see no cross-calls are possible.

ah, ok - my bad. I was confusing it with the much more common 
CPU_DOWN_PREPARE type of callbacks which do use various cross-CPU APIs.

applied to tip/sched/devel, thanks Manfred!

	Ingo
