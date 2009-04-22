Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZDVUq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZDVUq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZDVUqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:46:50 -0400
Received: from 1wt.eu ([62.212.114.60]:3530 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbZDVUqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:46:50 -0400
Date: Wed, 22 Apr 2009 22:46:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] __ffs64()
Message-ID: <20090422204633.GE570@1wt.eu>
References: <1240415192.29604.90.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240415192.29604.90.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Wed, Apr 22, 2009 at 04:46:32PM +0100, Steven Whitehouse wrote:
> Hi,
> 
> I'd like to add a new bitop, __ffs64() which I need in order to fix a
> bug in GFS2. The question is, where should it go?
> 
> On 64 bit arches, __ffs64() would be a synonym for __ffs(), but on 32
> bit arches it degenerates to a conditional plus a call to __ffs(). I'm
> assuming that there would not be a lot of point in optimising this
> operation on 32 bit arches even if such an instruction was available, so
> that I should do something like the below patch.
> 
> Does that seem reasonable, or should I give it a separate header file
> under asm-generic/bitops/ like some of the similar operations? It looks
> like I'd have to touch a lot of other files if I were to go that route,

While I have no reply to your questions above, I have one minor comment :

> +/**
> + * __ffs64 - find first set bit in a 64 bit word
> + * @word: The 64 bit word
> + *
> + * On 64 bit arches this is a synomyn for __ffs
> + */

IMHO you should remind here that the result is undefined when word==0
and the caller must check against it first.

> +static inline unsigned long __ffs64(u64 word)
> +{
> +#if BITS_PER_LONG == 32
> +	if (((u32)word) == 0UL)
> +		return __ffs((u32)(word >> 32)) + 32;
> +#elif BITS_PER_LONG != 64
> +#error BITS_PER_LONG not 32 or 64
> +#endif
> +	return __ffs((unsigned long)word);
> +}
> +
>  #ifdef __KERNEL__
>  #ifdef CONFIG_GENERIC_FIND_FIRST_BIT

Regards,
Willy

