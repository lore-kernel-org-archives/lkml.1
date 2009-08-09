Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZHIWSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZHIWSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 18:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZHIWSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 18:18:44 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55460 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZHIWSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 18:18:41 -0400
Message-ID: <4A7F4B38.1060100@us.ibm.com>
Date: Sun, 09 Aug 2009 15:18:32 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkacur@redhat.com, johnstul@us.ibm.com, peterz@infradead.org,
       dino@in.ibm.com, rostedt@goodmis.org, stable@kernel.org,
       tglx@linutronix.de
Subject: Re: [tip:core/urgent] futex: Update woken requeued futex_q lock_ptr
References: <4A7A016C.1090002@us.ibm.com> <tip-4047446de8fa83d8d5922e9448eb0cbb7ac3f475@git.kernel.org> <20090809205611.GA23276@elte.hu>
In-Reply-To: <20090809205611.GA23276@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * tip-bot for Darren Hart <dvhltc@us.ibm.com> wrote:
> 
>> @@ -1030,6 +1034,11 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
>>  	WARN_ON(!q->rt_waiter);
>>  	q->rt_waiter = NULL;
>>  
>> +	q->lock_ptr = &hb->lock;
>> +#ifdef CONFIG_DEBUG_PI_LIST
>> +	q->list.plist.slock = &hb->lock;
>> +#endif
>> +
>>  	wake_up_state(q->task, TASK_NORMAL);
>>  }
>>  
> 
> -tip testing found a build error with v2 of the patch:
> 
> kernel/futex.c: In function ‘requeue_pi_wake_futex’:
> kernel/futex.c:1039: error: ‘struct plist_head’ has no member named ‘slock’

Ingo,

I'm finding myself confused by the tip branches.  I was going to prepare 
you a "mainline" version of this patch, but tip/core-for-linus-2 doesn't 
have the original requeue_pi support in futex.c, while tag v2.6.31-rc5 
does have that support.

I'll prepare a patch against v2.6.31-rc5, but can you explain how you 
would prefer for people to send patches that are needed in both mainline 
and rt, but have slightly different implementations?

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
