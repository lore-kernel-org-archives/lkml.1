Return-Path: <linux-kernel-owner+w=401wt.eu-S965290AbXAYNHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290AbXAYNHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965298AbXAYNHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:07:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36631 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965290AbXAYNHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:07:53 -0500
Date: Thu, 25 Jan 2007 14:07:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] suspend debugging: simulate suspend-to-RAM
Message-ID: <20070125130729.GA23620@elf.ucw.cz>
References: <20070125113350.GA31068@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070125113350.GA31068@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Subject: [patch] suspend debugging: simulate suspend-to-RAM
> From: Ingo Molnar <mingo@elte.hu>
> 
> most resume bugs are due to the kernel hanging or crashing while trying 
> to resume a specific device. It is extremely hard to debug such hangs 
> because often when the hang happens there's no console available
> yet.

While the functionality is useful, no I do not think this should be
configured by sysctl or kernel parameter.

Perhaps right interface is "echo fake-mem > /sys/power/state"? 

								Pavel

> Index: linux/kernel/sysctl.c
> ===================================================================
> --- linux.orig/kernel/sysctl.c
> +++ linux/kernel/sysctl.c
> @@ -329,6 +329,14 @@ static ctl_table kern_table[] = {
>  		.proc_handler	= &proc_dointvec,
>  	},
>  	{
> +		.ctl_name	= CTL_UNNUMBERED,
> +		.procname	= "futex_performance_hack",
> +		.data		= &futex_performance_hack,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec,
> +	},
> +	{
>  		.ctl_name	= KERN_PANIC,
>  		.procname	= "prof_pid",
>  		.data		= &prof_pid,

Leftover hunk?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
