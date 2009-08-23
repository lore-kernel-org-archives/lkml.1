Return-Path: <linux-kernel-owner+w=401wt.eu-S934006AbZHWTna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbZHWTna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 15:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933952AbZHWTn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 15:43:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:65486 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933951AbZHWTn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 15:43:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RHpIGrii0Ay7LLYuYhrW+yWyu1hZm1yqU3r/cu8sR8NF/qYeR6ZvbJeWYmCVWSczb2
         CQ4wjKugYsbo4GQLTonD6wdnHr/VRy6fsm2v+jumVV2QzbZxb351yZytct5CzKEwyEyp
         GZm9ebl2HE7zTbnvRBVvD5k45BrI85u2J57H4=
Date: Sun, 23 Aug 2009 21:43:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH resend] vsprintf: use WARN_ON_ONCE
Message-ID: <20090823194327.GC6256@nowhere>
References: <4A918A64.9040201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A918A64.9040201@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 08:28:52PM +0200, Marcin Slusarz wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: vsprintf: use WARN_ON_ONCE
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>


Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>


> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 756ccaf..a63bb18 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -983,13 +983,8 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  
>  	/* Reject out-of-range values early.  Large positive sizes are
>  	   used for unknown buffer sizes. */
> -	if (unlikely((int) size < 0)) {
> -		/* There can be only one.. */
> -		static char warn = 1;
> -		WARN_ON(warn);
> -		warn = 0;
> +	if (WARN_ON_ONCE((int) size < 0))
>  		return 0;
> -	}
>  
>  	str = buf;
>  	end = buf + size;
> @@ -1439,13 +1434,8 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
>  
>  	struct printf_spec spec = {0};
>  
> -	if (unlikely((int) size < 0)) {
> -		/* There can be only one.. */
> -		static char warn = 1;
> -		WARN_ON(warn);
> -		warn = 0;
> +	if (WARN_ON_ONCE((int) size < 0))
>  		return 0;
> -	}
>  
>  	str = buf;
>  	end = buf + size;

