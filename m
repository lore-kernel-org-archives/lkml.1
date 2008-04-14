Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYDNOkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYDNOkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757025AbYDNOkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:40:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56259 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755122AbYDNOkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:40:46 -0400
Date: Mon, 14 Apr 2008 15:36:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: hskinnemoen@atmel.com, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] avr32: don't offer SERIAL_8250
Message-ID: <20080414153625.6150e999@core>
In-Reply-To: <20080414141721.GI6695@cs181133002.pp.htv.fi>
References: <20080414141721.GI6695@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 17:17:21 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/serial/8250.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/serial/8250.c:95:24: error: asm/serial.h: No such file or directory
> make[3]: *** [drivers/serial/8250.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 3cb4ef80d75e118ccfd44f7006aea3db54afb31c diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index b1bbaa0..b0e216d 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -11,7 +11,7 @@ menu "Serial drivers"
>  # The new 8250/16550 serial drivers
>  config SERIAL_8250
>  	tristate "8250/16550 and compatible serial support"
> -	depends on (BROKEN || !SPARC)
> +	depends on (BROKEN || !SPARC) && !AVR32
>  	select SERIAL_CORE
>  	---help---

NAK.

Add an asm/serial.h to the platform as it has PCI so will have 8250 PCI
devices available to it. A copy of the MIPS one should be right.

Alan
