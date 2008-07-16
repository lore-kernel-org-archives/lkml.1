Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYGPMwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYGPMwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbYGPMwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:52:42 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38071 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbYGPMwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:52:41 -0400
Date: Wed, 16 Jul 2008 15:52:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: fix ptep_modify_* for no-MMU systems
Message-ID: <20080716125231.GB25557@cs181140183.pp.htv.fi>
References: <8bd0f97a0807030638g5eb8f0eavd740e990b1cdf1c5@mail.gmail.com> <486CF610.7000905@goop.org> <8bd0f97a0807150724x8f7095dl9b5d2e203053223f@mail.gmail.com> <487D0AEB.6080304@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <487D0AEB.6080304@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 01:39:07PM -0700, Jeremy Fitzhardinge wrote:
> Fixes build problem: the functions added to asm-generic/pgtable.h are 
> only used by
> mm/mprotect.c (a MMU-only file), but they were not added inside of the
> CONFIG_MMU ifdef block.  since the functions rely on things inside of
> CONFIG_MMU (the lines just above in pgtable.h), we get build failure
> on all no-mmu setups:
>   CC      init/main.o
> In file included from include/asm/pgtable.h:94,
>                  from include/linux/mm.h:39,
>                  from include/asm/dma.h:39,
>                  from include/linux/bootmem.h:8,
>                  from init/main.c:27:
> include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
> include/asm-generic/pgtable.h:210: error: implicit declaration of
> function 'ptep_get_and_clear'
> include/asm-generic/pgtable.h:210: error: incompatible types in return
> make[1]: *** [init/main.o] Error 1
> make: *** [init/main.o] Error 2
>...

Thanks, seems to work fine.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

