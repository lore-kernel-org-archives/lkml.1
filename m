Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYJJKaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYJJKaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYJJK3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:29:54 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:64404 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYJJK3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:29:54 -0400
Message-ID: <48EF2D5F.5010701@cs.columbia.edu>
Date: Fri, 10 Oct 2008 06:24:31 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: jeremy@goop.org, arnd@arndb.de, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v6][PATCH 3/9] x86 support for checkpoint/restart
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu> <1223461197-11513-4-git-send-email-orenl@cs.columbia.edu> <48EF2CB3.9040900@fr.ibm.com>
In-Reply-To: <48EF2CB3.9040900@fr.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Cedric Le Goater wrote:
>> +int cr_read_cpu_fpu(struct cr_hdr_cpu *hh, struct task_struct *t)
>> +{
>> +	struct thread_struct *thread = &t->thread;
>> +
>> +	/* i387 + MMU + SSE */
>> +
>> +	preempt_disable();
>> +
>> +	__clear_fpu(t);		/* in case we used FPU in user mode */
>> +
>> +	if (!hh->used_math)
>> +		clear_used_math();
>> +	else {
>> +		if (hh->has_fxsr != cpu_has_fxsr) {
>> +			force_sig(SIGFPE, t);
>> +			return -EINVAL;
>> +		}
> 
> don't you need an init_fpu() around here ? because the task you restart might 
> not have used FPU yet.
> 
>> +		memcpy(&thread->xstate, &hh->xstate, sizeof(thread->xstate));
> 
> also i'd used 'xstate_size' instead of sizeof(thread->xstate)
> 

Yes, that was broken, and already fixed in for next round.

Thanks,

Oren.

> 
> thanks,
> 
> C.
