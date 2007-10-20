Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbXJTAww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbXJTAww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 20:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbXJTAwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 20:52:43 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31373 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXJTAwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 20:52:43 -0400
Date: Fri, 19 Oct 2007 17:50:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Avuton Olrich" <avuton@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl:  Don't compile sysctl_check when !CONFIG_SYSCTL
Message-Id: <20071019175058.1f917007.randy.dunlap@oracle.com>
In-Reply-To: <m1bqaueirm.fsf_-_@ebiederm.dsl.xmission.com>
References: <3aa654a40710182127u529efe5flc01955f01b83b042@mail.gmail.com>
	<20071019170111.94219a4e.randy.dunlap@oracle.com>
	<m1bqaueirm.fsf_-_@ebiederm.dsl.xmission.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 18:23:25 -0600 Eric W. Biederman wrote:

> Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
> > On Thu, 18 Oct 2007 21:27:16 -0700 Avuton Olrich wrote:
> >
> >> Good Day,
> >> 
> >> My randconfig just caught an error on:
> >> kernel/built-in.o: In function `sysctl_check_lookup':
> >> sysctl_check.c:(.text+0x17db1): undefined reference to `sysctl_head_next'
> >> sysctl_check.c:(.text+0x17dc7): undefined reference to `sysctl_head_finish'
> >> 
> >> Git bisect was unsuccessful due to too many unrelated errors trying to
> >> track down the issue. I also couldn't track down the offending
> >> function. Any idea of the issue?
> >> 
> >> Against this config: http://avuton.googlepages.com/sysctl-head-next.config
> >> 
> >> git master: 4fa4d23fa20de67df919030c1216295664866ad7
> >
> > Eric,
> >
> > Please have a look at this one.
> >
> > .config file link is above.
> >
> > # CONFIG_SYSCTL_SYSCALL is not set
> > # CONFIG_PROC_SYSCTL is not set
> >
> 
> Weird I thought I had written the makefile so this would be handled.
> Oh well this should fix it.
> 
> Sorry about that.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  kernel/Makefile |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 05c3e6d..79f017e 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -9,8 +9,9 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
>  	    rcupdate.o extable.o params.o posix-timers.o \
>  	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
>  	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o \
> -	    utsname.o sysctl_check.o notifier.o
> +	    utsname.o notifier.o
>  
> +obj-$(CONFIG_SYSCTL) += sysctl_check.o
>  obj-$(CONFIG_STACKTRACE) += stacktrace.o
>  obj-y += time/
>  obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
> -- 

Acked-by: Randy Dunlap <randy.dunlap@oracle.com> # and tested-by:


---
~Randy
