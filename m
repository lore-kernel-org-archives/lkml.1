Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbYKVQr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbYKVQr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 11:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbYKVQrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 11:47:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41027 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758613AbYKVQrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 11:47:47 -0500
Date: Sat, 22 Nov 2008 16:47:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: vme_scc.c breakage (was: Re: linux-next: Tree for November 21)
Message-ID: <20081122164738.2226b63e@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811221558340.30025@anakin>
References: <20081121181948.ee771502.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0811221558340.30025@anakin>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> | -	struct scc_port *port = ptr;
> | +	struct scc_port *scc = container_of(port, struct scc_port, gs.port);
> |  	unsigned channel = port->channel;
> |  
> |  	return !!(scc_last_status_reg[channel] & SR_DCD);
> 
> Issues:
>   1. When Atari support is enabled, `scc' is defined in
>      include/asm-m68k/atari.h as:
> 
> 	# define scc ((*(volatile struct SCC*)SCC_BAS))
> 
>      However, renaming the variable `scc' doesn't help, as
> 
>   2. the variable `scc' is not used in scc_carrier_raised(),
> 
>   3. `port->channel' on line 635 still fails as `port' is not longer `struct
>      scc_port', but a 'struct tty_port', which has no member named 'channel'.

Will take a look at this, but gs is going to away so at some point
someone with hardware is going to have to admit to owning this driver or
just mark it BROKEN..

Alan
