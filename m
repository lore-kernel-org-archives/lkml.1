Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZFIRSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZFIRSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZFIRSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:18:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64309 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZFIRSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:18:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 06/27] score: create head files delay.h device.h div64.h dma-mapping.h dma.h
Date: Tue, 9 Jun 2009 19:18:20 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OFA4420B9D.34FDC91E-ON482575D0.0023528E-482575D0.0023C39B@sunplusct.com>
In-Reply-To: <OFA4420B9D.34FDC91E-ON482575D0.0023528E-482575D0.0023C39B@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091918.20558.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18cfwOIVdH2cicUIPeDf7wVVKKAnjNuk43OxRg
 GuxqGYNC5SZ9H5wX11vmQIm80Uc5l3vnFLBKwFiUAw6yVBDt2f
 EMmBqXTe7/0dAFtFrZuyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:

> diff --git a/arch/score/include/asm/delay.h 
> b/arch/score/include/asm/delay.h
> new file mode 100644
> index 0000000..ea4d532
> --- /dev/null
> +++ b/arch/score/include/asm/delay.h
> @@ -0,0 +1,14 @@
> +#ifndef _ASM_SCORE_DELAY_H
> +#define _ASM_SCORE_DELAY_H
> +
> +static inline void __delay(unsigned long loops)
> +{}
> +
> +static inline void __udelay(unsigned long usecs)
> +{
> +       __delay(usecs);
> +}
> +
> +#define udelay(usecs) __udelay(usecs)
> +
> +#endif /* _ASM_SCORE_DELAY_H */

Having a working udelay() function is required for many
drivers that are sensitive to timing, you should probably
implement that at some point in the future.

> new file mode 100644
> index 0000000..f9c0193
> --- /dev/null
> +++ b/arch/score/include/asm/dma-mapping.h
> @@ -0,0 +1,6 @@
> +#ifndef _ASM_SCORE_DMA_MAPPING_H
> +#define _ASM_SCORE_DMA_MAPPING_H
> +
> +#include <asm-generic/dma-mapping-broken.h>
> +
> +#endif /* _ASM_SCORE_DMA_MAPPING_H */

This is what I did in the asm-generic#microblaze tree, but I noticed later
that you can simply leave out that file entirely when you set
CONFIG_NO_DMA.

> --- /dev/null
> +++ b/arch/score/include/asm/dma.h
> @@ -0,0 +1,8 @@
> +#ifndef _ASM_SCORE_DMA_H
> +#define _ASM_SCORE_DMA_H
> +
> +#include <asm/io.h>
> +
> +#define MAX_DMA_ADDRESS                (PAGE_OFFSET + 0x01000000)
> +
> +#endif /* _ASM_SCORE_DMA_H */

This indicates that you allow DMA to certain devices only in the first
16MB of memory, like an ISA floppy or parallel port. Do you actually have
any devices with this behaviour?

	Arnd <><
