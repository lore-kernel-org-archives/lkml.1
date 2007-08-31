Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbXHaHiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbXHaHiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 03:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXHaHh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 03:37:57 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:19173 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbXHaHh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 03:37:56 -0400
Date: Fri, 31 Aug 2007 11:37:46 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Len Brown <lenb@kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix maxcpus=1 oops in show_stat()
Message-ID: <20070831073746.GA15151@localhost.sw.ru>
References: <20070828111431.GA27707@localhost.sw.ru> <Pine.LNX.4.64.0708290546430.31816@blonde.wat.veritas.com> <20070829052331.GB1765@martell.zuzino.mipt.ru> <200708290241.36092.lenb@kernel.org> <20070829072508.GA2707@localhost.sw.ru> <Pine.LNX.4.64.0708310404210.4873@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708310404210.4873@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 04:26:50AM +0100, Hugh Dickins wrote:
> --- 2.6.23-rc4/init/main.c
> +++ linux/init/main.c
> @@ -397,10 +397,6 @@ static void __init smp_init(void)
>  {
>  	unsigned int cpu;
>  
> -#ifndef CONFIG_HOTPLUG_CPU
> -	cpu_possible_map = cpu_present_map;
> -#endif
> -
>  	/* FIXME: This should be done in userspace --RR */
>  	for_each_present_cpu(cpu) {
>  		if (num_online_cpus() >= max_cpus)
> @@ -545,10 +541,6 @@ asmlinkage void __init start_kernel(void
>  	setup_arch(&command_line);
>  	setup_command_line(command_line);
>  	unwind_setup();
> -#ifndef CONFIG_HOTPLUG_CPU
> -	if (max_cpus < 2)
> -		cpu_possible_map = cpu_online_map;
> -#endif
>  	setup_per_cpu_areas();
>  	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
>  

Works here, I'll try on another box soon.

