Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZLDKnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZLDKnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZLDKnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:43:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40943 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZLDKnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:43:13 -0500
Date: Fri, 4 Dec 2009 10:43:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       valentin.longchamp@epfl.ch
Subject: Re: [RFC][PATCH 03/10] arm: mxc: changes to common plat-mxc code
	to add support for i.MX5
Message-ID: <20091204104311.GD15887@n2100.arm.linux.org.uk>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 04:47:03AM +0200, Amit Kucheria wrote:
> +#elif defined CONFIG_MXC_TZIC
> +	@ Load offset & priority of the highest priority
> +	@ interrupt pending.
> +	@ 0xD80 is HIPND0 register
> +	ldr     \irqnr, =0
> +	ldr     \irqstat, =0x0D80

Both these constants can be loaded by a 'mov' instruction.

> +1000:
> +	ldr     \tmp,   [\irqstat, \base]
> +	cmp     \tmp, #0
> +	bne     1001f
> +	addeq   \irqnr, \irqnr, #32
> +	addeq   \irqstat, \irqstat, #4
> +	cmp     \irqnr, #128
> +	blo     1000b
> +	b       2001f
> +1001:	ldr     \irqstat, =1

	mov	\irqstat, #1

> +1002:	tst     \tmp, \irqstat
> +	bne     2002f
> +	movs    \tmp, \tmp, lsr #1
> +	addne   \irqnr, \irqnr, #1
> +	bne     1002b
> +2001:
> +	ldr  \irqnr, =0

	mov	\irqnr, #0

would be better.

> diff --git a/arch/arm/plat-mxc/time.c b/arch/arm/plat-mxc/time.c
> index 844567e..97fb590 100644
> --- a/arch/arm/plat-mxc/time.c
> +++ b/arch/arm/plat-mxc/time.c
> @@ -25,6 +25,7 @@
>  #include <linux/irq.h>
>  #include <linux/clockchips.h>
>  #include <linux/clk.h>
> +#include <linux/delay.h>

What is the reason for adding this include?
