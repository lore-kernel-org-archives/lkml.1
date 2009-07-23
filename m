Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZGWJpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZGWJpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 05:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbZGWJpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 05:45:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43925 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZGWJpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 05:45:54 -0400
Message-ID: <4A6831AC.3080704@redhat.com>
Date: Thu, 23 Jul 2009 17:47:24 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, mingo@elte.hu,
       Chris Zankel <chris@zankel.net>
Subject: Re: [Patch 2/2] xtensa: use generic sys_pipe()
References: <20090722091051.6621.15184.sendpatchset@localhost.localdomain> <20090722091100.6621.80645.sendpatchset@localhost.localdomain> <20090722101032.GA2102@cmpxchg.org>
In-Reply-To: <20090722101032.GA2102@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> [CC Chris]
>
> On Wed, Jul 22, 2009 at 05:08:42AM -0400, Amerigo Wang wrote:
>   
>> As suggested by Al, we can use the generic sys_pipe() instead of xtensa_pipe()
>> for xtensa.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk> 
>> CC: Linus Torvalds <torvalds@linux-foundation.org>
>>     
>
> Reviewed-by: Johannes Weiner <jw@emlix.com>
>
>   

Thanks for your review.
>> ---
>> diff --git a/arch/xtensa/include/asm/syscall.h b/arch/xtensa/include/asm/syscall.h
>> index 05cebf8..76a1fb8 100644
>> --- a/arch/xtensa/include/asm/syscall.h
>> +++ b/arch/xtensa/include/asm/syscall.h
>> @@ -12,7 +12,6 @@ struct pt_regs;
>>  struct sigaction;
>>  asmlinkage long xtensa_execve(char*, char**, char**, struct pt_regs*);
>>  asmlinkage long xtensa_clone(unsigned long, unsigned long, struct pt_regs*);
>> -asmlinkage long xtensa_pipe(int __user *);
>>  asmlinkage long xtensa_mmap2(unsigned long, unsigned long, unsigned long,
>>      			     unsigned long, unsigned long, unsigned long);
>>  asmlinkage long xtensa_ptrace(long, long, long, long);
>> diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/unistd.h
>> index c092c8f..b6880c8 100644
>> --- a/arch/xtensa/include/asm/unistd.h
>> +++ b/arch/xtensa/include/asm/unistd.h
>> @@ -94,7 +94,7 @@ __SYSCALL( 35, sys_readlink, 3)
>>  #define __NR_mknod 				 36
>>  __SYSCALL( 36, sys_mknod, 3)
>>  #define __NR_pipe 				 37
>> -__SYSCALL( 37, xtensa_pipe, 1)
>> +__SYSCALL(37, sys_pipe, 1)
>>     
>
> It would have been nice to keep the spacing but that shouldn't be a
> show stopper..
>
>   

I did this, but checkpatch.pl complained about this... so I removed the
space. Do I need to update and resend the patch? :)

Thanks.

