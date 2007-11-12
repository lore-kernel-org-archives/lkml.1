Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbXKLWNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbXKLWNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbXKLWM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:12:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755281AbXKLWMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:12:55 -0500
Date: Mon, 12 Nov 2007 14:12:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Diego Calleja <diegocg@gmail.com>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improve cgroup printks
Message-Id: <20071112141245.1d9de09a.akpm@linux-foundation.org>
In-Reply-To: <20071110121156.a547194e.diegocg@gmail.com>
References: <20071110121156.a547194e.diegocg@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007 12:11:56 +0100 Diego Calleja <diegocg@gmail.com> wrote:

> When I boot with the 'quiet' parameter, I see on the screen:
> 
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [   39.036026] Initializing cgroup subsys cpuacct
> [   39.036080] Initializing cgroup subsys debug
> [   39.036118] Initializing cgroup subsys ns
> 
> This patch lowers the priority of those messages, adds a "cgroup: " prefix
> to another couple of printks and kills the useless reference to the source file.
> 
> 
> Signed-off-by: Diego Calleja <diegocg@gmail.com>
> 
> --- 2.6/kernel/cgroup.c.old	2007-11-10 11:35:51.000000000 +0100
> +++ 2.6/kernel/cgroup.c	2007-11-10 11:56:46.000000000 +0100
> @@ -1,6 +1,4 @@
>  /*
> - *  kernel/cgroup.c
> - *
>   *  Generic process-grouping system.
>   *
>   *  Based originally on the cpuset system, extracted by Paul Menage
> @@ -2200,7 +2198,7 @@ static void cgroup_init_subsys(struct cg
>  {
>  	struct cgroup_subsys_state *css;
>  	struct list_head *l;
> -	printk(KERN_ERR "Initializing cgroup subsys %s\n", ss->name);
> +	printk("Initializing cgroup subsys %s\n", ss->name);

But this one now has no facility level at all.

I'll switch it to KERN_INFO, OK?
