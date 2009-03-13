Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbZCMFqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbZCMFqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZCMFqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:46:31 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49447 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZCMFqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:46:30 -0400
Message-ID: <49B9F32E.9020003@us.ibm.com>
Date: Thu, 12 Mar 2009 22:46:22 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/futexes] futex: additional (get|put)_futex_key() fixes
References: <20090312075545.9856.75152.stgit@Aeon> <tip-de87fcc124a5d4a171aa32707b3265608ebda6e7@git.kernel.org> <20090313002000.GA11780@elte.hu>
In-Reply-To: <20090313002000.GA11780@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Darren Hart <dvhltc@us.ibm.com> wrote:
> 
>> @@ -1595,13 +1601,12 @@ uaddr_faulted:
>>  
>>  	ret = get_user(uval, uaddr);
>>  	if (!ret)
>> -		goto retry;
>> +		goto retry_unlocked;
>>  
>> -	if (to)
>> -		destroy_hrtimer_on_stack(&to->timer);
>> -	return ret;
>> +	goto out_put_key;
> 
> hm, was that destroy_hrtimer_on_stack() removal intended? It's 
> not directly commented on in the changelog.

Yes, rather than duplicate the cleanup logic, I replaced it with the 
"goto out_put_key;", which also drops the futex_key, which was missing 
in the original exit path.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
