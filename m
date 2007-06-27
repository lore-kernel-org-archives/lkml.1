Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbXF0Tz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbXF0Tz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbXF0TzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:55:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:43158 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbXF0TzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=K5e5hsi5r7dz40XCsXM42Pc14cChv7plnGKjYg1N+BotNd8MuQIBr6E4Q4dZVfbI2LVoJ0OfcX2SHVgr2DajQnOQ/gXrwaPmn3Zj/lb4AGaQu/hycax/rqp53c+e0IWE9GAvS+HnE3gnT37sHtUyB+y/Oy1O7louc1AUAykOCX4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/5] piix: backport short cables support from ata_piix.c
Date: Wed, 27 Jun 2007 21:13:33 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200706101558.14511.bzolnier@gmail.com> <46815B44.1040609@ru.mvista.com>
In-Reply-To: <46815B44.1040609@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706272113.33261.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > Backport short cables support from ata_piix.c.
> 
> > This patch should allow UDMA > 2 modes on:
> > - Acer 5602WLMi
> > - Acer 3682WLMi
> > - Asus W5F
> > - Acer Aspire 2023WLMi
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

Added (as well as ACKs for patches #3-5 of this series).

>     Minor nit here:
> 
> > Index: b/drivers/ide/pci/piix.c
> > ===================================================================
> > --- a/drivers/ide/pci/piix.c
> > +++ b/drivers/ide/pci/piix.c
> > @@ -394,12 +394,43 @@ static void piix_dma_clear_irq(ide_drive
> [...]
> >  static u8 __devinit piix_cable_detect(ide_hwif_t *hwif)
> >  {
> > -	struct pci_dev *dev = hwif->pci_dev;
> > +	struct pci_dev *pdev = hwif->pci_dev;
> 
>     Unnecessary rename.
> 
> > +	const struct ich_laptop *lap = &ich_laptop[0];
> 
>     ... and & and [0] are superfluous with arrays -- they behave like pointers 
> in expression.

I was blinded by libata code... ;)

Bart
