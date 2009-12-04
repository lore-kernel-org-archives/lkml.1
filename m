Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbZLDSGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbZLDSGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:06:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932320AbZLDSGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:06:00 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:43380 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932311AbZLDSF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:05:59 -0500
Message-ID: <4B194FCE.60801@ru.mvista.com>
Date: Fri, 04 Dec 2009 21:07:10 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 84/86] libata: add ata_mwdma_to_pio() inline helper
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125171232.5446.28166.sendpatchset@localhost>
In-Reply-To: <20091125171232.5446.28166.sendpatchset@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] libata: add ata_mwdma_to_pio() inline helper

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

[...]

>  static struct ata_port_operations rdc_pata_ops = {
> Index: b/include/linux/ata.h
> ===================================================================
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -1012,4 +1012,15 @@ static inline int lba_48_ok(u64 block, u
>  #define sata_pmp_gscr_rev(gscr)		(((gscr)[SATA_PMP_GSCR_REV] >> 8) & 0xff)
>  #define sata_pmp_gscr_ports(gscr)	((gscr)[SATA_PMP_GSCR_PORT_INFO] & 0xf)
>  
> +/* returns PIO number matching given MWDMA mode */
> +static inline u8 ata_mwdma_to_pio(u8 mwdma_mode)
> +{
> +	unsigned int mwdma = mwdma_mode - XFER_MW_DMA_0;
> +	const unsigned int needed_pio[3] = {

    'u8' would have been enough.

> +		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
> +	};

    Er, perhaps this should be 'static' array?.. Intialization *auto* class 
arrays produces some real code... Also, why not simply {0, 3, 4}?

> +
> +	return needed_pio[mwdma] - XFER_PIO_0;
> +}
> +
>  #endif /* __LINUX_ATA_H__ */

MBR, Sergei
