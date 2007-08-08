Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbXHHK1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbXHHK1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbXHHK1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:27:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:50210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbXHHK06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:26:58 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 2/2] x86_64: ticket lock spinlock
Date: Wed, 8 Aug 2007 12:26:55 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070808042234.GE11018@wotan.suse.de> <20070808042444.GF11018@wotan.suse.de>
In-Reply-To: <20070808042444.GF11018@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081226.55651.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>   *
>   * (the type definitions are in asm/spinlock_types.h)
>   */
>  
> +#if (NR_CPUS > 256)
> +#error spinlock supports a maximum of 256 CPUs
> +#endif
> +
>  static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
>  {
> -	return *(volatile signed int *)(&(lock)->slock) <= 0;
> +	int tmp = *(volatile signed int *)(&(lock)->slock);

Why is slock not volatile signed int in the first place? 

> -	int oldval;
> +	short tmp;
> +        short oldval;

Broken white space?


-Andi
