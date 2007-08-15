Return-Path: <linux-kernel-owner+w=401wt.eu-S1760424AbXHNX2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760424AbXHNX2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933729AbXHNX0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:26:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:50883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765924AbXHNX0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:26:32 -0400
Date: Wed, 15 Aug 2007 02:20:35 +0200
From: Andi Kleen <ak@suse.de>
To: Sebastian Siewior <sebastian@breakpoint.cc>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 1/2] i386: use asm() like the other atomic operations already do.
Message-ID: <20070815002034.GW3406@bingen.suse.de>
References: <20070814223845.518697567@breakpoint.cc> <20070814224337.547449183@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814224337.547449183@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> My config with march=pentium-m and gcc (GCC) 4.1.2 (Gentoo 4.1.2):
>   text    data     bss     dec     hex filename
> 3434150  249176  176128 3859454  3ae3fe atomic_normal/vmlinux
> 3435308  249176  176128 3860612  3ae884 atomic_inlineasm/vmlinux

What is the difference between atomic_normal and atomic_inlineasm? 

>  /**
>   * atomic_read - read atomic variable
>   * @v: pointer of type atomic_t
> - * 
> + *

Please don't change white space in patches

>   * Atomically reads the value of @v.
> - */ 
> -#define atomic_read(v)		((v)->counter)
> + */
> +static __inline__ int atomic_read(const atomic_t *v)
> +{
> +	int t;
> +
> +	__asm__ __volatile__(

And don't use __*__ in new code

-Andi
