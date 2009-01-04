Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZADVNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZADVNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZADVN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:13:27 -0500
Received: from homer.mvista.com ([63.81.120.155]:38638 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751893AbZADVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:13:26 -0500
Message-ID: <4961266E.9000505@ru.mvista.com>
Date: Mon, 05 Jan 2009 00:13:18 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Kirill Smelkov <kirr@mns.spb.ru>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kirr@landau.phys.spbu.ru,
       Dmitry Gryazin <gdu@mns.spb.ru>
Subject: Re: [PATCH] ide: motherboard-info based blacklist for ide-dma
References: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru> <495A4CC0.6000000@ru.mvista.com> <200812312012.46496.bzolnier@gmail.com> <49611CF4.9030103@ru.mvista.com>
In-Reply-To: <49611CF4.9030103@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>>      drive->hwif->dma_ops->dma_host_set(drive, 1);
>>>>  }
>>>>  
>>>> +static int __ide_dma_bad_adaptor(ide_drive_t *drive)
>>>> +{
>>>> +    const struct board_blacklist_entry *table = board_blacklist;
>>>> +
>>>> +    const char *board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
>>>> +    const char *board_name   = dmi_get_system_info(DMI_BOARD_NAME);
>>>> +
>>>> +    if (!board_vendor || !board_name)
>>>> +        return 0;
>>>> +
>>>> +    for ( ; table->board_name ; table++)
>>>> +        if ((!strcmp(board_vendor, table->board_vendor)) &&
>>>> +            (!strcmp(board_name,   table->board_name))   &&
>>>> +            (!strcmp(drive->name,  table->drive_name))) {
>>>> +            printk(KERN_WARNING "%s: Disabling (U)DMA for %s "
>>>> +                "(Board %s %s is blacklisted)\n", drive->name,
>>>> +                (char *)&drive->id[ATA_ID_PROD], board_vendor,
>>>> +                board_name);
>>>> +            return 1;
>>>> +        }
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>>       
>>>     This code doesn't anyhow discriminate the case of on-board CF 
>>> and say     
> @@ -207,6 +222,30 @@ void ide_dma_on(ide_drive_t *drive)
>
>   Hm, previously I failed to notice that the patch tries to 
> discriminate this case based on applying the workaround only to the 
> drive with certain name ("hdc"). However, it still seems wrong to 
> place this workaround in __ide_dma_bad_drive() as it's not actually 
> connected to the deficiency of a specific drive but to the definciency 
> of the CF slot itself. Moreover, depending on the PCI cards plugged, 
> the drive's name may change...

   Oh, and the master/slave mode of the CF drive is selectable by 
on-board switch -- via the -CSEL signal I guess. :-)

MBR, Sergei


