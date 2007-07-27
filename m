Return-Path: <linux-kernel-owner+w=401wt.eu-S965558AbXG0Xm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbXG0Xm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965154AbXG0XmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:42:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45803 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965139AbXG0XmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:42:16 -0400
Date: Fri, 27 Jul 2007 18:42:14 -0500
To: linux-kernel@vger.kernel.org
Subject: ATA scsi driver misbehavior under kdump capture kernel
Message-ID: <46AA82D6.mailxB9W1BQ61V@eag09.americas.sgi.com>
User-Agent: nail 11.4 8/29/04
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




I've run into a problem with the ATA SCSI disk driver when running in a
kdump dump-capture kernel.

I'm running on 2-processor x86_64 box.  It has 2 scsi disks, /dev/sda and
/dev/sdb

My kernel is 2.6.22, and built to be a dump capturing kernel loaded by kexec.
When I boot this kernel by itself, it finds both sda and sdb.

But when it is loaded by kexec and booted on a panic it only finds sda.

Any ideas from those familiar with the ATA driver?


-Cliff Wickman
 SGI



I put some printk's into it and get this:

Standalone:

                                                   [nv_adma_error_handler]
cpw: ata_host_register probe port 1 (error_handler:ffffffff81348625)
cpw: ata_host_register call ata_port_probe
cpw: ata_host_register call ata_port_schedule
cpw: ata_host_register call ata_port_wait_eh
cpw: ata_port_wait_eh entered
cpw: ata_port_wait_eh, preparing to wait
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
cpw: ata_dev_configure entered
cpw: ata_dev_configure testing class
cpw: ata_dev_configure class is ATA_DEV_ATA
ata2.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
ata2.00: 390721968 sectors, multi 16: LBA48
cpw: ata_dev_configure exiting
cpw: ata_dev_configure entered
cpw: ata_dev_configure testing class
cpw: ata_dev_configure class is ATA_DEV_ATA
cpw: ata_dev_configure exiting
cpw: ata_dev_set_mode printing:
ata2.00: configured for UDMA/133
cpw: ata_port_wait_eh, finished wait
cpw: ata_port_wait_eh exiting
cpw: ata_host_register done with probe port 1


When loaded with kexec and booted on a panic:

cpw: ata_host_register probe port 1 (error_handler:ffffffff81348625)
cpw: ata_host_register call ata_port_probe
cpw: ata_host_register call ata_port_schedule
cpw: ata_host_register call ata_port_wait_eh
cpw: ata_port_wait_eh entered
cpw: ata_port_wait_eh, preparing to wait
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
cpw: ata_port_wait_eh, finished wait
cpw: ata_port_wait_eh exiting
cpw: ata_host_register done with probe port 1

