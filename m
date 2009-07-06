Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZGFOBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZGFOBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZGFOA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:00:58 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58542 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbZGFOA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=B7+z1D4F30EALKFdNK/zXv6kcZqv5Su3bSy36+b5rsCv7cizqRSApLKF5cFtJ/hD/K
         q/eH8q9fwfBkNXK7779VuojIPy5wcNEIEZTY6aMT7EZuEtyFQRCUesBnUF4PHCsQnrjC
         fUYi7i+PtDnXQYsk4uXI3zU6f0ASrFPM6W7mc=
Subject: Re: [PATCH v4 03/16] [loongson] early_printk: add new implmentation
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Jason Wessel <jason.wessel@windriver.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
In-Reply-To: <20090706104321.GC11727@linux-mips.org>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
	 <9e23b4150f183c0817f2abbb95525279c2006a83.1246546684.git.wuzhangjin@gmail.com>
	 <20090706104321.GC11727@linux-mips.org>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Mon, 06 Jul 2009 21:57:13 +0800
Message-Id: <1246888633.30387.9.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 11:43 +0100, Ralf Baechle wrote:
> On Thu, Jul 02, 2009 at 11:20:20PM +0800, Wu Zhangjin wrote:
> 
> > +#include <asm/mips-boards/bonito64.h>
> > +
> > +#define UART_BASE (BONITO_PCIIO_BASE + 0x3f8)
> > +
> > +#define PORT(base, offset) (u8 *)(base + offset)
> > +
> > +static inline unsigned int serial_in(phys_addr_t base, int offset)
> > +{
> > +	return readb(PORT(base, offset));
> > +}
> > +
> > +static inline void serial_out(phys_addr_t base, int offset, int value)
> > +{
> > +	writeb(value, PORT(base, offset));
> 
> Why not inb(0x3f8, + offset) rsp. outb()?
> 

because yeeloong laptop use the serial port of cpu, which have different
base address: 0x1ff000000 + 0x3f8, to share the same source code between
yeeloong, fuloong2f(0x1fd00000 + 0x2f8) and fuloong2e(0x1fd00000 +
0x3f8), I use PORT(base, offset) here and use readb/writeb instead of
inb/outb. so, here is only a preparation for future yeeloong2f support.

> > +}
> > +
> > +void prom_putchar(char c)
> > +{
> > +	phys_addr_t uart_base =
> > +		(phys_addr_t) ioremap_nocache(UART_BASE, 8);
> 
> ioremap_nocache returns a virtual address, not a physical address, so
> this type should probably be unsigned char *.
> 

okay, I will change it.

Thanks!
Wu Zhangjin

