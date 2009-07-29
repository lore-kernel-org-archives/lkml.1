Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbZG2X2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbZG2X2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 19:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZG2X2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 19:28:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754665AbZG2X2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 19:28:24 -0400
Date: Wed, 29 Jul 2009 16:27:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: mingo@elte.hu, jens.axboe@oracle.com, nickpiggin@yahoo.com.au,
       peterz@infradead.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 -mm] generic-ipi: fix hotplug_cfd()
Message-Id: <20090729162756.20a34174.akpm@linux-foundation.org>
In-Reply-To: <4A6FFFE9.5070204@cn.fujitsu.com>
References: <4A6983D8.8090805@cn.fujitsu.com>
	<4A6FFFE9.5070204@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 15:53:13 +0800
Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Use CONFIG_HOTPLUG_CPU, not CONFIG_CPU_HOTPLUG
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/smp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index bf9f18b..1b5fd2e 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -54,7 +54,7 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  			return NOTIFY_BAD;
>  		break;
>  
> -#ifdef CONFIG_CPU_HOTPLUG
> +#ifdef CONFIG_HOTPLUG_CPU
>  	case CPU_UP_CANCELED:
>  	case CPU_UP_CANCELED_FROZEN:
>  

Dammit, that mistake is easy to make.  We should have used #if from day
one, not #ifdef.  Oh well.

What's the impact of this bug?  Do we think the fix should be present
in 2.6.31?  2.6.30.x?

