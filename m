Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZGFKn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZGFKn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 06:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZGFKns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 06:43:48 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:58921 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbZGFKns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 06:43:48 -0400
Date: Mon, 6 Jul 2009 11:43:21 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Jason Wessel <jason.wessel@windriver.com>,
       Wu Zhangjin <wuzj@lemote.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: Re: [PATCH v4 03/16] [loongson] early_printk: add new implmentation
Message-ID: <20090706104321.GC11727@linux-mips.org>
References: <cover.1246546684.git.wuzhangjin@gmail.com> <9e23b4150f183c0817f2abbb95525279c2006a83.1246546684.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e23b4150f183c0817f2abbb95525279c2006a83.1246546684.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 11:20:20PM +0800, Wu Zhangjin wrote:

> +#include <asm/mips-boards/bonito64.h>
> +
> +#define UART_BASE (BONITO_PCIIO_BASE + 0x3f8)
> +
> +#define PORT(base, offset) (u8 *)(base + offset)
> +
> +static inline unsigned int serial_in(phys_addr_t base, int offset)
> +{
> +	return readb(PORT(base, offset));
> +}
> +
> +static inline void serial_out(phys_addr_t base, int offset, int value)
> +{
> +	writeb(value, PORT(base, offset));

Why not inb(0x3f8, + offset) rsp. outb()?

> +}
> +
> +void prom_putchar(char c)
> +{
> +	phys_addr_t uart_base =
> +		(phys_addr_t) ioremap_nocache(UART_BASE, 8);

ioremap_nocache returns a virtual address, not a physical address, so
this type should probably be unsigned char *.

> +	while ((serial_in(uart_base, UART_LSR) & UART_LSR_THRE) == 0)

  Ralf
