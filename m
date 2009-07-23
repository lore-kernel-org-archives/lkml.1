Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbZGWVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbZGWVsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZGWVsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:48:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598AbZGWVsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:48:21 -0400
Date: Thu, 23 Jul 2009 14:47:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel.h: Verify that arguments to swap() are the same
 type
Message-Id: <20090723144738.440f6102.akpm@linux-foundation.org>
In-Reply-To: <1247708061.15087.13.camel@Joe-Laptop.home>
References: <1247708061.15087.13.camel@Joe-Laptop.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 18:34:21 -0700
Joe Perches <joe@perches.com> wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d6320a3..72878a5 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -637,8 +637,13 @@ static inline void ftrace_dump(void) { }
>  /*
>   * swap - swap value of @a and @b
>   */
> -#define swap(a, b) \
> -	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
> +#define swap(a, b)				\
> +do {						\
> +	typeof(a) __tmp = (a);			\
> +	BUILD_BUG_ON(!__same_type(__tmp, (b)));	\
> +	(a) = (b);				\
> +	(b) = __tmp;				\
> +} while (0)
>  

I wonder if we can do

	typecheck(a, typeof(b));

