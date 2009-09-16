Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbZIPMFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbZIPMFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 08:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbZIPMFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 08:05:32 -0400
Received: from centrinvest.ru ([94.25.115.130]:58448 "EHLO centrinvest.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622AbZIPMF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 08:05:29 -0400
From: "Andrey Panin" <pazke@centrinvest.ru>
Date: Wed, 16 Sep 2009 16:05:29 +0400
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCH] media: video: pwc: Use kernel's simple_strtol()
Message-ID: <20090916120529.GB18050@centrinvest.ru>
Mail-Followup-To: Andy Shevchenko <andy.shevchenko@gmail.com>,
	linux-kernel@vger.kernel.org,
	Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
References: <1253101347-25038-1-git-send-email-andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253101347-25038-1-git-send-email-andy.shevchenko@gmail.com>
X-Uname: Linux 2.6.26-1-amd64 x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Anti-Virus: kav4lms: continue
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 259, 09 16, 2009 at 02:42:27PM +0300, Andy Shevchenko wrote:
> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> 
> Change own implementation of atoi() by simple_strtol(x, NULL, 10).

Why did you keep the wrapper itself then ?


> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> ---
>  drivers/media/video/pwc/pwc-if.c |   13 +++----------
>  1 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
> index f976df4..cb995c6 100644
> --- a/drivers/media/video/pwc/pwc-if.c
> +++ b/drivers/media/video/pwc/pwc-if.c
> @@ -68,6 +68,7 @@
>  #endif
>  #include <linux/vmalloc.h>
>  #include <asm/io.h>
> +#include <linux/kernel.h>		/* simple_strtol() */
>  
>  #include "pwc.h"
>  #include "pwc-kiara.h"
> @@ -1916,17 +1917,9 @@ disconnect_out:
>  	unlock_kernel();
>  }
>  
> -/* *grunt* We have to do atoi ourselves :-( */
> -static int pwc_atoi(const char *s)
> +static inline int pwc_atoi(const char *s)
>  {
> -	int k = 0;
> -
> -	k = 0;
> -	while (*s != '\0' && *s >= '0' && *s <= '9') {
> -		k = 10 * k + (*s - '0');
> -		s++;
> -	}
> -	return k;
> +	return (int)simple_strtol(s, NULL, 10);
>  }
