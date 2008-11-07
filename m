Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYKGHUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYKGHUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYKGHUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:20:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49881 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYKGHUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:20:22 -0500
Message-ID: <4913EB8C.8010003@cn.fujitsu.com>
Date: Fri, 07 Nov 2008 15:17:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: rewrite SCHED_CPUMASK_ALLOC
References: <4911341C.7020207@cn.fujitsu.com> <20081106080057.GF8459@elte.hu>
In-Reply-To: <20081106080057.GF8459@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  #if	NR_CPUS > 128
>> -#define	SCHED_CPUMASK_ALLOC		1
>> -#define	SCHED_CPUMASK_FREE(v)		kfree(v)
>> -#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
>> +#define SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
>> +#define SCHED_CPUMASK_ALLOC(v)		v = kmalloc(sizeof(*v), GFP_KERNEL)
>> +#define SCHED_CPUMASK_FREE(v)		kfree(v)
>>  #else
>> -#define	SCHED_CPUMASK_ALLOC		0
>> -#define	SCHED_CPUMASK_FREE(v)
>> -#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
>> +#define SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
>> +#define SCHED_CPUMASK_ALLOC(v)
>> +#define SCHED_CPUMASK_FREE(v)
>>  #endif
> 
> ok, the #ifdef removal is nice, but we can make it even cleaner: 
> please just change it to a sched_cpumask_alloc() inline. That way 
> SCHED_CPUMASK_DECLARE() can go away as well: just declare the 
> variable, it will be unused in the <128 CPUs case.
> 

I don't catch you. :(

In the <128 CPUs case, SCHED_CPUMASK_DECLARE is needed to declare a local
variable(struct allmasks) and a pointer pointing to it. So I don't know
what you mean by 'unused' and how to remove the DECLARE macro..

