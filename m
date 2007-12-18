Return-Path: <linux-kernel-owner+w=401wt.eu-S1763633AbXLRSWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763633AbXLRSWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757613AbXLRSUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:20:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697AbXLRSUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:20:50 -0500
Date: Tue, 18 Dec 2007 13:18:04 -0500 (EST)
From: Chip Coldwell <coldwell@frank.harvard.edu>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
cc: Andrew Victor <linux@maxim.org.za>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Remy Bohmer <linux@bohmer.net>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH 5/5] atmel_serial: Add DMA support
In-Reply-To: <1197997575-13292-6-git-send-email-hskinnemoen@atmel.com>
Message-ID: <alpine.LFD.0.9999.0712181317070.27475@localhost.localdomain>
References: <1197997575-13292-1-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-2-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-3-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-4-git-send-email-hskinnemoen@atmel.com>
 <1197997575-13292-5-git-send-email-hskinnemoen@atmel.com> <1197997575-13292-6-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Tue, 18 Dec 2007, Haavard Skinnemoen wrote:

> From: Chip Coldwell <hskinnemoen@atmel.com>
> 
> This patch is based on the DMA-patch by Chip Coldwell for the
> AT91/AT32 serial USARTS, with some tweaks to make it apply neatly on
> top of the other patches in this series.
> 
> The RX code has been moved to a tasklet and reworked a bit. Instead of
> depending on the ENDRX and TIMEOUT bits in CSR, we simply grab as much
> data as we can from the DMA buffers. I think this closes a race where
> the ENDRX bit is set after we read CSR but before we read RPR,
> although I haven't confirmed this.
> 
> This also fixes a DMA sync bug in the original patch.
> 
> [linux@bohmer.net: rebased onto irq-splitup patch]
> [hskinnemoen@atmel.com: moved to tasklet, fixed dma bug, misc cleanups]
> Signed-off-by: Remy Bohmer <linux@bohmer.net>
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
>  drivers/serial/atmel_serial.c |  386 ++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 366 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
> index 990d3ab..07c2734 100644
> --- a/drivers/serial/atmel_serial.c
> +++ b/drivers/serial/atmel_serial.c
> @@ -7,6 +7,8 @@
>   *  Based on drivers/char/serial_sa1100.c, by Deep Blue Solutions Ltd.
>   *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
>   *
> + *  DMA support added by Chip Coldwell.

I will ACK/Sign-off on this soon; I just want to do some tests on real
hardware first.

Chip

- -- 
Charles M. Coldwell
"Turn on, log in, tune out"
Somerville, Massachusetts, New England
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHaA7cr6maj4UuBS8RAjMSAJsGcKoFKCP/R3aAPhW5hj+v3Qt6ZACgshsF
5NP6/9+NbhDAxBC/7jo8J0Y=
=hx4t
-----END PGP SIGNATURE-----
