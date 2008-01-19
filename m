Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYASV0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYASV0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYASVZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:25:43 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49506 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYASVZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:25:42 -0500
Date: Sat, 19 Jan 2008 22:25:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, dipankar@in.ibm.com,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] rcu: fix section mismatch
Message-ID: <20080119212549.GD29070@uranus.ravnborg.org>
References: <20080119115643.43236e70.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119115643.43236e70.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 11:56:43AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> rcu_online_cpu() should be __cpuinit instead of __devinit.
> 
> WARNING: vmlinux.o(.text+0x4b6d5): Section mismatch: reference to .init.text: (between 'rcu_cpu_notify' and 'wakeme_after_rcu')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

So if we have:
CONFIG_HOTPLUG=n
CONFIG_HOTPLUG_CPU=y

then this is a oops candidate.

Andrew - this looks like a 2.6.24 candidate.

	Sam


> ---
>  kernel/rcupdate.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.24-rc8-git2.orig/kernel/rcupdate.c
> +++ linux-2.6.24-rc8-git2/kernel/rcupdate.c
> @@ -549,7 +549,7 @@ static void rcu_init_percpu_data(int cpu
>  	rdp->blimit = blimit;
>  }
>  
> -static void __devinit rcu_online_cpu(int cpu)
> +static void __cpuinit rcu_online_cpu(int cpu)
>  {
>  	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
>  	struct rcu_data *bh_rdp = &per_cpu(rcu_bh_data, cpu);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
