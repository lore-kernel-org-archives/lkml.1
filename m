Return-Path: <linux-kernel-owner+w=401wt.eu-S1751774AbYDWHSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbYDWHSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYDWHSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:18:45 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4200 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbYDWHSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:18:44 -0400
Date: Wed, 23 Apr 2008 09:18:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 8/11] mips: convert to generic helpers for IPI function  calls
Message-ID: <20080423071840.GW12774@kernel.dk>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-9-git-send-email-jens.axboe@oracle.com> <20080422231827.GD27728@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422231827.GD27728@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23 2008, Ralf Baechle wrote:
> On Tue, Apr 22, 2008 at 08:50:24PM +0200, Jens Axboe wrote:
> 
> > This converts mips to use the new helpers for smp_call_function() and
> > friends, and adds support for smp_call_function_single(). Not tested,
> > but it compiles.
> > 
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  arch/mips/Kconfig              |    1 +
> >  arch/mips/kernel/smp-mt.c      |   27 ++++++++-
> >  arch/mips/kernel/smp.c         |  133 +++-------------------------------------
> >  arch/mips/kernel/smtc.c        |    7 ++
> >  arch/mips/sibyte/bcm1480/smp.c |    3 +
> >  arch/mips/sibyte/sb1250/smp.c  |    2 +
> >  include/asm-mips/smp.h         |   12 +---
> >  7 files changed, 49 insertions(+), 136 deletions(-)
> > 
> > diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> > index 8724ed3..5092a9e 100644
> > --- a/arch/mips/Kconfig
> > +++ b/arch/mips/Kconfig
> > @@ -1742,6 +1742,7 @@ config SMP
> >  	bool "Multi-Processing support"
> >  	depends on SYS_SUPPORTS_SMP
> >  	select IRQ_PER_CPU
> > +	select USE_GENERIC_SMP_HELPERS
> >  	help
> >  	  This enables support for systems with more than one CPU. If you have
> >  	  a system with only one CPU, like most personal computers, say N. If
> > diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
> > index 89e6f6a..31049fc 100644
> > --- a/arch/mips/kernel/smp-mt.c
> > +++ b/arch/mips/kernel/smp-mt.c
> > @@ -38,8 +38,9 @@
> >  
> >  #define MIPS_CPU_IPI_RESCHED_IRQ 0
> >  #define MIPS_CPU_IPI_CALL_IRQ 1
> > +#define MIPS_CPU_IPI_CALL_SINGLE_IRQ 2
> 
> The smp-mt.c has no chance of working.  There are only two hardware
> interrupts available so just using one more won't quite work.  But I like
> the basic idea of this patch series.

I'll switch mips over to sharing the IPI for both ipi function calls
then, thanks Ralf!

-- 
Jens Axboe

