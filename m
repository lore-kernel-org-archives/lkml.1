Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYJQP4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYJQP4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbYJQPzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:55:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758118AbYJQPzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:55:40 -0400
Date: Fri, 17 Oct 2008 08:54:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
In-Reply-To: <1224220339.7654.84.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0810170852010.3438@nehalem.linux-foundation.org>
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>  <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>  <20081016.210404.151891223.davem@davemloft.net>  <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
 <1224220339.7654.84.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Oct 2008, Benjamin Herrenschmidt wrote:
>
> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
> +#define MEM_RSRC_SIZE	16
> +#else
> +#define MEM_RSRC_SIZE	8
> +#endif
> +
> +#ifdef CONFIG_X86
> +#define IO_RSRC_SIZE	4
> +#elif CONFIG_PPC
> +#define IO_RSRC_SIZE	8
> +#else
> +#define IO_RSRC_SIZE	MEM_RSRC_SIZE
> +#endif

Why?

Do you think alpha wants to see its PIO resources shown as

	[00000000000001f0-00000000000001f7]

or

	[01f0-01f7]

and which do you think is more readable?

And even on sparc, with the full 64 bits in use, it's not like we'd be 
*truncating* to 4 hex digits with %04x.

		Linus
