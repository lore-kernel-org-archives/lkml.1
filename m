Return-Path: <linux-kernel-owner+w=401wt.eu-S933471AbYDVXTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbYDVXTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYDVXSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:18:55 -0400
Received: from oss.sgi.com ([192.48.170.157]:38192 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbYDVXSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:18:55 -0400
Date: Wed, 23 Apr 2008 00:18:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 8/11] mips: convert to generic helpers for IPI function
	calls
Message-ID: <20080422231827.GD27728@linux-mips.org>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-9-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208890227-24808-9-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 08:50:24PM +0200, Jens Axboe wrote:

> This converts mips to use the new helpers for smp_call_function() and
> friends, and adds support for smp_call_function_single(). Not tested,
> but it compiles.
> 
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  arch/mips/Kconfig              |    1 +
>  arch/mips/kernel/smp-mt.c      |   27 ++++++++-
>  arch/mips/kernel/smp.c         |  133 +++-------------------------------------
>  arch/mips/kernel/smtc.c        |    7 ++
>  arch/mips/sibyte/bcm1480/smp.c |    3 +
>  arch/mips/sibyte/sb1250/smp.c  |    2 +
>  include/asm-mips/smp.h         |   12 +---
>  7 files changed, 49 insertions(+), 136 deletions(-)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index 8724ed3..5092a9e 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -1742,6 +1742,7 @@ config SMP
>  	bool "Multi-Processing support"
>  	depends on SYS_SUPPORTS_SMP
>  	select IRQ_PER_CPU
> +	select USE_GENERIC_SMP_HELPERS
>  	help
>  	  This enables support for systems with more than one CPU. If you have
>  	  a system with only one CPU, like most personal computers, say N. If
> diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
> index 89e6f6a..31049fc 100644
> --- a/arch/mips/kernel/smp-mt.c
> +++ b/arch/mips/kernel/smp-mt.c
> @@ -38,8 +38,9 @@
>  
>  #define MIPS_CPU_IPI_RESCHED_IRQ 0
>  #define MIPS_CPU_IPI_CALL_IRQ 1
> +#define MIPS_CPU_IPI_CALL_SINGLE_IRQ 2

The smp-mt.c has no chance of working.  There are only two hardware
interrupts available so just using one more won't quite work.  But I like
the basic idea of this patch series.

  Ralf
