Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYLEIgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYLEIgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYLEIgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:36:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62720 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbYLEIgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:36:45 -0500
Message-ID: <4938E7C1.9040102@cn.fujitsu.com>
Date: Fri, 05 Dec 2008 16:35:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ken Chen <kenchen@google.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] export percpu cpuacct cgroup stats
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>	 <49376BE3.1040909@cn.fujitsu.com>	 <6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com>	 <b040c32a0812042344n75117b68x8de975d12dddf594@mail.gmail.com>	 <4938DE1C.6070608@cn.fujitsu.com> <b040c32a0812050030uff5ae65o417c599a792c800c@mail.gmail.com>
In-Reply-To: <b040c32a0812050030uff5ae65o417c599a792c800c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Chen wrote:
> On Thu, Dec 4, 2008 at 11:54 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>> +             seq_printf(m, "%llu ", percpu);
>> Should be:
>> +               seq_printf(m, "%llu ", (unsigned long long)percpu);
>>
>> Otherwsise:
>> kernel/sched.c: In function 'cpuacct_percpu_seq_read':
>> kernel/sched.c:9359: warning: format '%llu' expects type 'long long unsigned int',
>> but argument 3 has type 'u64'
> 
> huh, I was just wondering about the type case in cgroup_read_u64()
> when I was looking at it earlier.  That explains it.  Diff patch
> attached.
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> diff --git a/kernel/sched.c b/kernel/sched.c
> index e32c094..055c54f 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9356,7 +9356,7 @@ static int cpuacct_percpu_seq_read
>  		spin_lock_irq(&cpu_rq(i)->lock);
>  		percpu = *percpu_ptr(ca->cpuusage, i);
>  		spin_unlock_irq(&cpu_rq(i)->lock);
> -		seq_printf(m, "%llu ", percpu);
> +		seq_printf(m, "%llu ", (unsigned long long) percpu);
>  	}
>  	seq_printf(m, "\n");
>  	return 0;
> 
> 

