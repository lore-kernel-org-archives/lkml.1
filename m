Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbYGGQEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbYGGQEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYGGQEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:04:09 -0400
Received: from lucidpixels.com ([75.144.35.66]:57299 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbYGGQEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:04:08 -0400
Date: Mon, 7 Jul 2008 12:04:06 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Gerhard Wiesinger <lists@wiesinger.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <alpine.LFD.1.10.0807071705490.2997@bbs.intern>
Message-ID: <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jul 2008, Gerhard Wiesinger wrote:

> Hello!
>
> Missing logs attached ...
>
> Ciao,
> Gerhard


Hello!

I'm having a similar problem with a brand new Hardware under Fedora 9 x64
8GB RAM
Motherboard: ASUS M3N-H/HDMI
Chipset: NForce 8300/Nvidia 750a
CPU: AMD AM2 5600+, 2.9GHz, Brisbane Dual Core
Kernel: 2.6.25.9-76.fc9.x86_64
Smartmontools: smartmontools-5.38-2.fc9.x86_64
BIOS AHCI mode
Power cables for ata3 and ata4 are on the same cable from an Enermax power
supply.

ata1.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
ata2.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
ata3.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
ata4.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
ata5.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
ata6.00: ATA-7: SAMSUNG HD103UJ, 1AA01109, max UDMA7
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
scsi 5:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5

Problem occours only on ata3, I've changed the disk Port 3 the third time (new
disks) and changed the SATA cable, too. Problem still exists.

Sometimes a RAID rebuild doesn't work at all.

To get the drive to live I've to power down the system.

Logs are attached.

Can it be a bug on concurrent access of smartctl/smartd?

Any ideas?

Ciao,
Gerhard

--

Hi Gerhard,

It /could/ be the port itself if you have changed the cable and disk..

Have you tried loading the disk with dd and seeing if you can reproduce 
the problem? You are getting the same error I get generally, I can 
recommend turning OFF NCQ first and see if the problem goes away.

# Define DISKS.
cd /sys/block
DISKS=$(/bin/ls -1d sd[a-z])

# Disable NCQ on all disks.
echo "Disabling NCQ on all disks..."
for i in $DISKS
do
   echo "Disabling NCQ on $i"
   echo 1 > /sys/block/"$i"/device/queue_depth
done


Justin.

