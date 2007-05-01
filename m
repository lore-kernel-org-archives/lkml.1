Return-Path: <linux-kernel-owner+w=401wt.eu-S1031180AbXEANSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031180AbXEANSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031227AbXEANSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:18:21 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:42686 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031180AbXEANSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:18:20 -0400
Date: Tue, 1 May 2007 09:18:18 -0400
From: William Thompson <wt@electro-mechanical.com>
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: 2.6.20 libata cdrom
Message-ID: <20070501131818.GA18521@electro-mechanical.com>
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com> <4636C2C7.8090206@gmail.com> <20070501121703.GH5942@electro-mechanical.com> <46373AEE.6070908@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46373AEE.6070908@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 09:04:46AM -0400, Mark Lord wrote:
> William Thompson wrote:
> >
> >+scsi2 : ata_piix
> >+ata_port_schedule_eh: port EH scheduled
> >+ata_scsi_error: ENTER
> >+ata_port_flush_task: ENTER
> >+ata_port_flush_task: flush #1
> >+ata2: ata_port_flush_task: flush #2
> >+ata2: ata_port_flush_task: EXIT
> >+ata_eh_autopsy: ENTER
> >+ata_eh_recover: ENTER
> >+ata_eh_prep_resume: ENTER
> >+ata_eh_prep_resume: EXIT
> >+__ata_port_freeze: ata2 port frozen
> >+ata_std_softreset: ENTER
> >+ata_std_softreset: about to softreset, devmask=1
> >+ata_bus_softreset: ata2: bus reset via SRST
> >+ata_dev_classify: found ATA device by sig
> >+ata_dev_classify: unknown device
> >+ata_std_softreset: EXIT, classes[0]=1 [1]=5
> >+ata_std_postreset: ENTER
> >+ata_std_postreset: EXIT
> >+ata_eh_thaw_port: ata2 port thawed
> >+ata_eh_revalidate_and_attach: ENTER
> >+ata2.00: ata_dev_read_id: ENTER, host 2, dev 0
> >+ata_exec_command_pio: ata2: cmd 0xEC
> >+ata_hsm_move: ata2: protocol 2 task_state 1 (dev_stat 0x51)
> >+ata_hsm_move: ata2: protocol 2 task_state 3 (dev_stat 0x51)
> >+ata_port_flush_task: ENTER
> >+ata_port_flush_task: flush #1
> >+ata2: ata_port_flush_task: flush #2
> >+ata2: ata_port_flush_task: EXIT
> >+ata2.00: failed to IDENTIFY (I/O error, err_mask=0x1)
> >+ata_eh_revalidate_and_attach: EXIT
> ..
> 
> Yep.  Libata seems to be treating the ATAPI drive as ATA.
> 
> Tejun, don't we have a fallback for when IDENTIFY fails?
> If the drive rejects it (err=0x04), then this can mean only one thing:
> unsupported command, so we next must try PACKET_IDENTIFY.

Is it doing that just for this drive?  I use libata on another machine (Dell
Dimension 2400) and it finds the cdrom just fine.

The one thing I do know, the machine with the non-working libata cdrom also
does not work with the ide driver *ONLY IF* DMA is turned on.
