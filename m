Return-Path: <linux-kernel-owner+w=401wt.eu-S932272AbYD1HIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbYD1HIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 03:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763374AbYD1HIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 03:08:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:20200 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765375AbYD1HIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 03:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r/BmyqtjWBd/LFUapPm4Lzv4mP/YAHGcFXNtcjjtMtB759OF/A5fIdZjsDVMtX31sV344YAAUN1gG/gGhrpW33DgUyyZyTH9viKvIl/zI7nUepD2/LaqHjtqoBSHMjkupwRsE4ZELUNKLeAdT41LrJPjQCgELTKQYqBuL1V81Ps=
Message-ID: <a8e1da0804280008s38d3b16vfedb3860cd7d5222@mail.gmail.com>
Date: Mon, 28 Apr 2008 15:08:36 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: dpn@isomerica.net
Subject: Re: NULL dereference OOPS on SysRq-w
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <48157664.2060302@isomerica.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48141EFA.6080700@isomerica.net>
	 <20080428065736.GA2714@darkstar.te-china.tietoenator.com>
	 <48157664.2060302@isomerica.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 3:01 PM, Dan Noe <dpn@isomerica.net> wrote:
> Dave Young wrote:
>
> > [snip]
> >
> > I have a fix for the NULL pointer reference BUG, tested on my pc.
> > ---
> >
> > "m" will be NULL if seq_printf & seq_puts is called from sched_debug_show
> > Use SEQ_* macros to fix it
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> >
>
>  There is actually already a patch out for this which simply hasn't made it
> upstream yet - Mike Galbraith emailed me with it and it indeed fixes the
> problem.  I hadn't realized his email didn't go to lkml.. otherwise I would
> have echoed that here to avoid wasting people's time.  My apologies.

Ok, thanks.

While debuging this issue I found another BUG about sysrq,

echo w >/proc/sys/kernel/sysrq
My system hangs, there's no response from then on.

>
>  Cheers,
>  Dan
>
>  ===
>
>  Here is his message:
>
>  From: efault@gmx.de
>
>  Peter's fix didn't make it up-stream.
>
>  Subject: sched: fix oops
>
>  sched_debug uses SEQ_printf to use printk when the seqfile 'm' is NULL.
>  Instead of doing that here too; choose to not output the weight tree
>  to cut back on output.
>
>  Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>  ---
>  diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>  index 89fa32b..353a481 100644
>  --- a/kernel/sched_fair.c
>  +++ b/kernel/sched_fair.c
>  @@ -1643,8 +1643,10 @@ static void print_cfs_stats(struct seq_file *m, int
> cpu)
>
>         for_each_leaf_cfs_rq(cpu_rq(cpu), cfs_rq)
>                 print_cfs_rq(m, cpu, cfs_rq);
>
>  -       seq_printf(m, "\nWeight tree:\n");
>  -       print_cfs_rq_tasks(m, &cpu_rq(cpu)->cfs, 1);
>  +       if (m) {
>  +               seq_printf(m, "\nWeight tree:\n");
>
>  +               print_cfs_rq_tasks(m, &cpu_rq(cpu)->cfs, 1);
>  +       }
>         rcu_read_unlock();
>   }
>   #endif
>
>
>
>
>  --
>                     /--------------- - -  -  -   -   -
>                     |  Dan Noe
>                     |  http://isomerica.net/~dpn/
>
