Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbXG1Tuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbXG1Tuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 15:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbXG1Tup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 15:50:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:37810 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751513AbXG1Tuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 15:50:44 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+3de1uTt+3VaaB8vCoqHnApAURFo6te2XzQTHnpK
	o2VIBFjkAw5q+d
Date: Sat, 28 Jul 2007 21:50:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Cliff Wickman <cpw@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: ATA scsi driver misbehavior under kdump capture kernel
In-Reply-To: <46AA82D6.mailxB9W1BQ61V@eag09.americas.sgi.com>
Message-ID: <Pine.LNX.4.60.0707282149450.4440@poirot.grange>
References: <46AA82D6.mailxB9W1BQ61V@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007, Cliff Wickman wrote:

> I've run into a problem with the ATA SCSI disk driver when running in a
> kdump dump-capture kernel.
> 
> I'm running on 2-processor x86_64 box.  It has 2 scsi disks, /dev/sda and
> /dev/sdb
> 
> My kernel is 2.6.22, and built to be a dump capturing kernel loaded by kexec.
> When I boot this kernel by itself, it finds both sda and sdb.
> 
> But when it is loaded by kexec and booted on a panic it only finds sda.
> 
> Any ideas from those familiar with the ATA driver?

No, just wanted to suggest to try to ask on kexec /fastboot seems to be 
deprecated) mailing list?

Thanks
Guennadi

> 
> 
> -Cliff Wickman
>  SGI
> 
> 
> 
> I put some printk's into it and get this:
> 
> Standalone:
> 
>                                                    [nv_adma_error_handler]
> cpw: ata_host_register probe port 1 (error_handler:ffffffff81348625)
> cpw: ata_host_register call ata_port_probe
> cpw: ata_host_register call ata_port_schedule
> cpw: ata_host_register call ata_port_wait_eh
> cpw: ata_port_wait_eh entered
> cpw: ata_port_wait_eh, preparing to wait
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> cpw: ata_dev_configure entered
> cpw: ata_dev_configure testing class
> cpw: ata_dev_configure class is ATA_DEV_ATA
> ata2.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
> ata2.00: 390721968 sectors, multi 16: LBA48
> cpw: ata_dev_configure exiting
> cpw: ata_dev_configure entered
> cpw: ata_dev_configure testing class
> cpw: ata_dev_configure class is ATA_DEV_ATA
> cpw: ata_dev_configure exiting
> cpw: ata_dev_set_mode printing:
> ata2.00: configured for UDMA/133
> cpw: ata_port_wait_eh, finished wait
> cpw: ata_port_wait_eh exiting
> cpw: ata_host_register done with probe port 1
> 
> 
> When loaded with kexec and booted on a panic:
> 
> cpw: ata_host_register probe port 1 (error_handler:ffffffff81348625)
> cpw: ata_host_register call ata_port_probe
> cpw: ata_host_register call ata_port_schedule
> cpw: ata_host_register call ata_port_wait_eh
> cpw: ata_port_wait_eh entered
> cpw: ata_port_wait_eh, preparing to wait
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> cpw: ata_port_wait_eh, finished wait
> cpw: ata_port_wait_eh exiting
> cpw: ata_host_register done with probe port 1
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski
