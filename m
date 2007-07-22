Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbXGVBpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbXGVBpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 21:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbXGVBo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 21:44:58 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:57162 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXGVBo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 21:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fbr6F5Yjo/lJoKCZPL0rq1K9bVOoHqAv6Ug0L11xPTf+ejbkZLM+dY133qzevWyOh+7jcib0H3zvp+cP25ArDd76eCTz1+XWZnWt1YRzgP++G19hrPMtxOkn1uSp8UlMhVq97RmBqZlD6DBzW9NLXi/g8PHZmCMqxQ6dpE2AKVw=
Message-ID: <a781481a0707211844s40e203c4t51250ff421d8781d@mail.gmail.com>
Date: Sun, 22 Jul 2007 07:14:56 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH][24/37] Clean up duplicate includes in kernel/
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rickard Faith" <faith@redhat.com>,
       "Eric Biederman" <ebiederm@xmission.com>, kexec@lists.infradead.org,
       "David Woodhouse" <dwmw2@infradead.org>, linux-audit@redhat.com,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "Manfred Spraul" <manfred@colorfullife.com>,
       "Paul McKenney" <paulmck@us.ibm.com>,
       "Josh Triplett" <josh@freedesktop.org>,
       "Stephen Tweedie" <sct@redhat.com>,
       "Shailabh Nagar" <nagar@watson.ibm.com>,
       "john stultz" <johnstul@us.ibm.com>,
       "Christoph Lameter" <clameter@engr.sgi.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200707211703.30346.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707211703.30346.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> Hi,
>
> This patch cleans up duplicate includes in
>         kernel/
>
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Reviewed-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[ Jesper, I hope you re-built with all these changes? Some
of these duplicate #include's could have been hiding deeper
header-include-ordering problems, and we'd want to know
about that too. Otherwise looks fairly obvious, thanks. ]

> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 145cbb7..5f7dba2 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -45,7 +45,6 @@
>  #include <linux/init.h>
>  #include <asm/types.h>
>  #include <asm/atomic.h>
> -#include <asm/types.h>
>  #include <linux/fs.h>
>  #include <linux/namei.h>
>  #include <linux/mm.h>

Ack

> diff --git a/kernel/exit.c b/kernel/exit.c
> index 464c2b1..9eef513 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -45,7 +45,6 @@
>  #include <linux/resource.h>
>  #include <linux/blkdev.h>
>  #include <linux/task_io_accounting_ops.h>
> -#include <linux/freezer.h>
>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>

Ack

> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 25db14b..d8de12e 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -17,7 +17,6 @@
>  #include <linux/highmem.h>
>  #include <linux/syscalls.h>
>  #include <linux/reboot.h>
> -#include <linux/syscalls.h>
>  #include <linux/ioport.h>
>  #include <linux/hardirq.h>
>  #include <linux/elf.h>

Ack

> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index 2c2dd84..5d9e07e 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -45,7 +45,6 @@
>  #include <linux/moduleparam.h>
>  #include <linux/percpu.h>
>  #include <linux/notifier.h>
> -#include <linux/rcupdate.h>
>  #include <linux/cpu.h>
>  #include <linux/mutex.h>

Ack

> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index ddff332..dd413bf 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -35,7 +35,6 @@
>  #include <linux/sched.h>
>  #include <asm/atomic.h>
>  #include <linux/bitops.h>
> -#include <linux/module.h>
>  #include <linux/completion.h>
>  #include <linux/moduleparam.h>
>  #include <linux/percpu.h>

Ack

> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 2222998..e0b2456 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -27,7 +27,6 @@
>  #include <linux/capability.h>
>  #include <linux/ctype.h>
>  #include <linux/utsname.h>
> -#include <linux/capability.h>
>  #include <linux/smp_lock.h>
>  #include <linux/fs.h>
>  #include <linux/init.h>

Ack

> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index 059431e..7d4d7f9 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -20,7 +20,6 @@
>  #include <linux/taskstats_kern.h>
>  #include <linux/tsacct_kern.h>
>  #include <linux/delayacct.h>
> -#include <linux/tsacct_kern.h>
>  #include <linux/cpumask.h>
>  #include <linux/percpu.h>
>  #include <net/genetlink.h>

Ack

> diff --git a/kernel/time.c b/kernel/time.c
> index 5b81da0..6304942 100644
> --- a/kernel/time.c
> +++ b/kernel/time.c
> @@ -34,7 +34,6 @@
>  #include <linux/syscalls.h>
>  #include <linux/security.h>
>  #include <linux/fs.h>
> -#include <linux/module.h>
>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>

Ack
