Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYGOOAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYGOOAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYGOOA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:00:26 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51229 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbYGOOAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:00:25 -0400
Date: Tue, 15 Jul 2008 17:00:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: 1ea0704e (ptep_modify_prot transaction
	abstraction) breaks no-mmu
Message-ID: <20080715140021.GE24533@cs181140183.pp.htv.fi>
References: <8bd0f97a0807030638g5eb8f0eavd740e990b1cdf1c5@mail.gmail.com> <486CF610.7000905@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <486CF610.7000905@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 08:53:52AM -0700, Jeremy Fitzhardinge wrote:
> Mike Frysinger wrote:
>> the functions added to asm-generic/pgtable.h are only used by
>> mm/mprotect.c (a MMU-only file), but they were not added inside of the
>> CONFIG_MMU ifdef block.  since the functions rely on things inside of
>> CONFIG_MMU (the lines just above in pgtable.h), we get build failure
>> on all no-mmu setups:
>>   CC      init/main.o
>> In file included from include/asm/pgtable.h:94,
>>                  from include/linux/mm.h:39,
>>                  from include/asm/dma.h:39,
>>                  from include/linux/bootmem.h:8,
>>                  from init/main.c:27:
>> include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
>> include/asm-generic/pgtable.h:210: error: implicit declaration of
>> function 'ptep_get_and_clear'
>> include/asm-generic/pgtable.h:210: error: incompatible types in return
>> make[1]: *** [init/main.o] Error 1
>> make: *** [init/main.o] Error 2
>> -mike
>>   
>
> Uh, OK.  What does mprotect do on a nommu system?  Would it be  
> sufficient to move the definitions of __ptep_modify_prot_start/commit  
> out of a CONFIG_MMU block, or provide separate no-op versions?

FYI:
The compile error now moved into Linus' tree, and broke at least the 
blackfin and m68knommu ports.

>    J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

