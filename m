Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZEDB1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZEDB1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 21:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZEDB1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 21:27:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50787 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZEDB1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 21:27:33 -0400
Message-ID: <49FE44BA.7080409@cn.fujitsu.com>
Date: Mon, 04 May 2009 09:28:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroups: make messages more readable
References: <49F76CC4.8050200@oracle.com>
In-Reply-To: <49F76CC4.8050200@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the delayed reply)

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix some cgroup messages to read better.
> Update MAINTAINERS to include mm/*cgroup* files.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  MAINTAINERS      |    1 +
>  mm/page_cgroup.c |   14 +++++++-------
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> --- lnx-2630-rc3.orig/mm/page_cgroup.c
> +++ lnx-2630-rc3/mm/page_cgroup.c
> @@ -83,12 +83,12 @@ void __init page_cgroup_init(void)
>  			goto fail;
>  	}
>  	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
> -	printk(KERN_INFO "please try cgroup_disable=memory option if you"
> -	" don't want\n");
> +	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you"
> +	" don't want memory cgroups\n");
>  	return;
>  fail:
> -	printk(KERN_CRIT "allocation of page_cgroup was failed.\n");
> -	printk(KERN_CRIT "please try cgroup_disable=memory boot option\n");
> +	printk(KERN_CRIT "allocation of page_cgroup failed.\n");
> +	printk(KERN_CRIT "please try 'cgroup_disable=memory' boot option\n");
>  	panic("Out of memory");
>  }
>  
> @@ -257,14 +257,14 @@ void __init page_cgroup_init(void)
>  		fail = init_section_page_cgroup(pfn);
>  	}
>  	if (fail) {
> -		printk(KERN_CRIT "try cgroup_disable=memory boot option\n");
> +		printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
>  		panic("Out of memory");
>  	} else {
>  		hotplug_memory_notifier(page_cgroup_callback, 0);
>  	}
>  	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
> -	printk(KERN_INFO "please try cgroup_disable=memory option if you don't"
> -	" want\n");
> +	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you don't"
> +	" want memory cgroups\n");
>  }
>  
>  void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
> --- lnx-2630-rc3.orig/MAINTAINERS
> +++ lnx-2630-rc3/MAINTAINERS
> @@ -1519,6 +1519,7 @@ L:	containers@lists.linux-foundation.org
>  S:	Maintained
>  F:	include/linux/cgroup*
>  F:	kernel/cgroup*

May be we should fix it like this:

F: include/linux/cgroup.h
F: kernel/cgroup.c
F: kernel/cgroup_debug.c

?

Since the authors of kernel/cgroup_freezer.c are Matt Helsley <matthltc@us.ibm.com>
and Cedric Le Goater <clg@fr.ibm.com>.

And the author of net/sched/cls_cgroup.c is Thomas Graf <tgraf@suug.ch>,

And the maintainer of kernel/ns_cgroup.c and security/device_cgroup.c is
Serge E. Hallyn <serue@us.ibm.com>.

> +F:	mm/*cgroup*
>  

And this belongs to memory resource controller (grep 'MEMORY RESOURCE CONTROLLER'
in MAINTAINERS). The maintainers of mm/page_cgroup.c and mm/memcontrol.c are
Balbir and Kamezawa.

>  CORETEMP HARDWARE MONITORING DRIVER
>  P:	Rudolf Marek
> 
> 

