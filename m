Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbXIONdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbXIONdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 09:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbXIONdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 09:33:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:46705 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXIONdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 09:33:13 -0400
Subject: Re: 2.6.23-rc4-mm1 compile error for ppc 32
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070913151738.4462fdf2.akpm@linux-foundation.org>
References: <20070906184011.GA1776@Krystal>
	 <20070906160009.fa52e8d2.akpm@linux-foundation.org>
	 <200709081136.46605.nickpiggin@yahoo.com.au>
	 <1189269730.5972.163.camel@localhost.localdomain>
	 <20070913151738.4462fdf2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 15 Sep 2007 15:32:27 +0200
Message-Id: <1189863147.6403.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 15:17 -0700, Andrew Morton wrote:

> Like this?
> 
> --- a/include/asm-powerpc/bitops.h~powerpc-lock-bitops-fix
> +++ a/include/asm-powerpc/bitops.h
> @@ -226,7 +226,7 @@ static __inline__ void set_bits(unsigned
>  
>  static __inline__ void __clear_bit_unlock(int nr, volatile unsigned long *addr)
>  {
> -	__asm__ __volatile__(LWSYNC_ON_SMP ::: "memory");
> +	__asm__ __volatile__(LWSYNC_ON_SMP "" ::: "memory");
>  	__clear_bit(nr, addr);
>  }
>  

Looks ok. Can somebody test ? I'm still travelling...


