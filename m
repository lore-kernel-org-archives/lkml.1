Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYAOAak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYAOAak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 19:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYAOAab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 19:30:31 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:54718 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750982AbYAOAa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 19:30:29 -0500
Date: Tue, 15 Jan 2008 09:29:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom CDROM drive on SEGA Dreamcast
Message-ID: <20080115002958.GA27597@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-sh <linux-sh@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1200007549.6349.16.camel@localhost.localdomain> <1200088609.6213.3.camel@localhost.localdomain> <20080112053630.0ccb290e.akpm@linux-foundation.org> <1200351607.6196.4.camel@localhost.localdomain> <1200352635.6196.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200352635.6196.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 11:17:15PM +0000, Adrian McMenamin wrote:
> +/* GD Rom registers */
> +#define GDROM_BASE_REG 			0xA05F7000
> +#define GDROM_ALTSTATUS_REG 		(GDROM_BASE_REG + 0x18)
> +#define GDROM_DATA_REG 			(GDROM_BASE_REG + 0x80)
> +#define GDROM_ERROR_REG 		(GDROM_BASE_REG + 0x84)
> +#define GDROM_INTSEC_REG 		(GDROM_BASE_REG + 0x88)
> +#define GDROM_SECNUM_REG 		(GDROM_BASE_REG + 0x8C)
> +#define GDROM_BCL_REG  			(GDROM_BASE_REG + 0x90)
> +#define GDROM_BCH_REG 			(GDROM_BASE_REG + 0x94)
> +#define GDROM_DSEL_REG 			(GDROM_BASE_REG + 0x98)
> +#define GDROM_STATUSCOMMAND_REG 	(GDROM_BASE_REG + 0x9C)
> +#define GDROM_RESET_REG 		(GDROM_BASE_REG + 0x4E4)
> +
> +#define GDROM_DMA_STARTADDR_REG 	(GDROM_BASE_REG + 0x404)
> +#define GDROM_DMA_LENGTH_REG 		(GDROM_BASE_REG + 0x408)
> +#define GDROM_DMA_DIRECTION_REG 	(GDROM_BASE_REG + 0x40C)
> +#define GDROM_DMA_ENABLE_REG 		(GDROM_BASE_REG + 0x414)
> +#define GDROM_DMA_STATUS_REG 		(GDROM_BASE_REG + 0x418)
> +#define GDROM_DMA_WAIT_REG 		(GDROM_BASE_REG + 0x4A0)
> +#define GDROM_DMA_ACCESS_CTRL_REG 	(GDROM_BASE_REG + 0x4B8)
> +

Almost all of these are whitespace damaged. checkpatch doesn't seem to
catch them, but that's checkpatch's problem.

If your editor has no way of flagging whitespace damage in a visible
fashion, you may wish to consider replacing it with something that isn't
crap.

With vim you can use something like 'let c_space_errors=1' to see these.

> +static bool gdrom_data_request(void)
> +{
> + 	return (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) == 8;
> +}
> +
Andrew first pointed this out, and this is still broken. Additionally,
checkpatch _does_ complain about this:

ERROR: use tabs not spaces
#202: FILE: drivers/cdrom/gdrom.c:146:
+ ^Ireturn (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) == 8;$

ERROR: use tabs not spaces
#230: FILE: drivers/cdrom/gdrom.c:174:
+ ^I * been hit by a serious failure - but we'll$

ERROR: use tabs not spaces
#231: FILE: drivers/cdrom/gdrom.c:175:
+ ^I * try to return a sense key even so */$

ERROR: use tabs not spaces
#497: FILE: drivers/cdrom/gdrom.c:441:
+ ^I * the sense key if possible */$

ERROR: use tabs not spaces
#517: FILE: drivers/cdrom/gdrom.c:461:
+ ^I^Iprintk(KERN_ERR "GDROM: Unknown sense key: %d\n", sense_key);$

ERROR: use tabs not spaces
#680: FILE: drivers/cdrom/gdrom.c:624:
+ ^I^I * before handling ending the request */$

ERROR: use tabs not spaces
#692: FILE: drivers/cdrom/gdrom.c:636:
+ ^I * and then schedule workqueue */$

ERROR: use tabs not spaces
#764: FILE: drivers/cdrom/gdrom.c:708:
+ ^I * Bits 31 - 16 security: 0x8843$

ERROR: use tabs not spaces
#765: FILE: drivers/cdrom/gdrom.c:709:
+ ^I * Bits 15 and 7 reserved (0)$

ERROR: use tabs not spaces
#766: FILE: drivers/cdrom/gdrom.c:710:
+ ^I * Bits 14 - 8 start of transfer range in 1 MB blocks OR'ed with 0x80$

ERROR: trailing whitespace
#767: FILE: drivers/cdrom/gdrom.c:711:
+ ^I * Bits 6 - 0 end of transfer range in 1 MB blocks OR'ed with 0x80 $

ERROR: use tabs not spaces
#767: FILE: drivers/cdrom/gdrom.c:711:
+ ^I * Bits 6 - 0 end of transfer range in 1 MB blocks OR'ed with 0x80 $

ERROR: use tabs not spaces
#768: FILE: drivers/cdrom/gdrom.c:712:
+ ^I * (0x40 | 0x80) = start range at 0x0C000000$

ERROR: use tabs not spaces
#769: FILE: drivers/cdrom/gdrom.c:713:
+ ^I * (0x7F | 0x80) = end range at 0x0FFFFFFF */$

WARNING: line over 80 characters
#873: FILE: drivers/cdrom/gdrom.c:817:
+	printk(KERN_WARNING "GDROM: Could not probe for device - error is 0x%X\n", err);

All of these seem to stem from the fact that your editor is misconfigured
or broken. Please fix all of these and resubmit.

> +static int __devinit probe_gdrom(struct platform_device *devptr)
> +{
[snip]

> +}
> +
> +static int remove_gdrom(struct platform_device *devptr)
> +{
> +	flush_scheduled_work();
> +	blk_cleanup_queue(gd.gdrom_rq);
> +	free_irq(HW_EVENT_GDROM_CMD, &gd);
> +	free_irq(HW_EVENT_GDROM_DMA, &gd);
> +	del_gendisk(gd.disk);
> +	if (gdrom_major)
> +		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
> +	return unregister_cdrom(gd.cd_info);
> +}
> +
> +static struct platform_driver gdrom_driver = {
> +	.probe = probe_gdrom,
> +	.remove = remove_gdrom,
> +	.driver = {
> +			.name = GDROM_DEV_NAME,
> +	},
> +};
> +
Well, you're half-way there. You've got probe_gdrom() as __devinit, now
remove_gdrom() needs to be __devexit, and you can wrap around it with
__devexit_p() in the gdrom_driver definition.
