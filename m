Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXBXCGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXBXCGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 21:06:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933335AbXBXCGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 21:06:46 -0500
Received: from userg503.nifty.com ([202.248.238.83]:23309 "EHLO
	userg503.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326AbXBXCGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 21:06:45 -0500
DomainKey-Signature: a=rsa-sha1; s=userg503; d=nifty.com; c=nofws; q=dns;
	b=RAS97v1KtpCq4UtwIRXpnpDhXwLjbTA2SgSp2RrKSInImjZF93svtwuUqDginKG2K
	HPgGP1na2gITgl9vGB+HQ==
Date: Sat, 24 Feb 2007 11:06:19 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG]  PATA_PCMCIA does not work
Message-Id: <20070224110619.4f170754.komurojun-mbn@nifty.com>
In-Reply-To: <20070221153729.5eab83b6@lxorguk.ukuu.org.uk>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	<20061217040222.GD17561@ftp.linux.org.uk>
	<20070211101537.e40fa309.komurojun-mbn@nifty.com>
	<20070211114013.65b2be2c.komurojun-mbn@nifty.com>
	<20070218110914.888de729.komurojun-mbn@nifty.com>
	<20070221153729.5eab83b6@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alan <alan@lxorguk.ukuu.org.uk> wrote:

The oops is fixed. Thanks!

But when I repeat insertion/rejection of the device,
ataX.00 is incremented.
Is this correct?

>pccard: PCMCIA card inserted into slot 1
>pccard: card ejected from slot 1
>ata1.00: disabled
>
>pccard: PCMCIA card inserted into slot 1
>pccard: card ejected from slot 1
>ata2.00: disabled
>
>pccard: PCMCIA card inserted into slot 1
>pccard: card ejected from slot 1
>ata3.00: disabled

Best Regards
Komuro

> Does this fix the oops ?
> 
> Alan
> 
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_pcmcia.c linux-2.6.20-mm2/drivers/ata/pata_pcmcia.c
> --- linux.vanilla-2.6.20-mm2/drivers/ata/pata_pcmcia.c	2007-02-20 13:37:58.000000000 +0000
> +++ linux-2.6.20-mm2/drivers/ata/pata_pcmcia.c	2007-02-21 14:06:58.792707976 +0000
> @@ -308,7 +342,6 @@
>  		if (info->ndev) {
>  			struct ata_host *host = dev_get_drvdata(dev);
>  			ata_host_detach(host);
> -			dev_set_drvdata(dev, NULL);
>  		}
>  		info->ndev = 0;
>  		pdev->priv = NULL;
> 
> 
> 
