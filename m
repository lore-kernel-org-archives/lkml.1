Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbYGAOMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbYGAOMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbYGAOMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:12:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58365 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758103AbYGAOMl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:12:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25 to 2.6.26-rc8 regression  (related to ahci and acpi _GTF)
Date: Tue, 1 Jul 2008 16:14:20 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Mathieu =?iso-8859-15?q?B=E9rard?= <Mathieu.Berard@crans.org>,
       linux-ide@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>
References: <4869FB3C.4060509@crans.org>
In-Reply-To: <4869FB3C.4060509@crans.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807011614.21491.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs.]

On Tuesday, 1 of July 2008, Mathieu Bérard wrote:
> Hi,
> I have a laptop with an ICH6M SATA Controller and a Hitachi hard drive.
> While it worked well using the ahci module and Linux 2.6.25, 
> it get randomly 'stuck' for several seconds to several minutes with 2.6.26-rc8.
> Successive errors progressively reduce the ATA link speed.
> 
> Passing the libata.noacpi parameter is an effective workaround.
> 
> Please note that it's not the first time i have this kind of issue, see:
> http://marc.info/?l=linux-ide&m=117305595312399&w=2
> This was found to be a bad interaction between my _GTF taskfile, which enable the
> "Enable Device-Initiated Interface Power State Transitions" feature, and NCQ.
> The driver was later NCQ blacklisted to correct the problem.
> 
> 
> Device detection:
> 
> [    0.567684] ahci 0000:00:1f.2: version 3.0
> [    1.568027] ahci 0000:00:1f.2: AHCI 0001.0000 32 slots 4 ports 1.5 Gbps 0x5 impl IDE mode
> [    1.568091] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part 
> [    1.568695] ata1: SATA max UDMA/133 abar m1024@0xb8000c00 port 0xb8000d00 irq 19
> [    1.873016] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    1.874045] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
> [    1.875000] ata1.00: ATA-7: HTS541010G9SA00, MBZOC60D, max UDMA/100
> [    1.875000] ata1.00: 195371568 sectors, multi 0: LBA48 NCQ (not used)
> [    1.875000] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
> [    1.875000] ata1.00: configured for UDMA/100
> 
> Typical error:
> 
> [  499.178040] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [  499.178105] ata1.00: cmd ca/00:3e:76:45:81/00:00:00:00:00/e1 tag 0 dma 31744 out
> [  499.178106]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  499.178168] ata1.00: status: { DRDY }
> [  499.178220] ata1: hard resetting link
> [  499.942034] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  499.943540] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
> [  499.946056] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
> [  499.947174] ata1.00: configured for UDMA/100
> [  499.947174] ata1: EH complete
> 
> Full dmesg is attached.
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
