Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbZJOJ3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbZJOJ3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZJOJ3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:29:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZJOJ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:29:21 -0400
Message-ID: <4AD6EB08.9070303@kernel.org>
Date: Thu, 15 Oct 2009 18:27:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mingo@redhat.com,
       tglx@linutronix.de, akpm@linux-foundation.org, rostedt@goodmis.org,
       hpa@zytor.com, cebbert@redhat.com
Subject: Re: [PATCH 14/16] percpu: make access macros universal
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-15-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141037210.26476@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910141037210.26476@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 09:27:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 14 Oct 2009, Tejun Heo wrote:
> 
>> @@ -182,17 +185,19 @@ static inline void *pcpu_lpage_remapped(void *kaddr)
>>  #ifndef percpu_read
>>  # define percpu_read(var)						\
>>    ({									\
>> -	typeof(var) __tmp_var__;					\
>> -	__tmp_var__ = get_cpu_var(var);					\
>> -	put_cpu_var(var);						\
>> -	__tmp_var__;							\
>> +	typeof(var) *pr_ptr__ = &(var);					\
>> +	typeof(var) pr_ret__;						\
>> +	pr_ret__ = get_cpu_var(*pr_ptr__);				\
>> +	put_cpu_var(*pr_ptr__);						\
>> +	pr_ret__;							\
>>    })
>>  #endif
> 
> == this_cpu_read(var) ?

Yeah, all these extra and duplicate accessors need to go away.  Once
dust around this patchset settles down.  That's the next thing to do.

Thanks.

-- 
tejun
