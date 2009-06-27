Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbZF0RUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbZF0RUv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZF0RUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:20:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55764 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671AbZF0RUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:20:41 -0400
Subject: Re: [PATCH 14/19] drivers/scsi: Use PCI_VDEVICE
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Adam Radford <linuxraid@amcc.com>,
       Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
       Rik Faith <faith@cs.unc.edu>, Neela Syam Kolli <megaraidlinux@lsi.com>,
       Willem Riede <osst@riede.org>,
       Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
       Matthew Wilcox <matthew@wil.cx>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org,
       osst-users@lists.sourceforge.net
In-Reply-To: <079fbc10b41dd4b7f0d381b7e969134184652c95.1245906152.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
	 <079fbc10b41dd4b7f0d381b7e969134184652c95.1245906152.git.joe@perches.com>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 12:20:35 -0500
Message-Id: <1246123235.3990.15.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 22:13 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

OK, so there's no description whatsoever how am I supposed to divine the
reasons for doing this?

Because if I look at an example:

> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -2278,14 +2278,10 @@ out_disable_device:
>  
>  /* PCI Devices supported by this driver */
>  static struct pci_device_id twa_pci_tbl[] __devinitdata = {
> -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9000,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9550SX,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9650SE,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9690SA,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9000), 0},
> +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9550SX), 0},
> +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9650SE), 0},
> +	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9690SA), 0},

It appears to take PCI matching on vendor device with any subvendor,
device and reproduce the results with a macro, which, for good measure
pastes PCI_VENDOR_ID on to the first argument but *doesn't* paste
PCI_DEVICE_ID on to the second?

So it transforms a relatively opaque initialiser which most people would
have to look up in pci.h into another relatively opaque initialiser
indirected via a macro, so now I have to look up both the structure and
the macro to figure out what's going on.

If that's all it does, I'm having a hard time seeing any actual
improvement here.

James


