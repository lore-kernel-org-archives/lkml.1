Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbXEXXCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbXEXXCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXEXXCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:02:16 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbXEXXCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:02:15 -0400
Date: Thu, 24 May 2007 16:02:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smpboot: cachesize comparison fix in
 smp_tune_scheduling()
Message-Id: <20070524160207.51a478cd.akpm@linux-foundation.org>
In-Reply-To: <20070524103322.GA1920@ff.dom.local>
References: <20070524103322.GA1920@ff.dom.local>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 12:33:23 +0200
Jarek Poplawski <jarkao2@o2.pl> wrote:

> 
> smpboot: cachesize comparison fix in smp_tune_scheduling()
> 
> boot_cpu_data.x86_cache_size is signed int and can be < 0 too.
> 
> PS: this function is removed from current -mm.
> 
> 
> Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
> 
> ---
> 
> diff -Nurp 2.6.22-rc2-git5-/arch/i386/kernel/smpboot.c 2.6.22-rc2-git5/arch/i386/kernel/smpboot.c
> --- 2.6.22-rc2-git5-/arch/i386/kernel/smpboot.c	2007-05-24 09:37:11.000000000 +0200
> +++ 2.6.22-rc2-git5/arch/i386/kernel/smpboot.c	2007-05-24 11:48:03.000000000 +0200
> @@ -948,7 +948,7 @@ static void smp_tune_scheduling(void)
>  	if (cpu_khz) {
>  		cachesize = boot_cpu_data.x86_cache_size;
>  
> -		if (cachesize > 0)
> +		if ((long)cachesize > 0)
>  			max_cache_size = cachesize * 1024;
>  	}
>  }

Under what conditions can boot_cpu_data.x86_cache_size be negative?

Have negative values of boot_cpu_data.x86_cache_size been observed in
practice?

Thanks.
