Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYIGT0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYIGT0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 15:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbYIGT0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 15:26:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37580 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbYIGT0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 15:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=PCKAVeDEtOui8O3QPWihey3g54jlZSHotrlFqZLKhQrUo5KQ80hzJFAtv1TD3JZ8sZ
         g8Nz+0sy2VfuTEsRKGvZI9E+XBPAqOCG2rZeFxBvpTfhQV6cbm9eB1ksKTIKn6Ayv8Nv
         jf9b4W5gmWGEiXzEM5AW4upBUZ6WTVf2GXyPA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 01/18] ide: add ->read_sff_dma_status method
Date: Sun, 7 Sep 2008 21:23:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <200809032013.08489.bzolnier@gmail.com> <48C41A2E.8040907@ru.mvista.com>
In-Reply-To: <48C41A2E.8040907@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809072123.33695.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 September 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>> static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
> >>> {
> >>> 	ide_hwif_t *hwif = drive->hwif;
> >>>@@ -323,6 +331,8 @@ static void ata_output_data(ide_drive_t 
> >>> 
> >>> void default_hwif_transport(ide_hwif_t *hwif)
> >>> {
> >>>+	hwif->read_sff_dma_status = ide_read_sff_dma_status;
> >>>+
> >>> 	hwif->tf_load	  = ide_tf_load;
> >>> 	hwif->tf_read	  = ide_tf_read;
> >>
> >>    I also didn't understand the motivation behind putting this method 
> >>together with the transport operations... IMO, DMA programming interface 
> >>hardly has anything to do with transporting the data over IDE bus.
> 
> > The motivation was that hwif->dma_ops is not available yet when
> > ->read_sff_dma_status is used in ide_pci_check_simplex().
> 
> > However I agree that it should somehow find its way into ->dma_ops
> > (as usual patches are stongly preffered :).
> 
>     Unless I'm missing something changing the place where hwif->dma_ops is 
> initialized to sff_dma_ops (along the lines it was changed for hwif->dma_base) 
> seems pretty trivial, so I wonder why you didn't do it in the same patch...

Indeed, it should be trivial now, one just needs to be careful to:

* move 'if (d->dma_ops) ...' from ide_init_port() into
  ->init_dma/ide_hwif_setup_dma()

* unset ->dma_ops on ->init_dma/ide_hwif_setup_dma() failures

I guess I overlooked it ATM of making the patch (or the code evolved
greatly in the meantime)...

[ It is really time consuming and difficult to recall the every small
  detail of every patch after few months (the patch was posted 10 weeks
  ago and merged 6 weeks ago)...  The most efficient way of handling
  such issues upon discovery is with sending patches... ]

Thanks,
Bart
