Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZELVrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZELVrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZELVrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:47:15 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:55485 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbZELVrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:47:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0FAMmGCUpMQW1W/2dsb2JhbACBUM0VhAIF
Date: Tue, 12 May 2009 17:47:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] asm-generic: fix local_add_unless macro
Message-ID: <20090512214714.GA27519@Krystal>
References: <49787DB4.8080308@gmail.com> <20090123154520.GB7774@Krystal> <4A09EAC9.2030104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A09EAC9.2030104@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:46:35 up 73 days, 18:12,  7 users,  load average: 0.93, 0.63,
	0.45
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roel Kluin (roel.kluin@gmail.com) wrote:
> ------------------------------>8-------------8<---------------------------------
> `local_add_unless(x, y, z)' will be expanded to `(&(x)->y, (y), (x))', but 
> `&(x)->y' should be `&(x)->a'
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

It looks good to me.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
> Was this patch lost? it's still not in current git.
> 
> diff --git a/include/asm-generic/local.h b/include/asm-generic/local.h
> index dbd6150..fc21844 100644
> --- a/include/asm-generic/local.h
> +++ b/include/asm-generic/local.h
> @@ -42,7 +42,7 @@ typedef struct
>  
>  #define local_cmpxchg(l, o, n) atomic_long_cmpxchg((&(l)->a), (o), (n))
>  #define local_xchg(l, n) atomic_long_xchg((&(l)->a), (n))
> -#define local_add_unless(l, a, u) atomic_long_add_unless((&(l)->a), (a), (u))
> +#define local_add_unless(l, _a, u) atomic_long_add_unless((&(l)->a), (_a), (u))
>  #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
>  
>  /* Non-atomic variants, ie. preemption disabled and won't be touched

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
