Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbZAWPpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbZAWPpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZAWPph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:45:37 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:48350 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbZAWPpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:45:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0FALxweUlMQWt2/2dsb2JhbACBbcsJhXM
Date: Fri, 23 Jan 2009 10:45:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] asm-generic: fix local_add_unless macro
Message-ID: <20090123154520.GB7774@Krystal>
References: <49787DB4.8080308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49787DB4.8080308@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:42:07 up 22 days, 15:40,  2 users,  load average: 0.53, 0.69,
	0.61
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roel Kluin (roel.kluin@gmail.com) wrote:
> When this macro isn't called with 'a' this will 
> result in a build failure.
> 

Maybe we can add to the changelog, for prople like me who fail to see
the obvious :

"because local_add_unless(x, y, z) will be expanded to 
(&(x)->y, (y), (x)), where (x)->y should be (x)->a.

Thanks,

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
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
