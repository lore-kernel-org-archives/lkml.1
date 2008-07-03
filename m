Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYGCPyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYGCPyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYGCPyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:54:00 -0400
Received: from gw.goop.org ([64.81.55.164]:51438 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbYGCPx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:53:59 -0400
Message-ID: <486CF610.7000905@goop.org>
Date: Thu, 03 Jul 2008 08:53:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: 1ea0704e (ptep_modify_prot transaction abstraction)
 breaks no-mmu
References: <8bd0f97a0807030638g5eb8f0eavd740e990b1cdf1c5@mail.gmail.com>
In-Reply-To: <8bd0f97a0807030638g5eb8f0eavd740e990b1cdf1c5@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> the functions added to asm-generic/pgtable.h are only used by
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
> -mike
>   

Uh, OK.  What does mprotect do on a nommu system?  Would it be 
sufficient to move the definitions of __ptep_modify_prot_start/commit 
out of a CONFIG_MMU block, or provide separate no-op versions?

    J

