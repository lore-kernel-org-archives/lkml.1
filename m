Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbZC0MyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbZC0MyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbZC0Mxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:53:52 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:64715 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbZC0Mxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=akE4hAUDggL8aObFLe16myFzoy39RVDPbZwncuOqJG2qrWYlJ/+p8ygpLnpbQl0VO0
         Q6wYuNwCMFOedEE9xwJaAR81YDuLl+KVmk0UezK+bD7YRm2N0OfRhhVGn6Kf4ji40YR3
         Bdx1L1stdC08oi6DFZvLquIQ7r/lqlbbVylGA=
Date: Fri, 27 Mar 2009 13:53:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix wrong format string iter for printk
Message-ID: <20090327125345.GF5976@nowhere>
References: <49CC9739.30107@cn.fujitsu.com> <49CC97B6.7040809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC97B6.7040809@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 05:09:10PM +0800, Zhaolei wrote:
> printk("%Q");
> Output before patch:
> %QQ
> Output after patch:
> %Q
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  lib/vsprintf.c |   16 ----------------
>  1 files changed, 0 insertions(+), 16 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 908dd41..b56f6d0 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1062,13 +1062,6 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  			if (str < end)
>  				*str = '%';
>  			++str;
> -			if (*fmt) {
> -				if (str < end)
> -					*str = *fmt;
> -				++str;
> -			} else {
> -				--fmt;
> -			}
>  			break;
>  
>  		case FORMAT_TYPE_NRCHARS: {
> @@ -1356,8 +1349,6 @@ do {									\
>  			break;
>  
>  		case FORMAT_TYPE_INVALID:
> -			if (!*fmt)
> -				--fmt;
>  			break;
>  
>  		case FORMAT_TYPE_NRCHARS: {
> @@ -1544,13 +1535,6 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
>  			if (str < end)
>  				*str = '%';
>  			++str;
> -			if (*fmt) {
> -				if (str < end)
> -					*str = *fmt;
> -				++str;
> -			} else {
> -				--fmt;
> -			}
>  			break;
>  
>  		case FORMAT_TYPE_NRCHARS:
> -- 
> 1.5.5.3
> 
> 


Thanks for fixing this!

