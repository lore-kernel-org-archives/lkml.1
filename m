Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbXI3GAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbXI3GAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 02:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbXI3GA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 02:00:29 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:47377 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbXI3GA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 02:00:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WhBKqvT6fjqAU4g+rsxAt6z5wQkU8lTUqihDSeLAHjJpXv43pkEjOyNSUjcBQjHwXydPmi1I9lwvd9PxbwIPWxUusOT98MvxRSNOeFKddqtP3XaFTtHh17aEFTZ2EW1d+OxD6iVFGiX/rhG2YTqFfpm4ySUtsKqrD3qyIyTA8+Y=
Message-ID: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
Date: Sun, 30 Sep 2007 08:00:26 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <64bb37e0709272236g7da8f370lc7f737e908725e88@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
	 <46FB3793.9060607@gmail.com> <46FB3843.2030708@gmail.com>
	 <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>
	 <46FB4CB3.3090004@garzik.org>
	 <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>
	 <46FC1104.8080105@gmail.com>
	 <64bb37e0709272236g7da8f370lc7f737e908725e88@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> So in case of -rc3-mm1 I'm pretty sure that it works.

That's still the case.

> Not completely sure is if 2.6.23-rc7-sglist kernel works. I booted
> that 9 times, but from a quick look in /var/log/messages, I might not
> have hit the "correct" situation to trigger the error.
> That kernel is vanilla 2.6.23-rc7 plus the patch from
> http://www.kernel.org/pub/linux/kernel/people/tomo/misc/v2.6.23-rc7-sglist-arch.diff.bz2
> ( http://marc.info/?l=linux-ide&m=119055574826083&w=2 )

That is no longer the case. Yesterday this kernel did also show the failure.
The error looked a little bit different, but happend at the same
location during the bootup.
Sadly dmesg overflowed and I was not able to capture the first error.

[   53.462632] Freeing unused kernel memory: 332k freed
ite cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   77.170903] ata1.00: exception Emask 0x40 SAct 0x1 SErr 0x0 action 0x2
[   77.170905] ata1.00: irq_stat 0x00020002, SGT no on qword boundary
[   77.170908] ata1.00: cmd 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0
cdb 0x0 data 4096 out
[   77.170909]          res 50/00:00:af:ea:42/00:00:25:00:00/e0 Emask
0x40 (internal error)
[   77.504292] ata1: soft resetting port
[   77.544221] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   77.642567] ata1.00: configured for UDMA/100
[   77.642572] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE,SUGGEST_OK
[   77.642574] sd 0:0:0:0: [sda] Sense Key : Aborted Command [current]
[descriptor]
[   77.642578] Descriptor sense data with sense descriptors (in hex):
[   77.642580]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[   77.642584]         00 00 00 af
[   77.642586] sd 0:0:0:0: [sda] Add. Sense: No additional sense information
[   77.642589] end_request: I/O error, dev sda, sector 625137161
[   77.642593] ata1: EH complete
[   77.642609] sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
[   77.642616] sd 0:0:0:0: [sda] Write Protect is off
[   77.642618] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   77.642628] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   77.666927] md: super_written gets error=-5, uptodate=0
[   77.666930] raid5: Disk failure on sda2, disabling device.
Operation continuing on 1 devices

That "Operation continuing on 1 devices" is a 'little' bit misleading.
A RAID5 with two failed devices will not continue to operate. :(
The same error is repeated several times, so I expect the first error
also looked like that.

Other things I have done to narrow it down:
Comparing 2.6.23-rc3-mm1 and 2.6.23-rc4-mm1 I found the following hunk
from libata-core.c:
@@ -2182,6 +2183,17 @@
        if (ap->ops->cable_detect)
                ap->cbl = ap->ops->cable_detect(ap);

+       /* We may have SATA bridge glue hiding here irrespective of the
+          reported cable types and sensed types */
+       ata_link_for_each_dev(dev, &ap->link) {
+               if (!ata_dev_enabled(dev))
+                       continue;
+               /* SATA drives indicate we have a bridge. We don't know which
+                  end of the link the bridge is which is a problem */
+               if (ata_id_is_sata(dev->id))
+                       ap->cbl = ATA_CBL_SATA;
+       }
+

But removing this from the current -mm does still show the error, so
thats not the source of the bug. (That test kicked the first drive
(sdb) from the RAID5 with the same error as most times)

Rebooting into the "safe" rc7-sglist-kernel I got the above error that
killed the RAID5.
I rebooted into a system (kernel 2.6.21-rc5-mm2, please not the
2.6.*21*, that is only a rescue system and not updated often) on a
separate partition to rebuild it. When I tried to readd the failed sdb
the system locked up with this error:

Sep 29 22:25:37 treogen [  205.407893] ata2.00: exception Emask 0x0
SAct 0x0 SErr 0x0 action 0x2 frozen
Sep 29 22:25:37 treogen [  205.407900] ata2.00: cmd
ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
Sep 29 22:25:37 treogen [  205.407901]          res
40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (time out)
Sep 29 22:25:38 treogen [  205.720531] ata2: soft resetting port
Sep 29 22:25:38 treogen [  205.720554] ata2: SATA link up 3.0 Gbps
(SStatus 123 SControl 300)
Sep 29 22:25:38 treogen [  205.730560] ATA: abnormal status 0xEA on
port 0xffffc20001432007
Sep 29 22:25:38 treogen [  205.740560] ATA: abnormal status 0xEA on
port 0xffffc20001432007
Sep 29 22:26:07 treogen [  235.343001] ata1.00: exception Emask 0x0
SAct 0x1 SErr 0x0 action 0x2 frozen
Sep 29 22:26:07 treogen [  235.343007] ata1.00: cmd
61/08:00:bf:52:2a/00:00:01:00:00/40 tag 0 cdb 0x0 data 4096 out
Sep 29 22:26:07 treogen [  235.343009]          res
40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (time out)
Sep 29 22:26:08 treogen [  235.655644] ata1: soft resetting port
Sep 29 22:26:08 treogen [  235.655666] ata1: SATA link up 3.0 Gbps
(SStatus 123 SControl 300)
Sep 29 22:26:08 treogen [  235.675602] ata2.00: qc timeout (cmd 0xec)
Sep 29 22:26:08 treogen [  235.675608] ata2.00: failed to IDENTIFY
(I/O error, err_mask=0x104)
Sep 29 22:26:08 treogen [  235.675610] ata2.00: revalidation failed (errno=-5)
Sep 29 22:26:08 treogen [  235.675612] ata2: failed to recover some
devices, retrying in 5 secs
Sep 29 22:26:13 treogen [  240.668113] ata2: hard resetting port
Sep 29 22:26:15 treogen [  242.833438] ata2: SATA link up 3.0 Gbps
(SStatus 123 SControl 300)
Sep 29 22:26:15 treogen [  242.843444] ATA: abnormal status 0xEC on
port 0xffffc20001432007
Sep 29 22:26:15 treogen [  242.853443] ATA: abnormal status 0xEC on
port 0xffffc20001432007
Sep 29 22:26:38 treogen [  265.590759] ata1.00: qc timeout (cmd 0xec)
Sep 29 22:26:38 treogen [  265.590765] ata1.00: failed to IDENTIFY
(I/O error, err_mask=0x104)
Sep 29 22:26:38 treogen [  265.590767] ata1.00: revalidation failed (errno=-5)
Sep 29 22:26:38 treogen [  265.590769] ata1: failed to recover some
devices, retrying in 5 secs
Sep 29 22:26:43 treogen [  270.583271] ata1: hard resetting port
Sep 29 22:26:45 treogen [  272.748596] ata1: SATA link up 3.0 Gbps
(SStatus 123 SControl 300)
Sep 29 22:26:45 treogen [  272.758601] ATA: abnormal status 0xEC on
port 0xffffc20001430007
Sep 29 22:26:45 treogen [  272.768602] ATA: abnormal status 0xEC on
port 0xffffc20001430007
Sep 29 22:26:45 treogen [  272.788490] ata2.00: qc timeout (cmd 0xec)
Sep 29 22:26:45 treogen [  272.788494] ata2.00: failed to IDENTIFY
(I/O error, err_mask=0x104)
Sep 29 22:26:45 treogen [  272.788496] ata2.00: revalidation failed (errno=-5)
Sep 29 22:26:45 treogen [  272.788501] ata2.00: limiting speed to UDMA/100:PIO3
Sep 29 22:26:45 treogen [  272.788503] ata2: failed to recover some
devices, retrying in 5 secs
Sep 29 22:26:50 treogen [  277.781001] ata2: hard resetting port
Sep 29 22:26:52 treogen [  279.946326] ata2: SATA link up 3.0 Gbps
(SStatus 123 SControl 300)
Sep 29 22:26:52 treogen [  279.956331] ATA: abnormal status 0xEC on
port 0xffffc20001432007
Sep 29 22:26:52 treogen [  279.966330] ATA: abnormal status 0xEC on
port 0xffffc20001432007
Sep 29 22:27:15 treogen [  302.703652] ata1.00: qc timeout (cmd 0xec)
Sep 29 22:27:15 treogen [  302.703661] ata1.00: failed to IDENTIFY
(I/O error, err_mask=0x104)
Sep 29 22:27:15 treogen [  302.703663] ata1.00: revalidation failed (errno=-5)
Sep 29 22:27:15 treogen [  302.703669] ata1.00: limiting speed to UDMA/100:PIO3
Sep 29 22:27:15 treogen [  302.703671] ata1: failed to recover some
devices, retrying in 5 secs
Sep 29 22:27:20 treogen [  307.696161] ata1: hard resetting port
Sep 29 22:27:22 treogen [  309.884773] ata1: SATA link up 3.0 Gbps
(SStatus 123 SControl 300)
Sep 29 22:27:22 treogen [  309.894784] ATA: abnormal status 0xEC on
port 0xffffc20001430007
Sep 29 22:27:22 treogen [  309.904786] ATA: abnormal status 0xEC on
port 0xffffc20001430007
Sep 29 22:27:22 treogen [  309.904940] ata2.00: qc timeout (cmd 0xec)
Sep 29 22:27:22 treogen [  309.904946] ata2.00: failed to IDENTIFY
(I/O error, err_mask=0x104)
Sep 29 22:27:22 treogen [  309.904948] ata2.00: revalidation failed (errno=-5)
Sep 29 22:27:22 treogen [  309.904951] ata2.00: disabled
Sep 29 22:27:23 treogen [  310.406968] ata2: EH complete
Sep 29 22:27:23 treogen [  310.407013] sd 1:0:0:0: [sdb] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Sep 29 22:27:23 treogen [  310.407018] end_request: I/O error, dev
sdb, sector 19550911

Is it possible that the bug is much older, and only some change in
rc3-mm->rc4-mm makes it visible that the initialization of the SiI3132
is incomplete?

Currently I try a 2.6.23-rc4-mm1 with only 629 of 1628 mm-patches applied...

Torsten
