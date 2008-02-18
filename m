Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbYBRLuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbYBRLuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbYBRLtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:49:52 -0500
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:1113 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756750AbYBRLtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:49:52 -0500
Date: Mon, 18 Feb 2008 12:49:47 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Adrian Bunk <bunk@kernel.org>, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: mips SMBUS_PSC_BASE compile errors
Message-ID: <20080218124947.2a768c05@hyperion.delvare>
In-Reply-To: <20080218102146.GA7282@roarinelk.homelinux.net>
References: <20080217200953.GJ1403@cs181133002.pp.htv.fi>
	<20080218102146.GA7282@roarinelk.homelinux.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008 11:21:46 +0100, Manuel Lauss wrote:
> > ...
> >   CC      arch/mips/au1000/common/platform.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/au1000/common/platform.c:277: error: 'PSC0_BASE_ADDR' undeclared here (not in a function)
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/au1000/common/platform.c:314: warning: no previous prototype for 'au1xxx_platform_init'
> > make[2]: *** [arch/mips/au1000/common/platform.o] Error 1
> 
> Thanks, here's a patch. The db1200/pb1550 defconfigs (+ i2c enabled) compile
> fine with it:
> 
> ---
> 
> From 0300b5b756561de57e09d49b06f608f2d541c3f3 Mon Sep 17 00:00:00 2001
> From: Manuel Lauss <mano@roarinelk.homelinux.net>
> Date: Mon, 18 Feb 2008 11:12:20 +0100
> Subject: [PATCH] Alchemy: compile fix
> 
> Commit 8b798c4d16b762d15f4055597ff8d87f73b35552 broke
> alchemy build, fix it.  Pointed out by Adrian Bunk.
> 
> Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
> ---
>  include/asm-mips/mach-db1x00/db1200.h |    1 +
>  include/asm-mips/mach-db1x00/db1x00.h |    1 +
>  include/asm-mips/mach-pb1x00/pb1200.h |    1 +
>  include/asm-mips/mach-pb1x00/pb1550.h |    1 +
>  4 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-mips/mach-db1x00/db1200.h b/include/asm-mips/mach-db1x00/db1200.h
> index 050eae8..a6bdac6 100644
> --- a/include/asm-mips/mach-db1x00/db1200.h
> +++ b/include/asm-mips/mach-db1x00/db1200.h
> @@ -25,6 +25,7 @@
>  #define __ASM_DB1200_H
>  
>  #include <linux/types.h>
> +#include <asm/mach-au1x00/au1xxx_psc.h>
>  
>  // This is defined in au1000.h with bogus value
>  #undef AU1X00_EXTERNAL_INT
> diff --git a/include/asm-mips/mach-db1x00/db1x00.h b/include/asm-mips/mach-db1x00/db1x00.h
> index 0f5f4c2..e7a88ba 100644
> --- a/include/asm-mips/mach-db1x00/db1x00.h
> +++ b/include/asm-mips/mach-db1x00/db1x00.h
> @@ -28,6 +28,7 @@
>  #ifndef __ASM_DB1X00_H
>  #define __ASM_DB1X00_H
>  
> +#include <asm/mach-au1x00/au1xxx_psc.h>
>  
>  #ifdef CONFIG_MIPS_DB1550
>  
> diff --git a/include/asm-mips/mach-pb1x00/pb1200.h b/include/asm-mips/mach-pb1x00/pb1200.h
> index d9f384a..ed5fd73 100644
> --- a/include/asm-mips/mach-pb1x00/pb1200.h
> +++ b/include/asm-mips/mach-pb1x00/pb1200.h
> @@ -25,6 +25,7 @@
>  #define __ASM_PB1200_H
>  
>  #include <linux/types.h>
> +#include <asm/mach-au1x00/au1xxx_psc.h>
>  
>  // This is defined in au1000.h with bogus value
>  #undef AU1X00_EXTERNAL_INT
> diff --git a/include/asm-mips/mach-pb1x00/pb1550.h b/include/asm-mips/mach-pb1x00/pb1550.h
> index 9a4955c..c2ab0e2 100644
> --- a/include/asm-mips/mach-pb1x00/pb1550.h
> +++ b/include/asm-mips/mach-pb1x00/pb1550.h
> @@ -28,6 +28,7 @@
>  #define __ASM_PB1550_H
>  
>  #include <linux/types.h>
> +#include <asm/mach-au1x00/au1xxx_psc.h>
>  
>  #define DBDMA_AC97_TX_CHAN DSCR_CMD0_PSC1_TX
>  #define DBDMA_AC97_RX_CHAN DSCR_CMD0_PSC1_RX

As the breakage came through my i2c tree, I guess I am supposed to push
this fix as well?

-- 
Jean Delvare
