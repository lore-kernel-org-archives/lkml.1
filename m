Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZCJBxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZCJBxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZCJBxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:53:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45709 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZCJBxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:53:39 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] memdup_user: introduce, fix
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Roland Dreier <rdreier@cisco.com>, LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <49B5C69F.3010409@cn.fujitsu.com>
References: <49B5C69F.3010409@cn.fujitsu.com>
Message-Id: <20090310105258.A483.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 10 Mar 2009 10:53:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   * Include machine specific inline routines
> diff --git a/mm/util.c b/mm/util.c
> index 3d21c21..7c122e4 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -74,15 +74,19 @@ EXPORT_SYMBOL(kmemdup);
>   *
>   * @src: source address in user space
>   * @len: number of bytes to copy
> - * @gfp: GFP mask to use
>   *
>   * Returns an ERR_PTR() on failure.
>   */
> -void *memdup_user(const void __user *src, size_t len, gfp_t gfp)
> +void *memdup_user(const void __user *src, size_t len)
>  {
>  	void *p;
>  
> -	p = kmalloc_track_caller(len, gfp);
> +	/*
> +	 * Always use GFP_KERNEL, since copy_from_user() can sleep and
> +	 * cause pagefault, which makes it pointless to use GFP_NOFS
> +	 * or GFP_ATOMIC.
> +	 */
> +	p = kmalloc_track_caller(len, GFP_KERNEL);
>  	if (!p)
>  		return ERR_PTR(-ENOMEM);

ok. thanks.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



