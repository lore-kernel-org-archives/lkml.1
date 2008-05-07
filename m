Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbYEGVf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbYEGVf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYEGVfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:35:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbYEGVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:35:42 -0400
Date: Wed, 7 May 2008 14:35:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH 1/5] Fix cpumask_scnprintf_len() misdesign
Message-Id: <20080507143537.94d744c5.akpm@linux-foundation.org>
In-Reply-To: <20080507221450.GA14375@martell.zuzino.mipt.ru>
References: <20080507221450.GA14375@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008 02:14:50 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> cpumask_scnprintf_len() takes "len" as an argument which is surprising,
> If one follows call chain down it isn't length but number of bits. But
> there is natural number of bits when talking about CPU masks -- NR_CPUS.
> So use that.

hm, maybe we should delete this function after all ;)

> Remove 1:1 wrapper macro while I'm at it.

There was a reason most of those 1:1 wrappers but yes, this one seems to be
rather cargo-cultish.

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  include/linux/cpumask.h |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -289,11 +289,9 @@ static inline int __cpumask_scnprintf(char *buf, int len,
>  	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
>  }
>  
> -#define cpumask_scnprintf_len(len) \
> -			__cpumask_scnprintf_len((len))
> -static inline int __cpumask_scnprintf_len(int len)
> +static inline int cpumask_scnprintf_len(void)
>  {
> -	return bitmap_scnprintf_len(len);
> +	return bitmap_scnprintf_len(NR_CPUS);
>  }
>  
>  #define cpumask_parse_user(ubuf, ulen, dst) \

Does Paul have an opinion?

(Well, Paul always has an opinion.  But what is it?)
