Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZCLCGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZCLCGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZCLCGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:06:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:33734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZCLCGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:06:41 -0400
Message-ID: <49B86E29.6050108@kernel.org>
Date: Thu, 12 Mar 2009 11:06:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH 06/10] percpu: kill percpu_alloc() and friends
References: <1234958676-27618-1-git-send-email-tj@kernel.org>	 <1234958676-27618-7-git-send-email-tj@kernel.org> <12c511ca0903111136h3805a106i484a32fd2972c568@mail.gmail.com>
In-Reply-To: <12c511ca0903111136h3805a106i484a32fd2972c568@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 02:06:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> On Wed, Feb 18, 2009 at 5:04 AM, Tejun Heo <tj@kernel.org> wrote:
>> +static inline void *__alloc_percpu(size_t size, size_t align)
>>  {
>> +       /*
>> +        * Can't easily make larger alignment work with kmalloc.  WARN
>> +        * on it.  Larger alignment should only be used for module
>> +        * percpu sections on SMP for which this path isn't used.
>> +        */
>> +       WARN_ON_ONCE(align > __alignof__(unsigned long long));
>>        return kzalloc(size, gfp);
>>  }
> 
> This WARN_ON just pinged for me when I built & ran linux-next tag next-20090311
> 
> Stack trace from the WARN_ON pointed to __create_workqueue_key() which
> does:
> 
>          wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
> 
> and the cpu_workqueue_struct is defined as ____cacheline_aligned
> 
> I hit this on ia64, but all this code looks generic.

Yeap, it's fixed now, but as Rusty pointed out, once move to dynamic
percpu allocator is complete, we wouldn't need cacheline alignment for
percpu data structures.  It will only hurt performance by wasting
cachelines.

Thanks.

-- 
tejun
