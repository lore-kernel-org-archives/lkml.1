Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbXEASAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbXEASAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbXEASAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:00:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:11359 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbXEASAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=E6iHRgmWp0Pmr0SehvQ1ry6o6jN3Gcmxtm8DaHLoA58YnQJJbHJC2k/MLg+kXcIB+hZbD+cAB2Wt9xeUl37oR38Ra5PBTobyNND1CGOmAf/7cKRphsQHCwZPlZ3H0frz40Ft36j1KuTTabJ8Azi2SjSlzRf1CGCZG7qrH3Y9b4Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: William Thompson <wt@electro-mechanical.com>
Subject: Re: 2.6.20 libata cdrom
Date: Tue, 1 May 2007 20:11:50 +0200
User-Agent: KMail/1.9.6
Cc: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
References: <20070427175205.GD7809@electro-mechanical.com> <46373AEE.6070908@rtr.ca> <20070501131818.GA18521@electro-mechanical.com>
In-Reply-To: <20070501131818.GA18521@electro-mechanical.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705012011.50772.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 01 May 2007, William Thompson wrote:
> On Tue, May 01, 2007 at 09:04:46AM -0400, Mark Lord wrote:
> > William Thompson wrote:
> > >
> > >+scsi2 : ata_piix
> > >+ata_port_schedule_eh: port EH scheduled
> > >+ata_scsi_error: ENTER
> > >+ata_port_flush_task: ENTER
> > >+ata_port_flush_task: flush #1
> > >+ata2: ata_port_flush_task: flush #2
> > >+ata2: ata_port_flush_task: EXIT
> > >+ata_eh_autopsy: ENTER
> > >+ata_eh_recover: ENTER
> > >+ata_eh_prep_resume: ENTER
> > >+ata_eh_prep_resume: EXIT
> > >+__ata_port_freeze: ata2 port frozen
> > >+ata_std_softreset: ENTER
> > >+ata_std_softreset: about to softreset, devmask=1
> > >+ata_bus_softreset: ata2: bus reset via SRST
> > >+ata_dev_classify: found ATA device by sig
> > >+ata_dev_classify: unknown device
> > >+ata_std_softreset: EXIT, classes[0]=1 [1]=5
> > >+ata_std_postreset: ENTER
> > >+ata_std_postreset: EXIT
> > >+ata_eh_thaw_port: ata2 port thawed
> > >+ata_eh_revalidate_and_attach: ENTER
> > >+ata2.00: ata_dev_read_id: ENTER, host 2, dev 0
> > >+ata_exec_command_pio: ata2: cmd 0xEC
> > >+ata_hsm_move: ata2: protocol 2 task_state 1 (dev_stat 0x51)
> > >+ata_hsm_move: ata2: protocol 2 task_state 3 (dev_stat 0x51)
> > >+ata_port_flush_task: ENTER
> > >+ata_port_flush_task: flush #1
> > >+ata2: ata_port_flush_task: flush #2
> > >+ata2: ata_port_flush_task: EXIT
> > >+ata2.00: failed to IDENTIFY (I/O error, err_mask=0x1)
> > >+ata_eh_revalidate_and_attach: EXIT
> > ..
> > 
> > Yep.  Libata seems to be treating the ATAPI drive as ATA.
> > 
> > Tejun, don't we have a fallback for when IDENTIFY fails?
> > If the drive rejects it (err=0x04), then this can mean only one thing:
> > unsupported command, so we next must try PACKET_IDENTIFY.
> 
> Is it doing that just for this drive?  I use libata on another machine (Dell
> Dimension 2400) and it finds the cdrom just fine.
> 
> The one thing I do know, the machine with the non-working libata cdrom also
> does not work with the ide driver *ONLY IF* DMA is turned on.

Please give 2.6.21 kernel w/ IDE subsystem and DMA enabled a try
(2.6.21 kernel contains some important updates for both piix IDE driver
and DMA tuning code).

Also there is a newer firmware for this drive (PD03, your drive uses PD02),
although the changelog doesn't say anything about DMA problems it wouldn't
hurt to give it a try:

http://support.us.dell.com/support/downloads/download.aspx?c=us&l=en&s=gen&releaseid=R20664&formatcnt=1&libid=0&fileid=20516

Thanks,
Bart
