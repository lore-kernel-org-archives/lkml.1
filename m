Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbZLTBiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbZLTBiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 20:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZLTBix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 20:38:53 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:56288 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbZLTBiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 20:38:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19245.32800.949699.409703@pilspetsen.it.uu.se>
Date: Sun, 20 Dec 2009 02:38:40 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Jeff Garzik <jeff@garzik.org>
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: pata_cmd64x broken in 2.6.33-rc1 on sparc64
In-Reply-To: <4B2D54AC.3080509@garzik.org>
References: <alpine.SOC.1.00.0912200017540.17801@math.ut.ee>
	<4B2D54AC.3080509@garzik.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik writes:
 > On 12/19/2009 05:23 PM, Meelis Roos wrote:
 > > This running on Sun Ultra 5 with CMD646 onboard ide.
 > >
 > > scsi0 : pata_cmd64x
 > > scsi1 : pata_cmd64x
 > > ata1: PATA max MWDMA2 cmd 0x1fe02c00000 ctl 0x1fe02c00008 bmdma 0x1fe02c00020 irq 14
 > > ata2: PATA max MWDMA2 cmd 0x1fe02c00010 ctl 0x1fe02c00018 bmdma 0x1fe02c00028 irq 14
 > > pata_cmd64x: active 10 recovery 10 setup 3.
 > > pata_cmd64x: active 10 recovery 10 setup 3.
 > > PCI: Enabling device: (0000:01:01.1), cmd 2
 > > sunhme.c:v3.10 August 26, 2008 David S. Miller (davem@davemloft.net)
 > > eth0: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:f8:c7:72
 > > mice: PS/2 mouse device common for all mice
 > > ------------[ cut here ]------------
 > > WARNING: at drivers/ata/pata_cmd64x.c:268 cmd64x_bmdma_stop+0x3c/0x60()
 > > Modules linked in:
 > > Call Trace:
 > >   [000000000064987c] cmd64x_bmdma_stop+0x3c/0x60
 > >   [0000000000644610] ata_sff_post_internal_cmd+0x30/0x60
 > >   [0000000000635910] ata_exec_internal_sg+0x310/0x4e0
 > >   [0000000000635b30] ata_exec_internal+0x50/0x80
 > >   [0000000000635ddc] ata_do_dev_read_id+0x1c/0x40
 > >   [0000000000635fb0] ata_dev_read_id+0x1b0/0x5c0
 > >   [00000000006423a8] ata_eh_recover+0x5c8/0x1280
 > >   [0000000000643288] ata_do_eh+0x28/0xa0
 > >   [0000000000643e94] ata_scsi_error+0x374/0x600
 > >   [00000000006221ec] scsi_error_handler+0xcc/0x460
 > >   [000000000046fdc0] kthread+0x60/0x80
 > >   [000000000042b4b0] kernel_thread+0x30/0x60
 > >   [000000000046fd1c] kthreadd+0x9c/0xe0
 > > ---[ end trace 61a1d617a7f4a94d ]---
 > 
 > 
 > linux-ide CC added.
 > 
 > Does backing out the following commit fix things?
 > 
 > 	commit d43744390e460dce6626fb8de2c02a24ff650005
 > 	Author: Alan Cox <alan@linux.intel.com>
 > 	Date:   Mon Nov 30 13:22:54 2009 +0000
 > 
 > 	    pata_cmd64x: implement serialization as per notes
 > 
 > Although quite unlikely, commit f0353813afe784330622596ff141e7525ccd99de 

My SPARC Ultra5 boots 2.6.32 Ok but hangs during boot of 2.6.33-rc1.
Reverting d43744390e460dce6626fb8de2c02a24ff650005 allows it to boot
Ok again.
