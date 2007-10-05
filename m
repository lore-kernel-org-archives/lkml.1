Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbXJEGGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbXJEGGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 02:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXJEGGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 02:06:14 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:61258 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbXJEGGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 02:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PgnCBdQJJGta1Uvs5Bsoj55HeY+hbjtaGVzN9++PhjwrEDIduImLA3fod06HjU9lg6tqrBFA7Qz+gWAmwhweNDfI8J0gCm0qulpHavU1WkNy0/aDeAnHlc7Fe9NEW15wJ2pnA+nChXox1QFIPwa624pYLyAm7jxJ+04NUKy2tUA=
Message-ID: <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com>
Date: Fri, 5 Oct 2007 08:06:11 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Tejun Heo" <htejun@gmail.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20071004170536.GY19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com>
	 <46FFDF64.1080005@gmail.com>
	 <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>
	 <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com>
	 <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com>
	 <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>
	 <20071003163804.GR19691@waste.org>
	 <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com>
	 <20071004170536.GY19691@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/07, Matt Mackall <mpm@selenic.com> wrote:
> On Thu, Oct 04, 2007 at 07:32:52AM +0200, Torsten Kaiser wrote:
> > So now I'm rather out of ideas what to test... :(
>
> I'd give your previous bisect step another try.

Yes, I thought about that too. But I never seemed to need more than
two tries to make it fail.
So I would only suspect the last good step as wrong positive.
That would then point to the first of your maps2-patches, the moving
of the pagewalker code.
Would you thing that this is a plausible cause?

> Looking back at the thread a bit, anything that requires the machine
> to be off for more than a couple seconds to manifest stops looking
> like software and firmware and starts looking like a heat-related
> electrical or mechanical issue. Make sure your backups are current.

What backups? :-)

Yes, I also thought about hardware trouble, but the bisect result
seemed to consistent.
Also that its not always the same drive that fails, only every time
one of the sil-drives.

I now have activated ATA_DEBUG to see if the good and the bad boots differ.
It looks the same until the RAID5 starts.

Good boot:
[   40.160000] ata_scsi_dump_cdb: CDB (2:0,0,0) 35 00 00 00 00 00 00 00 00
[   40.160000] ata_scsi_dump_cdb: CDB (1:0,0,0) 35 00 00 00 00 00 00 00 00
[   40.160000] ata_scsi_dump_cdb: CDB (2:0,0,0) 2a 00 25 42 d6 09 00 00 08
[   40.160000] ata_sg_setup: 1 sg elements mapped
[   40.160000] ata_scsi_dump_cdb: CDB (1:0,0,0) 2a 00 25 42 d6 09 00 00 08
[   40.160000] ata_sg_setup: 1 sg elements mapped
[   40.160000] ata_scsi_dump_cdb: CDB (2:0,0,0) 35 00 00 00 00 00 00 00 00
[   40.160000] ata_scsi_dump_cdb: CDB (1:0,0,0) 35 00 00 00 00 00 00 00 00
[   40.320000] nv_swncq_host_interrupt: id 0x3 SWNCQ: qc_active 0x1
dhfis 0x1 dmafis 0x1 sactive 0x0
[   40.320000] nv_swncq_sdbfis: over
[   40.320000] ata_scsi_dump_cdb: CDB (3:0,0,0) 35 00 00 00 00 00 00 00 00
[   40.320000] ata_exec_command: ata3: cmd 0xEA
[   40.390000] ata_hsm_move: ata3: protocol 1 task_state 3 (dev_stat 0x40)
[   40.390000] ata_hsm_move: ata3: dev 0 command complete, drv_stat 0x40
[   40.420000] md: considering sdb1 ...
[   40.440000] md:  adding sdb1 ...
[   40.440000] md:  adding sda1 ...
[   40.450000] md: created md0
[   40.460000] md: bind<sda1>
[   40.470000] md: bind<sdb1>
[   40.480000] md: running: <sdb1><sda1>
[   40.500000] raid1: raid set md0 active with 2 out of 2 mirrors

Bad boot:
[   40.060000] ata_scsi_dump_cdb: CDB (2:0,0,0) 35 00 00 00 00 00 00 00 00
[   40.060000] ata_scsi_dump_cdb: CDB (1:0,0,0) 35 00 00 00 00 00 00 00 00
[   40.060000] ata_scsi_dump_cdb: CDB (2:0,0,0) 2a 00 25 42 d6 09 00 00 08
[   40.060000] ata_sg_setup: 1 sg elements mapped
[   40.060000] ata_scsi_dump_cdb: CDB (1:0,0,0) 2a 00 25 42 d6 09 00 00 08
[   40.060000] ata_sg_setup: 1 sg elements mapped
[   40.060000] ata_scsi_dump_cdb: CDB (2:0,0,0) 35 00 00 00 00 00 00 00 00
[   40.200000] nv_swncq_host_interrupt: id 0x3 SWNCQ: qc_active 0x1
dhfis 0x1 dmafis 0x1 sactive 0x0
[   40.200000] nv_swncq_sdbfis: over
[   40.200000] ata_scsi_dump_cdb: CDB (3:0,0,0) 35 00 00 00 00 00 00 00 00
[   40.200000] ata_exec_command: ata3: cmd 0xEA
[   40.270000] ata_hsm_move: ata3: protocol 1 task_state 3 (dev_stat 0x40)
[   40.270000] ata_hsm_move: ata3: dev 0 command complete, drv_stat 0x40
[   70.060000] ata_scsi_timed_out: ENTER
[   70.060000] ata_scsi_timed_out: EXIT, ret=0
[   70.080000] ata_scsi_error: ENTER
[   70.080000] ata_port_flush_task: ENTER
[   70.100000] ata1: ata_port_flush_task: EXIT
[   70.110000] __ata_port_freeze: ata1 port frozen
[   70.220000] __ata_port_freeze: ata1 port frozen
[   70.230000] ata_eh_link_autopsy: ENTER
[   70.240000] ata_eh_link_autopsy: EXIT
[   70.250000] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[   70.270000] ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0
cdb 0x0 data 4096 out
[   70.270000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)

After [   40.060000] ata_scsi_dump_cdb: CDB (1:0,0,0) 2a 00 25 42 d6 09 00 00 08
the drive sda falls of the earth and can't be recovered through soft-
or hard-resetting the port by the error handler.

So I will use the weekend to see if I can find out who issues this
command and add more debug to that place...

Torsten
