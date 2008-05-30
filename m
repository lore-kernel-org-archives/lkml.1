Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbYE3Add@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbYE3Add (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 20:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbYE3AdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 20:33:23 -0400
Received: from simmts12.bellnexxia.net ([206.47.199.141]:49973 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067AbYE3AdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 20:33:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQAAKfjPkicIs9g/2dsb2JhbAAIixGkdQ
Message-ID: <483F4B50.2030400@gmail.com>
Date: Thu, 29 May 2008 21:33:20 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: mingo@elte.hu
CC: linux-kernel@vger.kernel.org
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


I was so excited about finally figuring out how to create and send a 
patch with git, that I forgot to mention that this was a warning seen in 
linux-next, next-20080529.

It was more an experiment in how to send git patches than to "get my 
name in the kernel history", with which most experienced developers seem 
to think us newbies are only concerned.  I keep hearing that testing 
trees and fixing warnings and small bugs is the preferred way to make it 
into development - so I'm giving it a try.

Let me know if there was anything wrong with this submission, or if it 
is too trivial to bother with.

-- 
Kevin Winchester
