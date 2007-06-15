Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbXFOTEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbXFOTEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbXFOTDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:03:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:4097 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbXFOTDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Ki8CdMAdesS1m9pNx7aDPFQsgM6JqtmqjzqqSP1f8xzvwL7TsyEsQNy/OWFlo4ycWYWGOjO+kKm/Lnh1+JLfdeh5xV6uBjYEj18g5XF3Gvtud5yB6sU/Pxr7DvcgnkYhJIAPEYsAF2nTkkJHh2hud5pC8j4bkSszlyDteMk2SAs=
Message-ID: <4672E295.2010208@googlemail.com>
Date: Fri, 15 Jun 2007 21:03:49 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070525)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Miguel_Bot=F3n?= <mboton@gmail.com>
CC: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [patch] CFS scheduler, -v17
References: <20070614224908.GA9412@elte.hu> <20070615132841.5ee01f4d@localhost> <200706151947.14266.mboton@gmail.com>
In-Reply-To: <200706151947.14266.mboton@gmail.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Botón wrote:
> On Friday 15 June 2007 18:28, Luiz Fernando N. Capitulino wrote:
>   
>>  Hmm, I'm getting this while compiling:
>>
>> """
>>   LD      .tmp_vmlinux1
>> kernel/built-in.o: In function `rq_clock':
>> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321:
>> undefined reference to `cpu_of'
>> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321:
>> undefined reference to `cpu_of'
>> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321:
>> undefined reference to `cpu_of'
>> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321:
>> undefined reference to `cpu_of'
>> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321:
>> undefined reference to `cpu_of'
>> kernel/built-in.o:/home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kern
>> el/sched.c:321: more undefined references to `cpu_of' follow make: ***
>> [.tmp_vmlinux1] Error 1
>> """
>>
>>  The code in question is really strange:
>>
>> #ifdef CONFIG_SMP
>> ...
>> static inline int cpu_of(struct rq *rq)
>> #ifdef CONFIG_SMP
>> 	return rq->cpu;
>> #else
>> 	return 0;
>> #endif
>> }
>> ...
>> #endif
>>     
>
> I patched kernel 2.6.21.5 with CFS v17 and I didn't experience this problem (I 
> checked that piece of code and I didn't see something wrong).
> Looks like it only appears in kernel 2.6.22-rc4.
>
>   
I guess this code is missing  #ifdef CONFIG_SMP ?

....

static inline unsigned long long rq_clock(struct rq *rq)
{
	int this_cpu = smp_processor_id();

	if (this_cpu == cpu_of(rq))
		return __rq_clock(rq);

	return rq->clock;
}


 ....

Gabriel
