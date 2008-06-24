Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbYFXUiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbYFXUiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 16:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYFXUiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 16:38:13 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49788 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYFXUiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 16:38:12 -0400
Subject: Re: [PATCH] Documentation: add descs for guest fields in stat
	procfs files
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: AP <ap@zip.com.au>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Christian Borntraeger <borntraeger@de.ibm.com>, trivial@kernel.org
In-Reply-To: <20080624124306.GK2896@zip.com.au>
References: <485DFFB4.3080008@gmail.com>
	 <1214210925.3838.7.camel@frecb07144>
	 <cfd18e0f0806230351nd9eb54ei5e87734291ced9be@mail.gmail.com>
	 <20080624124306.GK2896@zip.com.au>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Tue, 24 Jun 2008 22:38:05 +0200
Message-Id: <1214339885.3826.1.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 juin 2008 à 22:43 +1000, AP a écrit :
> Git patch 5e84cfde51cf303d368fcb48f22059f37b3872de introduced a new
> field to /proc/stat that represents guest (virtual cpu) time.
> 
> Git patch 9ac52315d4cf5f561f36dabaf0720c00d3553162 introduced the same
> to /proc/<pid>/stat along with a guest time of the tasks children.
> 
> The patch below adds descriptions of these fields to the procfs
> documentation included in the kernel.
> 
> Signed-Off-By: Andrew P <ap@zip.com.au>

It looks good to me.

Laurent

> diff -aur linux-2.6.26-rc7-git2.orig/Documentation/filesystems/proc.txt linux-2.6.26-rc7-git2/Documentation/filesystems/proc.txt
> --- linux-2.6.26-rc7-git2.orig/Documentation/filesystems/proc.txt	2008-06-23 22:27:13.000000000 +1000
> +++ linux-2.6.26-rc7-git2/Documentation/filesystems/proc.txt	2008-06-24 22:16:53.000000000 +1000
> @@ -210,9 +210,9 @@
>    cmin_flt      number of minor faults with child's
>    maj_flt       number of major faults
>    cmaj_flt      number of major faults with child's
> -  utime         user mode jiffies
> +  utime         user mode jiffies (including gtime below*)
>    stime         kernel mode jiffies
> -  cutime        user mode jiffies with child's
> +  cutime        user mode jiffies with child's (including cgtime below*)
>    cstime        kernel mode jiffies with child's
>    priority      priority level
>    nice          nice level
> @@ -239,6 +239,11 @@
>    rt_priority   realtime priority
>    policy        scheduling policy (man sched_setscheduler)
>    blkio_ticks   time spent waiting for block IO
> +  gtime         guest (virtual CPU) CPU time in jiffies
> +  cgtime        guests' children's CPU time in jiffies
> +
> +* gtime and cgtime are included in these values so that applications that are
> +  not aware of these fields do not lose time in their calculations.
>  ..............................................................................
>  
> 
> @@ -828,9 +833,9 @@
>  since the system first booted.  For a quick look, simply cat the file:
>  
>    > cat /proc/stat
> -  cpu  2255 34 2290 22625563 6290 127 456 0
> -  cpu0 1132 34 1441 11311718 3675 127 438 0
> -  cpu1 1123 0 849 11313845 2614 0 18 0
> +  cpu  2255 34 2290 22625563 6290 127 456 0 0
> +  cpu0 1132 34 1441 11311718 3675 127 438 0 0
> +  cpu1 1123 0 849 11313845 2614 0 18 0 0
>    intr 114930548 113199788 3 0 5 263 0 4 [... lots more numbers ...]
>    ctxt 1990473
>    btime 1062191376
> @@ -843,7 +848,8 @@
>  different kinds of work.  Time units are in USER_HZ (typically hundredths of a
>  second).  The meanings of the columns are as follows, from left to right:
>  
> -- user: normal processes executing in user mode
> +- user: normal processes executing in user mode (includes guest time below so
> +        that guest-unaware applications do not lose time)
>  - nice: niced processes executing in user mode
>  - system: processes executing in kernel mode
>  - idle: twiddling thumbs
> @@ -851,6 +857,7 @@
>  - irq: servicing interrupts
>  - softirq: servicing softirqs
>  - steal: involuntary wait
> +- guest: time used to run a virtual CPU
>  
>  The "intr" line gives counts of interrupts  serviced since boot time, for each
>  of the  possible system interrupts.   The first  column  is the  total of  all
> 
-- 
------------- Laurent.Vivier@bull.net ---------------
"The best way to predict the future is to invent it."
- Alan Kay

