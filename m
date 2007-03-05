Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbXCEIrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbXCEIrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXCEIrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:47:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:62010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbXCEIrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:47:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Aubrey Li" <aubreylee@gmail.com>
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Date: Mon, 5 Mar 2007 09:47:09 +0100
User-Agent: KMail/1.9.6
Cc: bryan.wu@analog.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <200703032330.50116.arnd@arndb.de> <6d6a94c50703042254r6b0a328cu614f8c26ad0b9656@mail.gmail.com>
In-Reply-To: <6d6a94c50703042254r6b0a328cu614f8c26ad0b9656@mail.gmail.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703050947.10379.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18RfrAkxmGD5N7aqSRPdwGP/W/I5CcC+YNoZr5
 DSuJxqONaZ2J1yafV5vgHoJaUXKEqjq0E+rmcuvNqXy1AwJItH
 xQYwUEZNIhvAHu8W4lHZQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007, Aubrey Li wrote:
> On 3/4/07, Arnd Bergmann <arnd@arndb.de> wrote:

> > In general, please put EXPORT_SYMBOL lines below the definition
> > of the symbol itself. This list of exports should only be used
> > for symbols that come from assembly files.
> 
> What is the right way to export symbol coming from c files?
 
As I said, below the symbol definition, like

int global_var;
EXPORT_SYMBOL(global_var);

int global_function(void)
{
	return 3;
}
EXPORT_SYMBOL(global_function);

> > This detection seems to me like a strange thing to do in setup_arch().
> > It should be possible to do this much later, at a point where the system
> > is much less fragile and e.g. printk works. It could even be moved into
> > some place in the mtd code itself, since other architectures might want
> > to do the same thing.
> 
> After download the rootfs image from host to the target ram, we need
> to move the image to the right place, so we need to know the size of
> the image at this time.

Well, it doesn't have to be in the modular part of the kernel, but some
place later than setup_arch() would be a step in the right direction.
If you need it before the file systems, an arch_initcall() might be
the right place.

> > I'm curious: In your dual-core bf561, don't you actually need to implement
> > something that maintains atomicity across cores rather than just across
> > processes?
> 
> Yes, bf561 is a dual-core processor, but we are using only one core of
> bf561 now.
> IMHO, BF561 architecture was not designed for SMP or NUMA.

Interesting, so what is the intended use of the other core? Does the
hardware have any way of supporting concurrency between the cores,
other than sending interrupts between them?

> > How does this fit in with the generic SPI code? Does it duplicate stuff
> > from there, or do you use it?
> 
> We use our own. We have dma which can be used for SPI operations.

I just looked again at your code. My question was more directed at whether
you use your own SPI abstraction layer instead of drivers/spi, which
you fortunately don't. The piece I was missing however is the spi_bfin5xx.c
driver, which was not part of this patch, though you seem to rely on it.
Is that already part of the -mm kernel?

	Arnd <><
