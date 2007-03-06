Return-Path: <linux-kernel-owner+w=401wt.eu-S965992AbXCFSmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965992AbXCFSmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966022AbXCFSl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:41:57 -0500
Received: from terminus.zytor.com ([192.83.249.54]:59564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966009AbXCFSlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:41:42 -0500
Message-ID: <45EDB568.1090008@zytor.com>
Date: Tue, 06 Mar 2007 10:39:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@osdl.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order() [try #2]
References: <20070306183426.10768.51800.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070306183426.10768.51800.stgit@warthog.cambridge.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
>  
>  /**
> + * ilog2_up - rounded up log of base 2 of 32-bit or a 64-bit unsigned value
> + * @n - parameter
> + *
> + * constant-capable log of base 2 calculation
> + * - this can be used to initialise global variables from constant data, hence
> + *   the massive ternary operator construction
> + * - the result is rounded up
> + * - the result is undefined when n < 1
> + *
> + * selects the appropriately-sized optimised version depending on sizeof(n)
> + */
> +#define ilog2_up(n) ((n) == 1 ? 0 : ilog2((n) - 1) + 1)
> +

Why not just make it ((n) < 1 ? 0 : ...) and make it well-defined for
n == 0?

> +/**
>   * roundup_pow_of_two - round the given value up to nearest power of two
>   * @n - parameter
>   *
> @@ -159,8 +175,8 @@ unsigned long __roundup_pow_of_two(unsigned long n)
>  #define roundup_pow_of_two(n)			\
>  (						\
>  	__builtin_constant_p(n) ? (		\
> -		(n == 1) ? 0 :			\
> -		(1UL << (ilog2((n) - 1) + 1))	\
> +		(n == 1) ? 1 :			\
> +		(1UL << ilog2_up(n))		\
>  				   ) :		\

... then this can be just "1UL << ilog2_up(n)".

[Sorry about previous email.  I got confused about what 
roundup_pow_of_two() actually does.]

	-hpa
