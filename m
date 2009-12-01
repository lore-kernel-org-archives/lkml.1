Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZLASdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZLASdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZLASds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:33:48 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:12440 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752513AbZLASdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:33:47 -0500
Message-ID: <4B1561CD.2030600@ru.mvista.com>
Date: Tue, 01 Dec 2009 21:34:53 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/86] pata_artop: add Power Management support
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125170253.5446.62167.sendpatchset@localhost>
In-Reply-To: <20091125170253.5446.62167.sendpatchset@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> There shouldn't be any problems with it as IDE aec62xx host driver
> has been supporting Power Management for over year now.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ata/pata_artop.c |   72 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 51 insertions(+), 21 deletions(-)

> Index: b/drivers/ata/pata_artop.c
> ===================================================================
> --- a/drivers/ata/pata_artop.c
> +++ b/drivers/ata/pata_artop.c
[...]
> @@ -330,6 +330,33 @@ static struct ata_port_operations atp86x
>  	.prereset		= atp86x_pre_reset,
>  };
>  
> +static void atp8xx_fixup(struct pci_dev *pdev)
> +{
> +	if (pdev->device == 0x0005)
> +		/* BIOS may have left us in UDMA, clear it before probe */
> +		pci_write_config_byte(pdev, 0x54, 0);
> +	else if (pdev->device == 0x0008 || pdev->device == 0x0009) {
> +		u8 reg;
> +
> +		/* Mac systems come up with some registers not set as we
> +		   will need them */
> +
> +		/* Clear reset & test bits */
> +		pci_read_config_byte(pdev, 0x49, &reg);
> +		pci_write_config_byte(pdev, 0x49, reg & ~ 0x30);

    Space not needed between ~ and 0x30...

MBR, Sergei
