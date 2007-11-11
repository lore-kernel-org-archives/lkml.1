Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbXKKSa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbXKKSa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 13:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXKKSaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 13:30:12 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58579 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbXKKSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 13:30:10 -0500
Date: Sun, 11 Nov 2007 10:28:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] log2.h: Define order_base_2() macro for convenience.
Message-Id: <20071111102837.e934544d.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0711102249110.7449@localhost.localdomain>
References: <Pine.LNX.4.64.0711102249110.7449@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007 22:53:36 -0500 (EST) Robert P. J. Day wrote:

> 
> Given a number of places in the tree that need to calculate this value
> explicitly, might as well just create a macro for it.
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>   run-time tested for the first several values.  note that this macro
> is defined strictly in terms of rounding *up* -- i've seen no places
> in the tree that require this expression to be rounded down, so i'm
> not drawing that distinction.
> 
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index c8cf5e8..ed121c0 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -190,4 +190,20 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
>  	__rounddown_pow_of_two(n)		\
>   )
> 
> +/**
> + * order_base_2 - calculate the (rounded up) base 2 order of the argument
> + * @n - parameter

 * @n: argument

(mostly changing - to :)

> + *
> + * The first few values calculated by this routine:
> + *  ob2(0) = 0
> + *  ob2(1) = 0
> + *  ob2(2) = 1
> + *  ob2(3) = 2
> + *  ob2(4) = 2
> + *  ob2(5) = 3
> + *  ... and so on.
> + */
> +
> +#define order_base_2(n) ilog2(roundup_pow_of_two(n))
> +
>  #endif /* _LINUX_LOG2_H */
> 
> -- 

---
~Randy
