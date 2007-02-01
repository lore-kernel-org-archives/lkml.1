Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXBAHhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXBAHhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 02:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030520AbXBAHhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 02:37:14 -0500
Received: from mx1.suse.de ([195.135.220.2]:48642 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030519AbXBAHhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 02:37:13 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] VIA IRQ quirk breakage fix
Date: Thu, 1 Feb 2007 08:39:19 +0100
User-Agent: KMail/1.9.1
Cc: Sergey Vlasov <vsu@altlinux.ru>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
References: <45B6A94A.3010006@yahoo.com.au> <200701301325.58843.jdelvare@suse.de> <20070130183706.f0d93103.akpm@osdl.org>
In-Reply-To: <20070130183706.f0d93103.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702010839.19961.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Le Mercredi 31 Janvier 2007 03:37, Andrew Morton a écrit :
> On Tue, 30 Jan 2007 13:25:58 +0100
>
> Jean Delvare <jdelvare@suse.de> wrote:
> > So here comes the third
> > (and hopefully last) iteration of the patch:
>
> argh, it looks like I sent v2 to Linus.
>
> Here's the missing bit.  Please confirm that we want it?

Yes, we want it. Please push it to Linus ASAP. Good thing we had this rc7 
after all :)

>
>
> From: Jean Delvare <jdelvare@suse.de>
>
> Add special handling for the VT82C686.
>
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
>
>  drivers/pci/quirks.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff -puN drivers/pci/quirks.c~via-quirk-fix-update drivers/pci/quirks.c
> --- a/drivers/pci/quirks.c~via-quirk-fix-update
> +++ a/drivers/pci/quirks.c
> @@ -661,9 +661,11 @@ static void quirk_via_bridge(struct pci_
>  	/* See what bridge we have and find the device ranges */
>  	switch (dev->device) {
>  	case PCI_DEVICE_ID_VIA_82C686:
> -		/* 82C686 is special */
> -		via_vlink_dev_lo = 7;
> -		via_vlink_dev_hi = 7;
> +		/* The VT82C686 is special, it attaches to PCI and can have
> +		   any device number. All its subdevices are functions of
> +		   that single device. */
> +		via_vlink_dev_lo = PCI_SLOT(dev->devfn);
> +		via_vlink_dev_hi = PCI_SLOT(dev->devfn);
>  		break;
>  	case PCI_DEVICE_ID_VIA_8237:
>  	case PCI_DEVICE_ID_VIA_8237A:
> _

-- 
Jean Delvare
Suse L3
