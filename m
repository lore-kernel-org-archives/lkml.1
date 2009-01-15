Return-Path: <linux-kernel-owner+w=401wt.eu-S1763562AbZAOK1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763562AbZAOK1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763453AbZAOK1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:27:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:34179 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763442AbZAOK1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:27:32 -0500
Message-ID: <496F0F5E.3080404@kernel.org>
Date: Thu, 15 Jan 2009 19:26:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [patch] add optimized generic percpu accessors
References: <1231843097-18003-1-git-send-email-tj@kernel.org>	 <496C717F.70204@kernel.org>	 <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>	 <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com>	 <20090114093834.GA19799@elte.hu> <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com>
In-Reply-To: <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Jan 2009 10:26:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin wrote:
>> Index: linux/include/asm-generic/percpu.h
>> ===================================================================
>> --- linux.orig/include/asm-generic/percpu.h
>> +++ linux/include/asm-generic/percpu.h
>> @@ -80,4 +80,32 @@ extern void setup_per_cpu_areas(void);
>>  #define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
>>                                        __typeof__(type) per_cpu_var(name)
>>
>> +/*
>> + * Optional methods for optimized non-lvalue per-cpu variable access:
>> + */
>> +
>> +#ifndef percpu_read
>> +# define percpu_read(var)              __get_cpu_var(var)
>> +#endif
>> +
>> +#ifndef percpu_write
>> +# define percpu_write(var, val)                ({ __get_cpu_var(var) = (val); })
>> +#endif
>> +
>> +#ifndef percpu_add
>> +# define percpu_add(var, val)          ({ __get_cpu_var(var) += (val); })
>> +#endif
>> +
>> +#ifndef percpu_sub
>> +# define percpu_add(var, val)          ({ __get_cpu_var(var) += (val); })
> 
> this should be:
> 
> define percpu_sub(var, val)          ({ __get_cpu_var(var) -= (val); })

Thanks.  Will fold into the patch.

-- 
tejun
