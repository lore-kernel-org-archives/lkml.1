Return-Path: <linux-kernel-owner+w=401wt.eu-S1030481AbXBGAyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030481AbXBGAyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030485AbXBGAyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:54:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:6604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030481AbXBGAye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aDisLeZUherLbAeQ2YadiU3ojY2fGaTHQu0QK8JBc8WXWrUy3Lnv8GZ0Fa4Iw3ECcy4hUyaguXyyLlzd9KTkGhthNCdRspHYDNL8Vub4Uo87pWxaTlVT0Y0xDBoIIFO3u3efU+5DQ8RPv6SahNI+BWvSTNVMjqRJjxw/4H4T5bo=
Message-ID: <6bffcb0e0702061654x4ed237c1mdb619b9ab513283c@mail.gmail.com>
Date: Wed, 7 Feb 2007 01:54:32 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [QUESTION] ATA: abnormal status 0x80 on port 0xCC07
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <6bffcb0e0702061557r2ba51186ra33a428e1a1f051@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0702031044v601e4fc3icf859544af292789@mail.gmail.com>
	 <45C8EAAD.5000905@googlemail.com>
	 <6bffcb0e0702061557r2ba51186ra33a428e1a1f051@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> On 06/02/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
[..]
> > I'll revert this patch.
> >
> > commit 7a0f1c8a4b1052da7efc7715e2e557255b632712
> > Author: Lennert Buytenhek <buytenh@wantstofly.org>
> > Date:   Mon Jan 29 13:28:47 2007 +0100
> >
> >     ata_if_xfermask() word 51 fix
> >
> >     If word 53 bit 1 isn't set, the maximum PIO mode is indicated by
> >     the upper 8 bits of word 51, not the lower 8 bits.  Fixes PIO mode
> >     detection on old Compact Flash cards.
> >
> >     Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
> >     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> >
>
> It's not this patch. Maybe this one?
>
> commit 49c8042996c84f0df6c49ea2e28a7ef38cd7d773
> Author: Brian King <brking@linux.vnet.ibm.com>
> Date:   Tue Jan 30 11:32:26 2007 -0600
>
>     libata: Initialize nbytes for internal sg commands
>
>     Some LLDDs, like ipr, use nbytes and pad_len to determine
>     the total data transfer length of a command. Make sure
>     nbytes gets initialized for internally generated commands.
>
>     Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index cf70702..667acd2 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -1250,6 +1250,7 @@ unsigned ata_exec_internal_sg(struct ata
>
>                 ata_sg_init(qc, sg, n_elem);
>                 qc->nsect = buflen / ATA_SECT_SIZE;
> +               qc->nbytes = buflen;
>         }
>
>         qc->private_data = &wait;
>
> It has something to do with SCSI commands.

Kernel still hangs...

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
