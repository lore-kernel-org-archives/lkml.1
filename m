Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbZGUHoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbZGUHoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 03:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbZGUHop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 03:44:45 -0400
Received: from smtp.nokia.com ([192.100.122.230]:22221 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZGUHoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 03:44:44 -0400
Message-ID: <4A6571A9.5070007@gmail.com>
Date: Tue, 21 Jul 2009 10:43:37 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       MTD mailing list <linux-mtd@lists.infradead.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] MTD:  Correct typo "MTD_DATAFLASH_VERIFY_WRITE".
References: <alpine.LFD.2.00.0907192115420.18015@localhost>
In-Reply-To: <alpine.LFD.2.00.0907192115420.18015@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Jul 2009 07:43:53.0882 (UTC) FILETIME=[FEF857A0:01CA09D6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems correct to me, I'll put it to l2-mtd-2.6.git, thanks.

CCint David who seem to introduced this in the following commit:

commit 8c64038e4c077b2b37c6b27d0c40c77a3ddfaeef
Author: David Brownell <dbrownell@users.sourceforge.net>
Date:   Wed Aug 6 21:55:14 2008 -0700

     [MTD] make dataflash write-verify be optional

     This adds a WRITE_VERIFY Kconfig option to the DataFlash driver,
     closely mirroring the similar NAND and ONENAND options, giving
     an option to disable some code that's currently always enabled.

     Removing this step probably saves a millisecond or so per page
     when writing data, which will add up quickly since these pages
     are small (the largest is 1 KiB).  It doesn't seem to add a
     lot in terms of reliability, and wouldn't detect errors which
     crop up when transferring data to the on-chip SRAM buffer.

     Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
     Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
     Acked-by: Andrew Victor <linux@maxim.org.za>
     Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

On 07/20/2009 04:19 AM, Robert P. J. Day wrote:
> Fix the misspelling to match the actual config variable defined in
> drivers/mtd/devi ces/Kconfig:
>
> config MTD_DATAFLASH_WRITE_VERIFY
>          bool "Verify DataFlash page writes"
>          depends on MTD_DATAFLASH
>
> Signed-off-by: Robert P. J. Day<rpjday@crashcourse.ca>
>
> ---
>
>    you know, there's a *reason* i keep reporting these anomalies...
>
> diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
> deleted file mode 100644
> index e69de29..0000000
> diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
> index 43976aa..70a7369 100644
> --- a/drivers/mtd/devices/mtd_dataflash.c
> +++ b/drivers/mtd/devices/mtd_dataflash.c
> @@ -401,7 +401,7 @@ static int dataflash_write(struct mtd_info *mtd, loff_t to, size_t len,
>   		(void) dataflash_waitready(priv->spi);
>
>
> -#ifdef CONFIG_MTD_DATAFLASH_VERIFY_WRITE
> +#ifdef CONFIG_MTD_DATAFLASH_WRITE_VERIFY
>
>   		/* (3) Compare to Buffer1 */
>   		addr = pageaddr<<  priv->page_offset;
> @@ -430,7 +430,7 @@ static int dataflash_write(struct mtd_info *mtd, loff_t to, size_t len,
>   		} else
>   			status = 0;
>
> -#endif	/* CONFIG_MTD_DATAFLASH_VERIFY_WRITE */
> +#endif	/* CONFIG_MTD_DATAFLASH_WRITE_VERIFY */
>
>   		remaining = remaining - writelen;
>   		pageaddr++;
>
> ========================================================================
> Robert P. J. Day                               Waterloo, Ontario, CANADA
>
>          Linux Consulting, Training and Annoying Kernel Pedantry.
>
> Web page:                                          http://crashcourse.ca
> Twitter:                                       http://twitter.com/rpjday
> "Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
> ========================================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
