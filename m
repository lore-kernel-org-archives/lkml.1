Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbYHAMdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbYHAMdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 08:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYHAMdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 08:33:46 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:17351 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYHAMdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 08:33:45 -0400
Message-ID: <4893025D.9090801@fr.ibm.com>
Date: Fri, 01 Aug 2008 14:32:29 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nigel Cunningham <ncunningham@crca.org.au>
CC: Matt Helsley <matthltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@suse.cz>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/6] Container Freezer: Add TIF_FREEZE flag to all architectures
References: <20080801050659.924495279@us.ibm.com> <20080801050700.261080433@us.ibm.com> <1217586735.27551.22.camel@nigel-laptop>
In-Reply-To: <1217586735.27551.22.camel@nigel-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
> Hi.
> 
> On Thu, 2008-07-31 at 22:07 -0700, Matt Helsley wrote:
>> This patch is the first step in making the refrigerator() available
>> to all architectures, even for those without power management.
>>
>> The purpose of such a change is to be able to use the refrigerator()
>> in a new control group subsystem which will implement a control group
>> freezer.
> 
> Is there a reason for always using 19, rather than just the next
> available bit?

At the time I did the patch, it was to be consistent with the other 
arches supporting suspend but this can not be true anymore. So we might
as well just use the next available bit as you suggest. 

Thanks,

C.

> Regards,
> 
> Nigel
> 
>> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
>> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
>> Acked-by: Pavel Machek <pavel@suse.cz>
>> Acked-by: Serge E. Hallyn <serue@us.ibm.com>
>> Tested-by: Matt Helsley <matthltc@us.ibm.com>
>> ---
>>  arch/parisc/include/asm/thread_info.h   |    2 ++
>>  arch/sparc/include/asm/thread_info_32.h |    2 ++
>>  arch/sparc/include/asm/thread_info_64.h |    2 ++
>>  include/asm-alpha/thread_info.h         |    2 ++
>>  include/asm-avr32/thread_info.h         |    1 +
>>  include/asm-cris/thread_info.h          |    2 ++
>>  include/asm-h8300/thread_info.h         |    2 ++
>>  include/asm-m68k/thread_info.h          |    1 +
>>  include/asm-m68knommu/thread_info.h     |    2 ++
>>  include/asm-s390/thread_info.h          |    2 ++
>>  include/asm-um/thread_info.h            |    2 ++
>>  include/asm-xtensa/thread_info.h        |    2 ++
>>  12 files changed, 22 insertions(+)
>>
>> Index: linux-2.6.27-rc1-mm1/arch/sparc/include/asm/thread_info_32.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/arch/sparc/include/asm/thread_info_32.h
>> +++ linux-2.6.27-rc1-mm1/arch/sparc/include/asm/thread_info_32.h
>> @@ -137,10 +137,11 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
>>  #define TIF_USEDFPU		8	/* FPU was used by this task
>>  					 * this quantum (SMP) */
>>  #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
>>  					 * TIF_NEED_RESCHED */
>>  #define TIF_MEMDIE		10
>> +#define TIF_FREEZE		19	/* is freezing for suspend */
>>  
>>  /* as above, but as bit values */
>>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>>  #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
>>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>> @@ -150,9 +151,10 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
>>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>>  
>>  #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
>>  					 _TIF_SIGPENDING | \
>>  					 _TIF_RESTORE_SIGMASK)
>> +#define TIF_FREEZE		(1<<TIF_FREEZE)
>>  
>>  #endif /* __KERNEL__ */
>>  
>>  #endif /* _ASM_THREAD_INFO_H */
>> Index: linux-2.6.27-rc1-mm1/arch/sparc/include/asm/thread_info_64.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/arch/sparc/include/asm/thread_info_64.h
>> +++ linux-2.6.27-rc1-mm1/arch/sparc/include/asm/thread_info_64.h
>> @@ -235,10 +235,11 @@ register struct thread_info *current_thr
>>   *       an immediate value in instructions such as andcc.
>>   */
>>  #define TIF_ABI_PENDING		12
>>  #define TIF_MEMDIE		13
>>  #define TIF_POLLING_NRFLAG	14
>> +#define TIF_FREEZE		19	/* is freezing for suspend */
>>  
>>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>>  #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
>>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>> @@ -247,10 +248,11 @@ register struct thread_info *current_thr
>>  #define _TIF_32BIT		(1<<TIF_32BIT)
>>  #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
>>  #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
>>  #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
>>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>> +#define _TIF_FREEZE		(1<<TIF_FREEZE)
>>  
>>  #define _TIF_USER_WORK_MASK	((0xff << TI_FLAG_WSAVED_SHIFT) | \
>>  				 _TIF_DO_NOTIFY_RESUME_MASK | \
>>  				 _TIF_NEED_RESCHED | _TIF_PERFCTR)
>>  #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING)
>> Index: linux-2.6.27-rc1-mm1/include/asm-alpha/thread_info.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/include/asm-alpha/thread_info.h
>> +++ linux-2.6.27-rc1-mm1/include/asm-alpha/thread_info.h
>> @@ -72,16 +72,18 @@ register struct thread_info *__current_t
>>  #define TIF_UAC_NOPRINT		5	/* see sysinfo.h */
>>  #define TIF_UAC_NOFIX		6
>>  #define TIF_UAC_SIGBUS		7
>>  #define TIF_MEMDIE		8
>>  #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
>> +#define TIF_FREEZE		19	/* is freezing for suspend */
>>  
>>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
>> +#define _TIF_FREEZE		(1<<TIF_FREEZE)
>>  
>>  /* Work to do on interrupt/exception return.  */
>>  #define _TIF_WORK_MASK		(_TIF_SIGPENDING | _TIF_NEED_RESCHED)
>>  
>>  /* Work to do on any return to userspace.  */
>> Index: linux-2.6.27-rc1-mm1/include/asm-avr32/thread_info.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/include/asm-avr32/thread_info.h
>> +++ linux-2.6.27-rc1-mm1/include/asm-avr32/thread_info.h
>> @@ -94,10 +94,11 @@ static inline struct thread_info *curren
>>  #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
>>  #define _TIF_SINGLE_STEP	(1 << TIF_SINGLE_STEP)
>>  #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
>>  #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
>>  #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
>> +#define _TIF_FREEZE		(1 << TIF_FREEZE)
>>  
>>  /* Note: The masks below must never span more than 16 bits! */
>>  
>>  /* work to do on interrupt/exception return */
>>  #define _TIF_WORK_MASK				\
>> Index: linux-2.6.27-rc1-mm1/include/asm-cris/thread_info.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/include/asm-cris/thread_info.h
>> +++ linux-2.6.27-rc1-mm1/include/asm-cris/thread_info.h
>> @@ -86,17 +86,19 @@ struct thread_info {
>>  #define TIF_SIGPENDING		2	/* signal pending */
>>  #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
>>  #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
>>  #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
>>  #define TIF_MEMDIE		17
>> +#define TIF_FREEZE		19	/* is freezing for suspend */
>>  
>>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>>  #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
>>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
>>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>> +#define _TIF_FREEZE		(1<<TIF_FREEZE)
>>  
>>  #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
>>  #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
>>  
>>  #endif /* __KERNEL__ */
>> Index: linux-2.6.27-rc1-mm1/include/asm-h8300/thread_info.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/include/asm-h8300/thread_info.h
>> +++ linux-2.6.27-rc1-mm1/include/asm-h8300/thread_info.h
>> @@ -87,17 +87,19 @@ static inline struct thread_info *curren
>>  #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
>>  #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
>>  					   TIF_NEED_RESCHED */
>>  #define TIF_MEMDIE		4
>>  #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
>> +#define TIF_FREEZE		19	/* is freezing for suspend */
>>  
>>  /* as above, but as bit values */
>>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
>> +#define _TIF_FREEZE		(1<<TIF_FREEZE)
>>  
>>  #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
>>  
>>  #endif /* __KERNEL__ */
>>  
>> Index: linux-2.6.27-rc1-mm1/include/asm-m68k/thread_info.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/include/asm-m68k/thread_info.h
>> +++ linux-2.6.27-rc1-mm1/include/asm-m68k/thread_info.h
>> @@ -50,7 +50,8 @@ struct thread_info {
>>  #define TIF_SIGPENDING		6	/* signal pending */
>>  #define TIF_NEED_RESCHED	7	/* rescheduling necessary */
>>  #define TIF_DELAYED_TRACE	14	/* single step a syscall */
>>  #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
>>  #define TIF_MEMDIE		16
>> +#define TIF_FREEZE		19	/* thread is freezing for suspend */
>>  
>>  #endif	/* _ASM_M68K_THREAD_INFO_H */
>> Index: linux-2.6.27-rc1-mm1/include/asm-m68knommu/thread_info.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/include/asm-m68knommu/thread_info.h
>> +++ linux-2.6.27-rc1-mm1/include/asm-m68knommu/thread_info.h
>> @@ -82,16 +82,18 @@ static inline struct thread_info *curren
>>  #define TIF_SIGPENDING		1	/* signal pending */
>>  #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
>>  #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
>>  					   TIF_NEED_RESCHED */
>>  #define TIF_MEMDIE		4
>> +#define TIF_FREEZE		19	/* is freezing for suspend */
>>  
>>  /* as above, but as bit values */
>>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>> +#define _TIF_FREEZE		(1<<TIF_FREEZE)
>>  
>>  #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
>>  
>>  #endif /* __KERNEL__ */
>>  
>> Index: linux-2.6.27-rc1-mm1/include/asm-s390/thread_info.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/include/asm-s390/thread_info.h
>> +++ linux-2.6.27-rc1-mm1/include/asm-s390/thread_info.h
>> @@ -96,10 +96,11 @@ static inline struct thread_info *curren
>>  #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling 
>>  					   TIF_NEED_RESCHED */
>>  #define TIF_31BIT		18	/* 32bit process */ 
>>  #define TIF_MEMDIE		19
>>  #define TIF_RESTORE_SIGMASK	20	/* restore signal mask in do_signal() */
>> +#define TIF_FREEZE		21	/* thread is freezing for suspend */
>>  
>>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
>>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>> @@ -108,10 +109,11 @@ static inline struct thread_info *curren
>>  #define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
>>  #define _TIF_MCCK_PENDING	(1<<TIF_MCCK_PENDING)
>>  #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
>>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>>  #define _TIF_31BIT		(1<<TIF_31BIT)
>> +#define _TIF_FREEZE		(1<<TIF_FREEZE)
>>  
>>  #endif /* __KERNEL__ */
>>  
>>  #define PREEMPT_ACTIVE		0x4000000
>>  
>> Index: linux-2.6.27-rc1-mm1/include/asm-um/thread_info.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/include/asm-um/thread_info.h
>> +++ linux-2.6.27-rc1-mm1/include/asm-um/thread_info.h
>> @@ -67,15 +67,17 @@ static inline struct thread_info *curren
>>  					 */
>>  #define TIF_RESTART_BLOCK 	4
>>  #define TIF_MEMDIE	 	5
>>  #define TIF_SYSCALL_AUDIT	6
>>  #define TIF_RESTORE_SIGMASK	7
>> +#define TIF_FREEZE		19	/* is freezing for suspend */
>>  
>>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>>  #define _TIF_POLLING_NRFLAG     (1 << TIF_POLLING_NRFLAG)
>>  #define _TIF_MEMDIE		(1 << TIF_MEMDIE)
>>  #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
>>  #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
>> +#define _TIF_FREEZE		(1 << TIF_FREEZE)
>>  
>>  #endif
>> Index: linux-2.6.27-rc1-mm1/include/asm-xtensa/thread_info.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/include/asm-xtensa/thread_info.h
>> +++ linux-2.6.27-rc1-mm1/include/asm-xtensa/thread_info.h
>> @@ -132,18 +132,20 @@ static inline struct thread_info *curren
>>  #define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
>>  #define TIF_IRET		4	/* return with iret */
>>  #define TIF_MEMDIE		5
>>  #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
>>  #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
>> +#define TIF_FREEZE		19	/* is freezing for suspend */
>>  
>>  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
>>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
>>  #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
>>  #define _TIF_IRET		(1<<TIF_IRET)
>>  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
>>  #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
>> +#define _TIF_FREEZE		(1<<TIF_FREEZE)
>>  
>>  #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
>>  #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
>>  
>>  /*
>> Index: linux-2.6.27-rc1-mm1/arch/parisc/include/asm/thread_info.h
>> ===================================================================
>> --- linux-2.6.27-rc1-mm1.orig/arch/parisc/include/asm/thread_info.h
>> +++ linux-2.6.27-rc1-mm1/arch/parisc/include/asm/thread_info.h
>> @@ -56,17 +56,19 @@ struct thread_info {
>>  #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
>>  #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling TIF_NEED_RESCHED */
>>  #define TIF_32BIT               4       /* 32 bit binary */
>>  #define TIF_MEMDIE		5
>>  #define TIF_RESTORE_SIGMASK	6	/* restore saved signal mask */
>> +#define TIF_FREEZE		19	/* is freezing for suspend */
>>  
>>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>>  #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
>>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>>  #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
>>  #define _TIF_32BIT		(1 << TIF_32BIT)
>>  #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
>> +#define _TIF_FREEZE		(1 << TIF_FREEZE)
>>  
>>  #define _TIF_USER_WORK_MASK     (_TIF_SIGPENDING | \
>>                                   _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
>>  
>>  #endif /* __KERNEL__ */
>>
> 

