Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZKSVtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZKSVtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZKSVtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:49:16 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34962 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbZKSVtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:49:16 -0500
Message-ID: <4B05BD58.8040008@pobox.com>
Date: Thu, 19 Nov 2009 16:49:12 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <4B0590A2.9050306@ru.mvista.com> <200911192003.09675.bzolnier@gmail.com> <200911192031.31613.bzolnier@gmail.com>
In-Reply-To: <200911192031.31613.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2009 02:31 PM, Bartlomiej Zolnierkiewicz wrote:
> Subject: [PATCH] pata_hpt{37x,3x2n}: add debounce delay to cable detection methods
>
> Alan Cox reported that cable detection sometimes works unreliably
> for HPT3xxN and that the issue is fixed by adding debounce delay
> as used by the vendor driver.
>
> Sergei Shtylyov also noticed that debounce delay is needed for all
> HPT37x and HPT3xxN chipsets according to vendor drivers.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
> In comparison to original patch the conversion from PCI access to
> io has been dropped as it is not required for the bugfix and makes
> patch easier for back-porting into -stable kernels.
>
>   drivers/ata/pata_hpt37x.c  |    3 +++
>   drivers/ata/pata_hpt3x2n.c |    3 +++
>   2 files changed, 6 insertions(+)
>
> Index: b/drivers/ata/pata_hpt37x.c
> ===================================================================
> --- a/drivers/ata/pata_hpt37x.c
> +++ b/drivers/ata/pata_hpt37x.c
> @@ -324,6 +324,9 @@ static int hpt37x_pre_reset(struct ata_l
>
>   	pci_read_config_byte(pdev, 0x5B,&scr2);
>   	pci_write_config_byte(pdev, 0x5B, scr2&  ~0x01);
> +
> +	udelay(10); /* debounce */
> +
>   	/* Cable register now active */
>   	pci_read_config_byte(pdev, 0x5A,&ata66);
>   	/* Restore state */
> Index: b/drivers/ata/pata_hpt3x2n.c
> ===================================================================
> --- a/drivers/ata/pata_hpt3x2n.c
> +++ b/drivers/ata/pata_hpt3x2n.c
> @@ -128,6 +128,9 @@ static int hpt3x2n_cable_detect(struct a
>
>   	pci_read_config_byte(pdev, 0x5B,&scr2);
>   	pci_write_config_byte(pdev, 0x5B, scr2&  ~0x01);
> +
> +	udelay(10); /* debounce */
> +
>   	/* Cable register now active */
>   	pci_read_config_byte(pdev, 0x5A,&ata66);
>   	/* Restore state */


applied -- same comment as last email, regarding hpt3x2n_cable_detect() fix

