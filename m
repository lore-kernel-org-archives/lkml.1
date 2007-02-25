Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbXBYBp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbXBYBp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 20:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933608AbXBYBp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 20:45:27 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58270 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932945AbXBYBp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 20:45:26 -0500
Message-ID: <45E0EA2E.5050004@garzik.org>
Date: Sat, 24 Feb 2007 20:45:18 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Komuro <komurojun-mbn@nifty.com>
CC: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG]  PATA_PCMCIA does not work
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>	<20061217040222.GD17561@ftp.linux.org.uk>	<20070211101537.e40fa309.komurojun-mbn@nifty.com>	<20070211114013.65b2be2c.komurojun-mbn@nifty.com>	<20070218110914.888de729.komurojun-mbn@nifty.com>	<20070221153729.5eab83b6@lxorguk.ukuu.org.uk> <20070225081407.8ebce421.komurojun-mbn@nifty.com>
In-Reply-To: <20070225081407.8ebce421.komurojun-mbn@nifty.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Komuro wrote:
> Hi,
> 
> The pata_pcmcia problem is fixed. Thanks!
> (I tested it on kernel 2.6.20-git14)
> 
> But kernel 2.6.20-mm2 introduced new oops
> when I insert the pata_pcmcia device.
> 
> 
> pcmcia: registering new device pcmcia1.0
> SCSI subsystem initialized
> libata version 2.10 loaded.
> ata1: PATA max PIO0 cmd 0x0001d100 ctl 0x0001d10e bmdma 0x00000000 irq 3
> scsi0 : pata_pcmcia
> BUG: unable to handle kernel NULL pointer dereference at virtual address 0000004d
>  printing eip:
> d8a1b10e
> *pde = 00000000
> Oops: 0000 [#1]
> last sysfs file: /block/hda/size
> Modules linked in: pata_pcmcia libata scsi_mod dm_mirror dm_multipath dm_mod pcmcia yenta_socket rsrc_nonstatic pcmcia_core
> CPU:    0
> EIP:    0060:[<d8a1b10e>]    Not tainted VLI
> EFLAGS: 00010296   (2.6.20-mm2 #1)
> EIP is at ata_acpi_exec_tfs+0x157/0x8ad [libata]
> eax: 00000001   ebx: 00000000   ecx: d6d43c84   edx: d6d43c84
> esi: d51f4514   edi: 00000000   ebp: d51f438c   esp: d6f2bcdc
> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Process scsi_eh_0 (pid: 1647, ti=d6f2a000 task=c13c9a70 task.ti=d6f2a000)
> Stack: d51f6190 00000246 00000246 00000000 d8a130b7 00000000 00000000 00000000 
>        00000000 d6f2bd48 d6f2bdf0 d51f4514 ec000000 d51f6190 00000000 00000000 
>        00000000 00000246 d6d43c84 00000000 00000000 00000000 00000000 ffffffff 
> Call Trace:
>  [<d8a130b7>] ata_exec_internal_sg+0x3ae/0x3b8 [libata]
>  [<d8a125f8>] ata_dev_configure+0xc1/0x7d2 [libata]
>  [<d8a10e87>] ata_dev_select+0xce/0x11a [libata]

Any chance you could insert some printk() calls into ata_apci_exec_tfs? 
  ata_exec_internal_sg() never calls that function, so I'm curious if 
something corrupted memory a bit, or what happened.

In any case, I'm surprised that ACPI would be executing taskfiles on 
PCMCIA anyway.

	Jeff



