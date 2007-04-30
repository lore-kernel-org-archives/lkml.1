Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbXD3OKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbXD3OKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423246AbXD3OKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:10:36 -0400
Received: from aun.it.uu.se ([130.238.12.36]:40799 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbXD3OKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:10:00 -0400
Date: Mon, 30 Apr 2007 16:09:54 +0200 (MEST)
Message-Id: <200704301409.l3UE9sFg019392@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: juergen127@kreuzholzen.de, linux-kernel@vger.kernel.org, mikpe@it.uu.se
Subject: Re: [PATCH] [1/1] CPU-i386-Geode: Chipset access macros do not work as expected
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 15:09:58 +0200, Juergen Beisert wrote:
> Replace NSC/Cyrix specific chipset access macros by inlined functions.
> With the macros a line like this fails (and does nothing):
> 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> With inlined functions this line will work as expected.

Looks ok, but some cleanups are in order. See below.

> +++ linux-2.6.21/include/asm-i386/processor-cyrix.h
> @@ -0,0 +1,35 @@
> +/*
> + * NSC/Cyrix CPU configuration register indexes
> + */
> +#define CX86_PCR0 0x20
> +#define CX86_GCR  0xb8
> +#define CX86_CCR0 0xc0
> +#define CX86_CCR1 0xc1
> +#define CX86_CCR2 0xc2
> +#define CX86_CCR3 0xc3
> +#define CX86_CCR4 0xe8
> +#define CX86_CCR5 0xe9
> +#define CX86_CCR6 0xea
> +#define CX86_CCR7 0xeb
> +#define CX86_PCR1 0xf0
> +#define CX86_DIR0 0xfe
> +#define CX86_DIR1 0xff
> +#define CX86_ARR_BASE 0xc4
> +#define CX86_RCR_BASE 0xdc
> +
> +/*
> + * NSC/Cyrix CPU indexed register access
> + */
> +static inline u8 getCx86(u8 reg)
> +{
> +	outb(reg,0x22);

----------------^ missing space after comma

> +	return inb(0x23);
> +}
> +
> +static inline void setCx86(u8 reg, u8 data)
> +{
> +	outb(reg,0x22);

----------------^ missing space after comma

> +	outb(data,0x23);

ditto

> +}
> +
> +/* end of file processor-cyrix.h */

Totally redundant comment. Drop it.

/Mikael
