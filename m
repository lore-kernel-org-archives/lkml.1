Return-Path: <linux-kernel-owner+w=401wt.eu-S1031035AbXDXIDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031035AbXDXIDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031037AbXDXIDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:03:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46165 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031035AbXDXIDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:03:49 -0400
Date: Tue, 24 Apr 2007 09:07:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 1/7] libata: check for AN support
Message-ID: <20070424090713.65657495@the-village.bc.nu>
In-Reply-To: <20070423165943.0cc67bc5.kristen.c.accardi@intel.com>
References: <20070424074856.005152262@intel.com>
	<20070423165943.0cc67bc5.kristen.c.accardi@intel.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +		/*
> +		 * check to see if this ATAPI device supports
> +		 * Asynchronous Notification
> +		 */
> +		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_AN(id))
> +		{

Bracketing police ^^^

> +			/* issue SET feature command to turn this on */
> +			rc = ata_dev_set_AN(dev);
> +			if (rc) {
> +				ata_dev_printk(dev, KERN_ERR,
> +						"unable to set AN\n");
> +				rc = -EINVAL;
> +				goto err_out_nosup;

How fatal is this - do we need to ignore the device at this point or
should we just pretend (possibly correctly) that the device itself does
not support notification. 

> @@ -299,6 +305,8 @@ struct ata_taskfile {
>  #define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
>  #define ata_id_removeable(id)	((id)[0] & (1 << 7))
>  #define ata_id_has_dword_io(id)	((id)[50] & (1 << 0))
> +#define ata_id_has_AN(id)	\
> +	((id[76] && (~id[76])) & ((id)[78] & (1 << 5)))

Might be nice to check ATA version as well to be paranoid but this all
looks ok as its a reserved field since way back when.

