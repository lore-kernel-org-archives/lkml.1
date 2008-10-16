Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbYJPHbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbYJPHbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 03:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYJPHbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 03:31:33 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:44873 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYJPHbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 03:31:33 -0400
Date: Thu, 16 Oct 2008 09:31:29 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, dan.j.williams@intel.com, tiwai@suse.de,
       linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
       linux-ide@vger.kernel.org, bzolnier@gmail.com, marek.vasut@gmail.com,
       dwmw2@infradead.org, mark.fasheh@oracle.com, ralf@linux-mips.org,
       mchehab@infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: powerpc allmodconfig
In-Reply-To: <20081015.220247.262683261.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0810160930300.25933@anakin>
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
 <20081015.220247.262683261.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, David Miller wrote:
> > kernel/resource.c: In function '__reserve_region_with_split':
> > kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
> > kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
> > kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'resource_size_t'
> > kernel/resource.c:554: warning: format '%llx' expects type 'long long unsigned int', but argument 7 has type 'resource_size_t'
> 
> Known issue, Ben wants to add a new variant of %pX in order to print resources so that
> resource_size_t vs. unsigned long stuff doesn't matter like this any more.

Will still give a warning, as resource_size_t is not a pointer.

> > drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_read':
> > drivers/rtc/rtc-ds1286.c:33: error: implicit declaration of function '__raw_readl'
> > drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_write':
> > drivers/rtc/rtc-ds1286.c:38: error: implicit declaration of function '__raw_writel'
> > drivers/rtc/rtc-ds1286.c: In function 'ds1286_probe':
> > drivers/rtc/rtc-ds1286.c:345: error: implicit declaration of function 'ioremap'
> > drivers/rtc/rtc-ds1286.c:345: warning: assignment makes pointer from integer without a cast
> > drivers/rtc/rtc-ds1286.c:365: error: implicit declaration of function 'iounmap'
> 
> Missing asm/io.h include.

Nah, <linux/io.h> ;-)

> > drivers/rtc/rtc-m48t35.c: In function 'm48t35_read_time':
> > drivers/rtc/rtc-m48t35.c:59: error: implicit declaration of function 'readb'
> > drivers/rtc/rtc-m48t35.c:60: error: implicit declaration of function 'writeb'
> > drivers/rtc/rtc-m48t35.c: In function 'm48t35_probe':
> > drivers/rtc/rtc-m48t35.c:168: error: implicit declaration of function 'ioremap'
> > drivers/rtc/rtc-m48t35.c:168: warning: assignment makes pointer from integer without a cast
> > drivers/rtc/rtc-m48t35.c:188: error: implicit declaration of function 'iounmap'
> 
> Likewise.

Already sent a patch for these two...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
