Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZDNJXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZDNJXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZDNJXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:23:09 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:36632 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbZDNJXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:23:07 -0400
Date: Tue, 14 Apr 2009 11:23:03 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] lockdep: warn about lockdep disabling after kernel
 taint, fix
Message-ID: <20090414112303.22f7b2ac@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090414091538.GI27003@elte.hu>
References: <20090414144317.026498df.sfr@canb.auug.org.au>
	<20090414091538.GI27003@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 11:15:38 +0200
Ingo Molnar <mingo@elte.hu> wrote:
> Subject: [PATCH] lockdep: warn about lockdep disabling after kernel taint, fix
> 
> Impact: build fix
> 
> Stephen Rothwell reported that the Sparc build broke:
> 
>  In file included from kernel/panic.c:12:
>  include/linux/debug_locks.h: In function '__debug_locks_off':
>  include/linux/debug_locks.h:15: error: implicit declaration of function 'xchg'
> 
> due to:
> 
>  9eeba61: lockdep: warn about lockdep disabling after kernel taint
> 
> There is some inconsistency between architectures about where exactly
> xchg() is defined. Most have it in system.h but also in atomic.h (which
> is arguably the more logical point for it). Some, such as Sparc only
> have it in asm/system.h and not available via asm/atomic.h.
> 
> Use the widest set of headers in debug_locks.h and also include asm/system.h.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/debug_locks.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
> index 493dedb..29b3ce3 100644
> --- a/include/linux/debug_locks.h
> +++ b/include/linux/debug_locks.h
> @@ -3,6 +3,7 @@
> 
>  #include <linux/kernel.h>
>  #include <asm/atomic.h>
> +#include <asm/system.h>

Ah, ok. Please ignore my other mail from a few seconds ago ;)
This fixes the s390 build break. Thanks!
