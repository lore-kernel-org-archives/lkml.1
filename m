Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbYHZOI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbYHZOI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYHZOIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:08:20 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:58216 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYHZOIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:08:19 -0400
Message-ID: <48B40D5F.3020705@linux.vnet.ibm.com>
Date: Tue, 26 Aug 2008 16:04:15 +0200
From: Pierre Morel <pmorel@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC] [Patch 1/1] [Self Ptrace] System call notification with
 self_ptrace
References: <48B26083.8080506@linux.vnet.ibm.com> <20080825165403.GA604@tv-sign.ru>
In-Reply-To: <20080825165403.GA604@tv-sign.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

Oleg Nesterov wrote:
> On 08/25, Pierre Morel wrote:
>   
>> @@ -550,6 +550,23 @@ asmlinkage long sys_ptrace(long request,
>>  		goto out;
>>  	}
>>
>> +	if (request == PTRACE_SELF_ON) {
>> +		task_lock(current);
>> +		set_thread_flag(TIF_SYSCALL_TRACE);
>> +		current->ptrace |= PT_SELF;
>>     
>
> I didn't read the whole patch, but this sets PT_SELF without PT_PTRACED
> (and without ptrace_attach).
>   
Yes it is the way it is intended to work.
PT_SELF and other ptrace requests are not correlated,
I use the ptrace infrastructure to take advantage
of the existing system call interception framework.
> We have some "->ptrace != 0" checks which can misunderstand this. Just
> for example, suppose that the task does sys_ptrace(PTRACE_SELF_ON) and
> then its parent dies. I guess in that case forget_original_parent()
> will hit BUG_ON(p->ptrace), no?
>
>   
Yes you are right, I will take care of those cases.
I have the choice between:

- tracking all references to the ptrace flags and add a test for PT_SELF
or a mask.

- add a dedicated task_struct entry to hold the PT_SELF flag

The second solution seems easier, simpler and more
readable but extends the task struct.

What do you think is the best way to do it?

> Oleg.
>
>   
Thanks,

Pierre




-- 
=============
Pierre Morel
RTOS and Embedded Linux

