Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab0BXDhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:37:34 -0500
Received: from kroah.org ([198.145.64.141]:47110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab0BXDg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:36:59 -0500
Date: Tue, 23 Feb 2010 18:16:24 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: import of usb series failed
Message-ID: <20100224021624.GB14159@kroah.com>
References: <20100218105500.898ece5e.sfr@canb.auug.org.au> <20100218002144.GA17850@kroah.com> <20100218132221.b15d151f.sfr@canb.auug.org.au> <20100219175218.10025a7a.sfr@canb.auug.org.au> <20100219155343.GA3946@kroah.com> <20100220120207.1d765147.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100220120207.1d765147.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 20, 2010 at 12:02:07PM +1100, Stephen Rothwell wrote:
> So, since the ".current" series are all empty, I am importing the
> driver-core, tty and then usb series on top of v2.6.33-rc8.  I have just
> done this again manually and the failure still happens (I have not
> refetched your quilt series since yesterday.
> 
> At this point, the file drivers/usb/serial/ftdi_sio_ids.h from line 185
> looks like this:
> 
> #define FTDI_ELV_PCD200_PID	0xF06C	/* PC-Datenlogger (PCD 200) */
> #define FTDI_ELV_ULA200_PID	0xF06D	/* USB-LCD-Ansteuerung (ULA 200) */
> #define FTDI_ELV_ALC8500_PID	0xF06E	/* ALC 8500 Expert */
> #define FTDI_ELV_FHZ1000PC_PID	0xF06F	/* FHZ 1000 PC */
> #define FTDI_ELV_UR100_PID	0xFB58	/* USB-RS232-Umsetzer (UR 100) */
> #define FTDI_ELV_UM100_PID	0xFB5A	/* USB-Modul UM 100 */
> 
> The patch hunk looks like this:
> 
> @@ -185,7 +185,7 @@
>  #define FTDI_ELV_TFD128_PID	0xE0EC	/* ELV Temperatur-Feuchte-Datenlogger TFD 128 */
>  #define FTDI_ELV_FM3RX_PID	0xE0ED	/* ELV Messwertuebertragung FM3 RX */
>  #define FTDI_ELV_WS777_PID	0xE0EE	/* Conrad WS 777 */
> -#define FTDI_ELV_EM1010PC_PID	0xE0EF	/* Engery monitor EM 1010 PC */
> +#define FTDI_ELV_EM1010PC_PID	0xE0EF	/* Energy monitor EM 1010 PC */
>  #define FTDI_ELV_CSI8_PID	0xE0F0	/* Computer-Schalt-Interface (CSI 8) */
>  #define FTDI_ELV_EM1000DL_PID	0xE0F1	/* PC-Datenlogger fuer Energiemonitor (EM 1000 DL) */
>  #define FTDI_ELV_PCK100_PID	0xE0F2	/* PC-Kabeltester (PCK 100) */
> 
> Between v2.6.33-rc8 and the head if Linus' tree thee are two patches that
> change this file.  So I guess the BASE in the driver-core.current series
> files needs updating.

Yes, that seems to be the problem here.

I have been doing the BASE tag as a -rc level tag (or rc-gitX tag), can
I use a SHA1 of Linus's tree to base this against instead?  Would that
work ok with your scripts?

thanks for figureing this out, sorry for the trouble, this was my fault.

greg k-h
