Return-Path: <linux-kernel-owner+w=401wt.eu-S1030500AbXBGJMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030500AbXBGJMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161047AbXBGJMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:12:22 -0500
Received: from mis011-2.exch011.intermedia.net ([64.78.21.129]:10860 "EHLO
	mis011-2.exch011.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030500AbXBGJMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:12:21 -0500
Message-ID: <45C997F1.9060102@qumranet.com>
Date: Wed, 07 Feb 2007 11:12:17 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] KVM, hotplug: export register_cpu_notifier
References: <20070207081633.GA6723@elte.hu>
In-Reply-To: <20070207081633.GA6723@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Feb 2007 09:12:20.0882 (UTC) FILETIME=[127A0720:01C74A98]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Subject: [patch] KVM, hotplug: export register_cpu_notifier
> From: Ingo Molnar <mingo@elte.hu>
>
> KVM-trunk uses register_cpu_notifier() but it's a module and we only 
> export this if CONFIG_HOTPLUG_CPU. Export it otherwise too.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/cpu.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux/kernel/cpu.c
> ===================================================================
> --- linux.orig/kernel/cpu.c
> +++ linux/kernel/cpu.c
> @@ -75,10 +75,10 @@ int __cpuinit register_cpu_notifier(stru
>  	return ret;
>  }
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> -
>  EXPORT_SYMBOL(register_cpu_notifier);
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +
>  void unregister_cpu_notifier(struct notifier_block *nb)
>  {
>  	mutex_lock(&cpu_add_remove_lock);
>   

This is broken: register_cpu_notifier() is __cpuinit, which means it 
disappears at module time if !CONFIG_CPU_HOTPLUG.

I submitted a hackaround to Andrew some time ago with the suspend patchset.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

