Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYIGSOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYIGSOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 14:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYIGSOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 14:14:34 -0400
Received: from h155.mvista.com ([63.81.120.155]:17718 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754561AbYIGSOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 14:14:33 -0400
Message-ID: <48C41A2E.8040907@ru.mvista.com>
Date: Sun, 07 Sep 2008 22:15:10 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] ide: add ->read_sff_dma_status method
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <48BE8EFD.70103@ru.mvista.com> <200809032013.08489.bzolnier@gmail.com>
In-Reply-To: <200809032013.08489.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>> static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
>>> {
>>> 	ide_hwif_t *hwif = drive->hwif;
>>>@@ -323,6 +331,8 @@ static void ata_output_data(ide_drive_t 
>>> 
>>> void default_hwif_transport(ide_hwif_t *hwif)
>>> {
>>>+	hwif->read_sff_dma_status = ide_read_sff_dma_status;
>>>+
>>> 	hwif->tf_load	  = ide_tf_load;
>>> 	hwif->tf_read	  = ide_tf_read;
>>
>>    I also didn't understand the motivation behind putting this method 
>>together with the transport operations... IMO, DMA programming interface 
>>hardly has anything to do with transporting the data over IDE bus.

> The motivation was that hwif->dma_ops is not available yet when
> ->read_sff_dma_status is used in ide_pci_check_simplex().

> However I agree that it should somehow find its way into ->dma_ops
> (as usual patches are stongly preffered :).

    Unless I'm missing something changing the place where hwif->dma_ops is 
initialized to sff_dma_ops (along the lines it was changed for hwif->dma_base) 
seems pretty trivial, so I wonder why you didn't do it in the same patch...
    Hm, I guess I'm seeing a real issue with this patch...

> Thanks,
> Bart

MBR, Sergei
