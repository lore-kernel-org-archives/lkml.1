Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbYKFUDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbYKFUDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYKFUDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:03:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33345 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYKFUDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:03:34 -0500
Message-ID: <49134D8E.1070407@redhat.com>
Date: Thu, 06 Nov 2008 15:03:26 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: next-20081106: today's ftrace episode
References: <20081106173645.e7e79071.sfr@canb.auug.org.au> <20081106194432.GA17188@x200.localdomain>
In-Reply-To: <20081106194432.GA17188@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On m68k-amiga:
>
>   CC      arch/m68k/kernel/asm-offsets.s
> In file included from include/linux/fs.h:287,
>                  from include/linux/ftrace.h:5,		<===
>                  from include/linux/hardirq.h:7,
>                  from include2/asm/system.h:69,
>                  from include/linux/list.h:7,		<===
>                  from include/linux/preempt.h:11,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/seqlock.h:29,
>                  from include/linux/time.h:8,
>                  from include/linux/timex.h:57,
>                  from include/linux/sched.h:54,
>                  from arch/m68k/kernel/asm-offsets.c:12:
> include/linux/wait.h:37: error: field 'task_list' has incomplete type
> 	...
>
> commit 7e5e26a3d8ac4bcadb380073dc9604c07a9a6198 aka "trace: fix hardirq header for non ftrace archs"
>
>
>   
We only need to include the ftrace.h to declare the ftrace_nmi_enter and 
exit.

I could separate that out into its own "ftrace_irq.h" file, that 
hardirq.h can include. That should fix it.

basically all that would be needed in that file is this:

#ifdef CONFIG_DYNAMIC_FTRACE
    extern void ftrace_nmi_enter(void);
    extern void ftrace_nmi_exit(void);
#else
    static inline void ftrace_nmi_enter(void) { }
    static inline void ftrace_nmi_exit(void) { }
#endif /* CONFIG_DYNAMIC_FTRACE */

-- Steve


