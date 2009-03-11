Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZCKGzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZCKGzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 02:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZCKGza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 02:55:30 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:48643 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751700AbZCKGz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 02:55:29 -0400
Message-ID: <49B7605A.7000604@snapgear.com>
Date: Wed, 11 Mar 2009 16:55:22 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 10 (m68k/tlbflush.h)
References: <10f740e80903101307v70000e0cm61e261050411a715@mail.gmail.com>
In-Reply-To: <10f740e80903101307v70000e0cm61e261050411a715@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Geert Uytterhoeven wrote:
> Hi Greg,
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/180587/
> | arch/m68k/kernel/traps.c:274: error: implicit declaration of
> function '__flush_tlb040_one'
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/180591/
> | mm/vmalloc.c:555: error: implicit declaration of function
> 'flush_tlb_kernel_range'
> 
> Caused by:
> 
> | commit 7fa69761ea82752b97502383f7f2d3fdfa509115
> | Author: Greg Ungerer <gerg@uclinux.org>
> | Date:   Tue Feb 17 14:40:47 2009 +1000
> |
> |     m68k: merge the mmu and non-mmu versions of tlbflush.h
> |
> |     Simple merge of the mmu and non-mmu versions of tlbflush.h
> |
> |     Signed-off-by: Greg Ungerer <gerg@uclinux.org>
> 
> Seems like you merged the wrong way:
> 
> | diff --git a/arch/m68k/include/asm/tlbflush.h
> b/arch/m68k/include/asm/tlbflush.h
> | index b6f93b3..79050d0 100644
> | --- a/arch/m68k/include/asm/tlbflush.h
> | +++ b/arch/m68k/include/asm/tlbflush.h
> | @@ -1,5 +1,267 @@
> | -#ifdef __uClinux__
> | -#include "tlbflush_no.h"
> | +#ifndef _M68K_TLBFLUSH_H
> | +#define _M68K_TLBFLUSH_H
> | +
> | +#ifndef CONFIG_MMU
>     ^^^^^
>     ifdef
> 
> | +#ifndef CONFIG_SUN3

Yep, your absolutely right. Oddly enough it didn't stop non-mmu
builds from compiling or working...

I have fixed that patch, and pushed it into the m68knommu git
tree (for-next branch).

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
