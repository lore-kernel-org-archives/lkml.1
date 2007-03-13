Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbXCMJxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbXCMJxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXCMJxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:53:35 -0400
Received: from nn7.de ([85.214.94.156]:42198 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbXCMJxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:53:34 -0400
Subject: Re: s2ram still broken with CONFIG_NO_HZ / HPET (macbook pro)
From: Soeren Sonnenburg <kernel@nn7.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S\. Tsirkin" <mst@mellanox.co.il>, Len Brown <lenb@kernel.org>
In-Reply-To: <45F53282.5040504@gmail.com>
References: <1173645941.4204.5.camel@localhost> <45F53282.5040504@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Mar 2007 10:53:31 +0100
Message-Id: <1173779611.13173.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 19:59 +0900, Tejun Heo wrote:
> Soeren Sonnenburg wrote:
> > Elsewise I still see the
> > 
> > ATA: abnormal status 0x80 on port 0x000140df
> > ATA: abnormal status 0x80 on port 0x000140df
> > ata1.00: configured for UDMA/33
> > ata3.01: revalidation failed (errno=-2)
> > ata3: failed to recover some devices, retrying in 5 secs
> > ATA: abnormal status 0x7F on port 0x000140df
> > ATA: abnormal status 0x7F on port 0x000140df
> > ata3.01: configured for UDMA/133
> 
> I can't tell much about HPET timer, only the ATA messages.
> 
> Abnormal messages can be ignored.  Hmmm... revalidation failed without
> explaining why.  Can you apply the attached patch and see whether the
> added message gets printed?

Well it is there:

ATA: abnormal status 0x80 on port 0x000140df
ata1.00: configured for UDMA/33
ata3.01: NODEV after polling detection
ata3.01: revalidation failed (errno=-2)
ata3: failed to recover some devices, retrying in 5 secs
ATA: abnormal status 0x7F on port 0x000140df
ATA: abnormal status 0x7F on port 0x000140df
ata3.01: configured for UDMA/133
SCSI device sda: 234441648 512-byte hdwr sectors (120034 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA

just FYI a macbook pro has a sata disc + a dvd drive registered
as /dev/sda and /dev/scd0 driven by ata_piix:

dmesg | grep ata_piix 
ata_piix 0000:00:1f.1: version 2.10ac1
scsi0 : ata_piix
scsi1 : ata_piix
ata_piix 0000:00:1f.2: MAP [ P0 P2 XX XX ]
ata_piix 0000:00:1f.2: invalid MAP value 0
scsi2 : ata_piix
scsi3 : ata_piix

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
