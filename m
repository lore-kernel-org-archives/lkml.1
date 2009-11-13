Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZKMQQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZKMQQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbZKMQQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:16:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:12678 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144AbZKMQQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:16:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=DqN5rt+2kwqr5rP4VApSoNW1ccqkhNQ5JnmxVJVhWoDwXEwEilyWl2ci8o3VQkSzNW
         YgiQfXP5vY7RlekbfoHD6U4s3f13wdo/wYHXx6GepoDC6yb5UWHgEuqr1mUTLuc9PyBr
         HH6xoD7WAZxSfprjkuyYapon5nowj4R9mtOSI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Date: Fri, 13 Nov 2009 17:15:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
References: <4AFCC0D4.9020708@gmail.com>
In-Reply-To: <4AFCC0D4.9020708@gmail.com>
MIME-Version: 1.0
Message-Id: <200911131715.24377.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009 03:13:40 Robert Hancock wrote:
> Remove the experimental tag on Parallel ATA drivers. Though some of the
> individual PATA drivers are still marked as experimental, as a group they can
> hardly be considered to be, given they've been used in various distros for some
> time.
> 
> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

Fine but please update status of following host drivers that were
marked as "stable" prematurely by commit e3389cb first:

PATA_PDC_OLD: needs to be marked as EXPERIMENTAL (or just BROKEN)
- known reliability problems with UDMA

PATA_ALI: EXPERIMENTAL
- ATAPI DMA is still broken

PATA_CMD64X: EXPERIMENTAL
- potential data corruption issues remains unfixed for CMD64[3,6]

PATA_SIS: EXPERIMENTAL
- missing MWDMA support on newer controllers

They are all old & known problems and not present in
[ "old", "deprecated", "legacy" ] counterparts.

> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index f2df6e2..33133c6 100644
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

-- 
Bartlomiej Zolnierkiewicz
