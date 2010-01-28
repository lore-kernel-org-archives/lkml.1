Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745Ab0A1IzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0A1IzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 03:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390Ab0A1IzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 03:55:03 -0500
Received: from smtp-out.google.com ([216.239.33.17]:8910 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0A1IzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 03:55:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=t2zkGzSUBT81OjoQiOdeztWXbCoEanu9x2bWwTiHQ3H76NgAKHpVQVwBsaoUCIE7v
	qYXM6yI5nCYQx/rUqQAdg==
Date: Thu, 28 Jan 2010 00:54:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, minchan.kim@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/2] sysctl clean up vm related variable
 declarations
In-Reply-To: <20100127153232.f8efc531.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1001280048110.15953@chino.kir.corp.google.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com> <20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com> <20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com> <20100126151202.75bd9347.akpm@linux-foundation.org>
 <20100127085355.f5306e78.kamezawa.hiroyu@jp.fujitsu.com> <20100126161952.ee267d1c.akpm@linux-foundation.org> <20100127095812.d7493a8f.kamezawa.hiroyu@jp.fujitsu.com> <20100127153053.b8a8a1a1.kamezawa.hiroyu@jp.fujitsu.com>
 <20100127153232.f8efc531.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010, KAMEZAWA Hiroyuki wrote:

> Now, there are many "extern" declaration in kernel/sysctl.c. "extern"
> declaration in *.c file is not appreciated in general.
> And Hmm...it seems there are a few redundant declarations.
> 

sysctl_overcommit_memory and sysctl_overcommit_ratio, right?

> Because most of sysctl variables are defined in its own header file,
> they should be declared in the same style, be done in its own *.h file.
> 
> This patch removes some VM(memory management) related sysctl's
> variable declaration from kernel/sysctl.c and move them to
> proper places.
> 
> Change log:
>  - 2010/01/27 (new)
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This is a very nice cleanup of the sysctl code, I hope you find the time 
to push it regardless of the future direction of the oom killer lowmem 
constraint.

One comment below.

> ---
>  include/linux/mm.h     |    5 +++++
>  include/linux/mmzone.h |    1 +
>  include/linux/oom.h    |    5 +++++
>  kernel/sysctl.c        |   16 ++--------------
>  mm/mmap.c              |    5 +++++
>  5 files changed, 18 insertions(+), 14 deletions(-)
> 
> Index: mmotm-2.6.33-Jan15-2/include/linux/mm.h
> ===================================================================
> --- mmotm-2.6.33-Jan15-2.orig/include/linux/mm.h
> +++ mmotm-2.6.33-Jan15-2/include/linux/mm.h
> @@ -1432,6 +1432,7 @@ int in_gate_area_no_task(unsigned long a
>  #define in_gate_area(task, addr) ({(void)task; in_gate_area_no_task(addr);})
>  #endif	/* __HAVE_ARCH_GATE_AREA */
>  
> +extern int sysctl_drop_caches;
>  int drop_caches_sysctl_handler(struct ctl_table *, int,
>  					void __user *, size_t *, loff_t *);
>  unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
> @@ -1476,5 +1477,9 @@ extern int soft_offline_page(struct page
>  
>  extern void dump_page(struct page *page);
>  
> +#ifndef CONFIG_NOMMU
> +extern int sysctl_nr_trim_pages;

This should be #ifndef CONFIG_MMU.

> +#endif
> +
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_MM_H */
