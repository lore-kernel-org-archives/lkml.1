Return-Path: <linux-kernel-owner+w=401wt.eu-S1763546AbZCXUTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763546AbZCXUTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbZCXUS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:18:58 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:43354 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755043AbZCXUS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:18:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMFAHPXyElMQW1W/2dsb2JhbACBUNFqg3YG
Date: Tue, 24 Mar 2009 16:18:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jody McIntyre <scjody@sun.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation / sample code fixes for tracepoints
Message-ID: <20090324201852.GB4350@Krystal>
References: <20090324200027.GH8294@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090324200027.GH8294@clouds>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:14:36 up 24 days, 16:40,  1 user,  load average: 0.93, 0.75,
	0.66
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jody McIntyre (scjody@sun.com) wrote:
> Fix the tracepoint documentation to refer to "tracepoint-sample" instead of
> "tracepoint-example" to match what actually exists; fix the directory,
> and clarify how to compile.
> 
> Change every instance of "example" in the sample tracepoint code to "sample"
> for consistency.
> 
> Signed-off-by: Jody McIntyre <scjody@sun.com>
> 

Yes, this documentation/samples fix is indeed needed. It should go
through Ingo's tracing tree, and then also be applied to the -stable
kernels. I have verified that the samples still build correctly.

Meanwhile, I'm pulling it in the -lttng tree.

Thanks !

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

P.S. : Ah, Sun is looking at the tracepoints ? ;-)

> Index: linux-2.6/Documentation/tracepoints.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/tracepoints.txt
> +++ linux-2.6/Documentation/tracepoints.txt
> @@ -103,13 +103,14 @@ used to export the defined tracepoints.
>  
>  * Probe / tracepoint example
>  
> -See the example provided in samples/tracepoints/src
> +See the example provided in samples/tracepoints
>  
> -Compile them with your kernel.
> +Compile them with your kernel.  They are built during 'make' (not
> +'make modules') when CONFIG_SAMPLE_TRACEPOINTS=m.
>  
>  Run, as root :
> -modprobe tracepoint-example (insmod order is not important)
> -modprobe tracepoint-probe-example
> -cat /proc/tracepoint-example (returns an expected error)
> -rmmod tracepoint-example tracepoint-probe-example
> +modprobe tracepoint-sample (insmod order is not important)
> +modprobe tracepoint-probe-sample
> +cat /proc/tracepoint-sample (returns an expected error)
> +rmmod tracepoint-sample tracepoint-probe-sample
>  dmesg
> Index: linux-2.6/samples/tracepoints/tracepoint-sample.c
> ===================================================================
> --- linux-2.6.orig/samples/tracepoints/tracepoint-sample.c
> +++ linux-2.6/samples/tracepoints/tracepoint-sample.c
> @@ -1,6 +1,6 @@
>  /* tracepoint-sample.c
>   *
> - * Executes a tracepoint when /proc/tracepoint-example is opened.
> + * Executes a tracepoint when /proc/tracepoint-sample is opened.
>   *
>   * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>   *
> @@ -16,7 +16,7 @@
>  DEFINE_TRACE(subsys_event);
>  DEFINE_TRACE(subsys_eventb);
>  
> -struct proc_dir_entry *pentry_example;
> +struct proc_dir_entry *pentry_sample;
>  
>  static int my_open(struct inode *inode, struct file *file)
>  {
> @@ -32,25 +32,25 @@ static struct file_operations mark_ops =
>  	.open = my_open,
>  };
>  
> -static int __init example_init(void)
> +static int __init sample_init(void)
>  {
> -	printk(KERN_ALERT "example init\n");
> -	pentry_example = proc_create("tracepoint-example", 0444, NULL,
> +	printk(KERN_ALERT "sample init\n");
> +	pentry_sample = proc_create("tracepoint-sample", 0444, NULL,
>  		&mark_ops);
> -	if (!pentry_example)
> +	if (!pentry_sample)
>  		return -EPERM;
>  	return 0;
>  }
>  
> -static void __exit example_exit(void)
> +static void __exit sample_exit(void)
>  {
> -	printk(KERN_ALERT "example exit\n");
> -	remove_proc_entry("tracepoint-example", NULL);
> +	printk(KERN_ALERT "sample exit\n");
> +	remove_proc_entry("tracepoint-sample", NULL);
>  }
>  
> -module_init(example_init)
> -module_exit(example_exit)
> +module_init(sample_init)
> +module_exit(sample_exit)
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Mathieu Desnoyers");
> -MODULE_DESCRIPTION("Tracepoint example");
> +MODULE_DESCRIPTION("Tracepoint sample");

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
