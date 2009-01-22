Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbZAVSF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbZAVSF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 13:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZAVSFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 13:05:47 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:38307 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890AbZAVSFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 13:05:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAN9DeElMQWt2/2dsb2JhbACBbclmhXM
Date: Thu, 22 Jan 2009 13:05:27 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] asm-generic: fix local_add_unless macro
Message-ID: <20090122180526.GA8354@Krystal>
References: <49787DB4.8080308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49787DB4.8080308@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:00:57 up 21 days, 17:59,  2 users,  load average: 0.91, 0.70,
	0.66
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roel Kluin (roel.kluin@gmail.com) wrote:
> When this macro isn't called with 'a' this will 
> result in a build failure.
> 

Can I have a look at the offending calling code and the build failure
output ? We might consider changing these for static inlines instead.
And clearly, just changing a single primitive is not going to work. We
need to address the other similar in the same file at the very least.

Mathieu


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
