Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316Ab0AHTYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0AHTYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662Ab0AHTYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:24:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab0AHTYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:24:47 -0500
Message-ID: <4B47867B.4080700@suse.cz>
Date: Fri, 08 Jan 2010 20:24:43 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kbuild@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Valdis.Kletnieks@vt.edu
Subject: Re: linux-next: Tree for January 7 (pcmcia)
References: <20100107172134.af71c742.sfr@canb.auug.org.au> <20100107101006.e59989a8.rdunlap@xenotime.net> <20100107205728.GA19115@isilmar.linta.de> <20100107210744.GA10320@sepie.suse.cz> <20100107135557.989c9585.rdunlap@xenotime.net> <20100108175423.GA29713@comet.dominikbrodowski.net>
In-Reply-To: <20100108175423.GA29713@comet.dominikbrodowski.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dominik Brodowski wrote:
> From 77f9eb4599f1d0f5a43cadece9809018b534e308 Mon Sep 17 00:00:00 2001
> From: Michal Marek <mmarek@suse.cz>
> Date: Thu, 7 Jan 2010 21:03:11 +0100
> Subject: [PATCH] pcmcia: fix yenta dependency on PCCARD_NONSTATIC
> 
> With CONFIG_PCMCIA=m and CONFIG_YENTA=y, we get
> 
> drivers/built-in.o: In function `yenta_probe':
> yenta_socket.c:(.devinit.text+0x1e582): undefined reference to
> `pccard_nonstatic_ops'
> 
> This is because
> 
> select PCCARD_NONSTATIC if PCMCIA
> 
> sets PCCARD_NONSTATIC = min(YENTA, PCMCIA). Change it to 'if PCMCIA!=n'
> to remove the upper limit.
> 
> [linux@dominikbrodowski.net: propagate change to PCMICA_M8XX]
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> 
> diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> index efc51b9..e8f35da 100644
> --- a/drivers/pcmcia/Kconfig
> +++ b/drivers/pcmcia/Kconfig
> @@ -84,7 +84,7 @@ config YENTA
>  	tristate "CardBus yenta-compatible bridge support"
>  	depends on PCI
>  	select CARDBUS if !EMBEDDED
> -	select PCCARD_NONSTATIC if PCMCIA
> +	select PCCARD_NONSTATIC if PCMCIA != n
>  	---help---
>  	  This option enables support for CardBus host bridges.  Virtually
>  	  all modern PCMCIA bridges are CardBus compatible.  A "bridge" is
> @@ -161,8 +161,8 @@ config TCIC
>  
>  config PCMCIA_M8XX
>  	tristate "MPC8xx PCMCIA support"
> -	depends on PCMCIA && PPC && 8xx
> -	select PCCARD_IODYN if PCMCIA
> +	depends on PCCARD && PPC && 8xx
> +	select PCCARD_IODYN if PCMCIA != n

PCCARD_IODYN is bool, so this change is not necessary (but doesn't do
any harm either).

Michal
