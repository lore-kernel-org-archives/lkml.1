Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbYHIWk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbYHIWk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYHIWkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:40:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:53056 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYHIWkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=k4n6TN90qJCDOBz9uXTh/ICQSd46dsk2X/rMnhGSFIN07utnG8Y3WFqbsZA7ysXCt0
         AV9FMAKo+6FTkGY/9okvfOp8Hy+ryV9d/RB2e7zhu/BcvEnke6HYMG/y2aRChyKsGtTJ
         IQrM8Yg/KiUA1N8amZWtBDCRmLChbKJOULLmY=
Message-ID: <6101e8c40808091540x66b367b0hc2a64e5cde1a3aac@mail.gmail.com>
Date: Sun, 10 Aug 2008 00:40:12 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: [RFC PATCH] cleanup Serial ATA and Parallel ATA Kconfig
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       "Grant Coady" <gcoady.lk@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m3zlnm75u1.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808081228450.11491@localhost.localdomain>
	 <20080808172629.232bed01@lxorguk.ukuu.org.uk>
	 <njhp94pr4ha1nfgmj11n662enalpd9663h@4ax.com>
	 <m3sktfw1v5.fsf@maximus.localdomain>
	 <alpine.LFD.1.10.0808081911080.3254@localhost.localdomain>
	 <20080809103331.1d475d5c@lxorguk.ukuu.org.uk>
	 <m3zlnm75u1.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/08, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>
>> Alas it does not or we would have done so. A lot of the chips have things
>> like 'two SATA one PATA' and some of them have SATA and PATA variants of
>> the same chip. Then we have generic drivers like ata_generic which really
>> don't care if its SATA or PATA ..
>
> Then I would enable them if SATA _or_ PATA is selected. Something like
> the following. Then the driver list (one common list) could be sorted,
> ATA_SFF moved to the end etc.
>
> It complicates the Kconfig, I don't know if users' experience is worth
> it in the end.
>
> I'm not sure about IXP4XX_CF (compact flash) case, it's essentially
> PATA but the physical interface is a bit different and it may be
> confusing(?). Also not sure about Pacific Digital ADMA, is it
> PATA-only or both?
>
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -3,7 +3,7 @@
>  #
>
>  menuconfig ATA
> -	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
> +	tristate "Serial ATA and Parallel ATA drivers"
>  	depends on HAS_IOMEM
>  	depends on BLOCK
>  	depends on !(M32R || M68K) || BROKEN
> @@ -23,6 +23,21 @@ menuconfig ATA
>
>  if ATA
>
> +config ATA_PATA
> +	bool "Parallel ATA (PATA) support"
> +	depends on ATA
> +	help
> +	  Say Y here if you want support for Parallel ATA devices, previously
> +	  known as IDE. This also includes Compact Flash slots.
> +
> +config ATA_SATA
> +	bool "Serial ATA (SATA) support"
> +	depends on ATA
> +	help
> +	  Say Y here if you want support for Parallel ATA devices.

s/Parallel/Serial/

[...]

-- 
Thanks,
Oliver
