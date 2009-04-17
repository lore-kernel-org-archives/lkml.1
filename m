Return-Path: <linux-kernel-owner+w=401wt.eu-S1762260AbZDQXK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762260AbZDQXK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZDQXKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:10:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849AbZDQXKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:10:12 -0400
Date: Fri, 17 Apr 2009 16:02:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       benh@kernel.crashing.org, heiko.carstens@de.ibm.com, paulus@samba.org,
       tony.luck@intel.com, seto.hidetoshi@jp.fujitsu.com,
       jeremy@xensource.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH] /proc/stat idle field for idle cpus
Message-Id: <20090417160211.4fa36fb7.akpm@linux-foundation.org>
In-Reply-To: <20090414141851.3174f880@skybase>
References: <20090414141851.3174f880@skybase>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 14:18:51 +0200
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> --- linux-2.6.orig/fs/proc/stat.c
> +++ linux-2.6/fs/proc/stat.c
> @@ -18,6 +18,9 @@
>  #ifndef arch_irq_stat
>  #define arch_irq_stat() 0
>  #endif
> +#ifndef arch_idle_time
> +#define arch_idle_time(cpu) 0
> +#endif
>  
>  static int show_stat(struct seq_file *p, void *v)
>  {
> @@ -39,7 +42,8 @@ static int show_stat(struct seq_file *p,
>  		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
>  		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
>  		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
> -		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle);
> +		idle = cputime64_add(idle, kstat_cpu(i).cpustat.idle +
> +				     arch_idle_time(i));
>  		iowait = cputime64_add(iowait, kstat_cpu(i).cpustat.iowait);
>  		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
>  		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
> @@ -68,7 +72,7 @@ static int show_stat(struct seq_file *p,
>  		user = kstat_cpu(i).cpustat.user;
>  		nice = kstat_cpu(i).cpustat.nice;
>  		system = kstat_cpu(i).cpustat.system;
> -		idle = kstat_cpu(i).cpustat.idle;
> +		idle = kstat_cpu(i).cpustat.idle + arch_idle_time(i);
>  		iowait = kstat_cpu(i).cpustat.iowait;
>  		irq = kstat_cpu(i).cpustat.irq;
>  		softirq = kstat_cpu(i).cpustat.softirq;

Looks OK to me.  Please merge it via the s390 tree.

Do other architectures need to fix this?
