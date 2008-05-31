Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbYEaAfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbYEaAfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbYEaAe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:34:57 -0400
Received: from simmts5-qfe0.srvr.bell.ca ([206.47.199.163]:60737 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757285AbYEaAez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:34:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0BAJ81QEicIpgi/2dsb2JhbAAIixGjcQ
Message-ID: <48409D2D.4020207@gmail.com>
Date: Fri, 30 May 2008 21:34:53 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH] x86: fix pointer type warning in arch/x86/mm/init_64.c:early_memtest
References: <1212106475-3297-1-git-send-email-kjwinchester@gmail.com>
In-Reply-To: <1212106475-3297-1-git-send-email-kjwinchester@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
> Changed the call to find_e820_area_size to pass u64 instead of unsigned long.
> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
>  arch/x86/mm/init_64.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 83ab7f9..94f73c2 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -515,7 +515,7 @@ early_param("memtest", parse_memtest);
>  
>  static void __init early_memtest(unsigned long start, unsigned long end)
>  {
> -	unsigned long t_start, t_size;
> +	u64 t_start, t_size;
>  	unsigned pattern;
>  
>  	if (!memtest_pattern)
> @@ -534,7 +534,7 @@ static void __init early_memtest(unsigned long start, unsigned long end)
>  			if (t_start + t_size > end)
>  				t_size = end - t_start;
>  
> -			printk(KERN_CONT "\n  %016lx - %016lx pattern %d",
> +			printk(KERN_CONT "\n  %016llx - %016llx pattern %d",
>  				t_start, t_start + t_size, pattern);
>  
>  			memtest(t_start, t_size, pattern);

I still see this warning on next-20080530 - so I expanded the CC list a 
little.  Did I do this patch right?

-- 
Kevin Winchester
