Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbZFITQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbZFITQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZFITQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:16:10 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40220 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZFITQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:16:09 -0400
Date: Tue, 9 Jun 2009 21:18:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: liqin.chen@sunplusct.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 19/27] score: create kernel files asm-offsets.c entry.S head.S
Message-ID: <20090609191826.GD7181@uranus.ravnborg.org>
References: <OF62B83071.8F1A9FCF-ON482575D0.00241345-482575D0.0024859C@sunplusct.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF62B83071.8F1A9FCF-ON482575D0.00241345-482575D0.0024859C@sunplusct.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> new file mode 100644
> index 0000000..a7432c1
> --- /dev/null
> +++ b/arch/score/kernel/head.S
> @@ -0,0 +1,70 @@
> +/*
> + * arch/score/kernel/head.S
> + *
> + * Score Processor version.
> + *
> + * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> + *  Chen Liqin <liqin.chen@sunplusct.com>
> + *  Lennox Wu <lennox.wu@sunplusct.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see the file COPYING, or write
> + * to the Free Software Foundation, Inc.,
> + * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#include <asm/asm-offsets.h>
> +
> +       .extern start_kernel
> +       .global init_thread_union
> +       .global kernelsp
> +
> +       .section .init.text, "ax"

Please use section definitions from include/linux/init.h.
__INIT in this case.

Other architectures uses __HEAD so they have full control
on where to add this code in the final image.


> +       .align  2;
> +       .globl  _stext;
> +_stext:

Usually a linker defined symbol?

> +       la      r30, __bss_start        /* initialize BSS segment. */
> +       la      r31, _end
> +       xor     r8, r8, r8
> +
> +1:     cmp.c   r31, r30
> +       beq     2f
> +
> +       sw      r8, [r30]               /* clean memory. */
> +       addi    r30, 4
> +       b       1b
> +
> +2:     la      r28, init_thread_union  /* set kernel stack. */
> +       mv      r0, r28
> +       addi    r0, KERNEL_STACK_SIZE - 32
> +       la      r30, kernelsp
> +       sw      r0, [r30]
> +       subi    r0, 4*4
> +       xor     r30, r30, r30
> +       ori     r30, 0x02               /* enable MMU. */
> +       mtcr    r30, cr4
> +       nop
> +       nop
> +       nop
> +       nop
> +       nop
> +       nop
> +       nop
> +
> +       /* there is no parameter */
> +       xor     r4, r4, r4
> +       xor     r5, r5, r5
> +       xor     r6, r6, r6
> +       xor     r7, r7, r7
> +       la      r30, start_kernel       /* jump to init_arch */
> +       br      r30

	Sam
