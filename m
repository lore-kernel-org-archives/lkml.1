Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYIZK4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYIZK4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYIZK43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:56:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYIZK42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:56:28 -0400
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to
	include/linux/
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, nico@cam.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
References: <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 12:56:19 +0200
Message-Id: <1222426580.16700.258.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 17:48 +0100, David Howells wrote:
> Move asm-arm/cnt32_to_63.h to include/linux/ so that MN10300 can make use of it
> too.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  arch/arm/mach-pxa/time.c       |    2 +
>  arch/arm/mach-sa1100/generic.c |    2 +
>  arch/arm/mach-versatile/core.c |    2 +
>  include/linux/cnt32_to_63.h    |   80 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 83 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/cnt32_to_63.h

Didn't you forget to remove the old one?


> +#define cnt32_to_63(cnt_lo) \
> +({ \
> +	static volatile u32 __m_cnt_hi; \
> +	union cnt32_to_63 __x; \
> +	__x.hi = __m_cnt_hi; \
> +	__x.lo = (cnt_lo); \
> +	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
> +		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
> +	__x.val; \
> +})
> +
> +#endif

That code is way to smart :-)

Better make sure that non of its users are SMP capable though.


