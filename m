Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYJQIJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYJQIJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 04:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYJQIIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 04:08:49 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:40482 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752945AbYJQIIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 04:08:45 -0400
Date: Fri, 17 Oct 2008 10:08:40 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20081017080840.GB21671@anita.doom>
Mail-Followup-To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <20081006211906.GA31148@anita.doom> <20081006212307.GA881@anita.doom> <48EAB535.8010203@kernel.org> <20081007060357.GA16761@anita.doom> <48EB1993.1030606@panasas.com> <20081008080848.GA20525@anita.doom> <48F3088C.9010002@kernel.org> <48F308E8.4030503@kernel.org> <20081013142951.GB23124@anita.doom> <48F58A96.8040406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F58A96.8040406@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The patch before, I told it always boots but the last two days I had
much difficulties to boot. It was hard resetting and waiting a couple of
times before bailing out with no mountable root FS. 

One time it was switched off three hours and the next time overnight, I
powercyced a couple of times. If I am the only one experiencing this
difficulties (am I the only one with this chipset/revision reporting?),
shouldn't we consider this machine... broken? I change SATA cables from
time to time, but these seem all to be okay. I mean, if it is really
_that_ strange...

Am 2008-10-15 15:15 +0900 schrieb Tejun Heo:
> Hmm... this is proving to be much more difficult than I expected. :-(

:-(

> Can you please try the attached patch?

I fetched 2.6.27 now and tried this patch. A short powercycle, reboot
wasn't a problem yesterday, this morning also not, so looks well so far,
tihs is how /var/log/messages looks now:

Oct 17 07:24:49 zappa sata_nv 0000:00:0a.0: version 3.5
Oct 17 07:24:49 zappa ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
Oct 17 07:24:49 zappa sata_nv 0000:00:0a.0: PCI INT A -> Link[LTID] -> GSI 21 (level, low) -> IRQ 21
Oct 17 07:24:49 zappa sata_nv 0000:00:0a.0: setting latency timer to 64
Oct 17 07:24:49 zappa scsi0 : sata_nv
Oct 17 07:24:49 zappa scsi1 : sata_nv
Oct 17 07:24:49 zappa ata1: SATA max UDMA/133 cmd 0xf80 ctl 0xf00 bmdma 0xd800 irq 21
Oct 17 07:24:49 zappa ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd808 irq 21
Oct 17 07:24:49 zappa ata1: hard resetting link
Oct 17 07:24:49 zappa ata1: SATA link down (SStatus 0 SControl 300)
Oct 17 07:24:49 zappa ata1: EH complete
Oct 17 07:24:49 zappa ata2: hard resetting link
Oct 17 07:24:49 zappa XXX CLASSIFY 01:00:00
Oct 17 07:24:49 zappa ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Oct 17 07:24:49 zappa ata2.00: ATA-7: SAMSUNG HD753LJ, 1AA01106, max UDMA7
Oct 17 07:24:49 zappa ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Oct 17 07:24:49 zappa ata2.00: configured for UDMA/133
Oct 17 07:24:49 zappa ata2: EH complete
Oct 17 07:24:49 zappa isa bounce pool size: 16 pages
Oct 17 07:24:49 zappa scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
Oct 17 07:24:49 zappa sd 1:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
Oct 17 07:24:49 zappa sd 1:0:0:0: [sda] Write Protect is off
Oct 17 07:24:49 zappa sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 17 07:24:49 zappa sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 17 07:24:49 zappa sd 1:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
Oct 17 07:24:49 zappa sd 1:0:0:0: [sda] Write Protect is off
Oct 17 07:24:49 zappa sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 17 07:24:49 zappa sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 17 07:24:49 zappa sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
Oct 17 07:24:49 zappa sd 1:0:0:0: [sda] Attached SCSI disk

Kind Regards, Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
