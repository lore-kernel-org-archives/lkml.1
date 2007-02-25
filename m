Return-Path: <linux-kernel-owner+w=401wt.eu-S933635AbXBYCoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbXBYCoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 21:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933638AbXBYCoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 21:44:24 -0500
Received: from userg500.nifty.com ([202.248.238.80]:30119 "EHLO
	userg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933635AbXBYCoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 21:44:23 -0500
DomainKey-Signature: a=rsa-sha1; s=userg500; d=nifty.com; c=nofws; q=dns;
	b=KiSHxmVtCTSveXZa5EYRPMDwJaegPwz2hnCXm9fShLvq0cV1rZBm17FSaWeFMBCNE
	kMR7OR6kPi84IcYuVCpKA==
Date: Sun, 25 Feb 2007 11:43:48 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG]  PATA_PCMCIA does not work
Message-Id: <20070225114348.26b32671.komurojun-mbn@nifty.com>
In-Reply-To: <45E0EA2E.5050004@garzik.org>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	<20061217040222.GD17561@ftp.linux.org.uk>
	<20070211101537.e40fa309.komurojun-mbn@nifty.com>
	<20070211114013.65b2be2c.komurojun-mbn@nifty.com>
	<20070218110914.888de729.komurojun-mbn@nifty.com>
	<20070221153729.5eab83b6@lxorguk.ukuu.org.uk>
	<20070225081407.8ebce421.komurojun-mbn@nifty.com>
	<45E0EA2E.5050004@garzik.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007 20:45:18 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Any chance you could insert some printk() calls into ata_apci_exec_tfs? 
>   ata_exec_internal_sg() never calls that function, so I'm curious if 
> something corrupted memory a bit, or what happened.

I insert some printk().
I think the problem is happening on do_drive_get_GTF.


>pcmcia: registering new device pcmcia0.0
>SCSI subsystem initialized
>libata version 2.10 loaded.
>ata1: PATA max PIO0 cmd 0x00010100 ctl 0x0001010e bmdma 0x00000000 irq 4
>scsi0 : pata_pcmcia
>ata_acpi_exec_tfs 0  
>ata_acpi_exec_tfs 1  
>BUG: unable to handle kernel NULL pointer dereference at virtual address 0000004d
> printing eip:
>
>
>int ata_acpi_exec_tfs(struct ata_port *ap)
>{
>	int		ix;
>	int		ret =0;
>	unsigned int	gtf_length;
>	unsigned long	gtf_address;
>	unsigned long	obj_loc;
>
>	if (noacpi)
>		return 0;
>
>	for (ix = 0; ix < ATA_MAX_DEVICES; ix++) {
>		printk("ata_acpi_exec_tfs 0  \n");
>		if (!ata_dev_enabled(&ap->device[ix]))
>			continue;
>
>		printk("ata_acpi_exec_tfs 1  \n");
>		ret = do_drive_get_GTF(ap, ix,
>				&gtf_length, &gtf_address, &obj_loc);
>		printk("ata_acpi_exec_tfs 2  \n");
>		if (ret < 0) {

Best Regards
Komuro
