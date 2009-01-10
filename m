Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbZAJXEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbZAJXEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZAJXEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:04:02 -0500
Received: from relay2.sgi.com ([192.48.179.30]:36455 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747AbZAJXEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:04:00 -0500
Message-ID: <49692953.1020405@sgi.com>
Date: Sat, 10 Jan 2009 15:03:47 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] irq: allocate irq_desc_ptrs array based on nr_irqs
References: <20090110223818.459493000@polaris-admin.engr.sgi.com> <20090110223818.767801000@polaris-admin.engr.sgi.com> <20090110224755.GC17917@elte.hu>
In-Reply-To: <20090110224755.GC17917@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> +++ linux-2.6-for-ingo/kernel/irq/internals.h
>> @@ -16,7 +16,11 @@ extern int __irq_set_trigger(struct irq_
>>  extern struct lock_class_key irq_desc_lock_class;
>>  extern void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr);
>>  extern spinlock_t sparse_irq_lock;
>> +#ifdef CONFIG_SPARSE_IRQ
>> +extern struct irq_desc **irq_desc_ptrs;
>> +#else
>>  extern struct irq_desc *irq_desc_ptrs[NR_IRQS];
>> +#endif
> 
> why the #ifdef? irq_desc_ptrs is only defined and used by sparseirq.
> 
> 	Ingo

Hmm, good point.  I just modified as it was.

Should it only be:

	#ifdef CONFIG_SPARSE_IRQ
	extern struct irq_desc **irq_desc_ptrs;
	#endif

Or do we normally declare something even though it won't be defined anywhere?

Thanks,
Mike
