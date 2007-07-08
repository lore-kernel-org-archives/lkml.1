Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbXGHIkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbXGHIkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 04:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXGHIkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 04:40:10 -0400
Received: from ns.netcenter.hu ([195.228.254.57]:39922 "EHLO netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbXGHIkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 04:40:07 -0400
X-Greylist: delayed 1314 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2007 04:40:07 EDT
Message-ID: <6b2701c7c138$4409f0e0$0400a8c0@dcccs>
From: "Janos Haar" <djani22@netcenter.hu>
To: <7091@blargh.com>
Cc: <linux-kernel@vger.kernel.org>
References: <courier.4682D874.00001187@blargh.com>
Subject: Re: sata_sil, writing bug with multiple cards?
Date: Sun, 8 Jul 2007 10:01:18 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1807
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1896
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, list,

I have a little note for this.

About 1 - 1.5 years before i have the same problem.
I have 4 server, each has 3 sata sil card, and 2 of 4 servers freezed in the
first time during the raid5 resyncing!
After restart, the box kicked 2 hdd-s from the array, that are on the same
card.
I try to replace the card to the new one, nothing is chancged, the resync
stopped again.
I try to swap over the 2x3 card on the 2 server, and nothing is changed!
When i try to read the strip (raid5) all works fine.
But if i try to write a large amount of data, these two box freezed. (or
rebooted, i can't remember now)
Finally i buy promise cards to all box, and all problem is gone. :-)

The problem is true, exists, and looks like in the driver. (or workaround of
hardware problem?)

Cheers,

Janos Haar


----- Original Message ----- 
From: <7091@blargh.com>
To: <linux-kernel@vger.kernel.org>
Sent: Wednesday, June 27, 2007 11:36 PM
Subject: sata_sil, writing bug with multiple cards?


> Greetings,
>
> I have been troubleshooting a problem for over a year now, and to make a
> long story short, I think the sata_sil driver has a bug during writing
when
> there are multiple cards that are using different models of SiI chips in
the
> system.
>
> I will be watching the list, although cc'ing me over email will be useful
> for speeding up replies.
>
> Longer version:
> I've been having problems with my Linux server corrupting data.  Not just
a
> little - it can't copy a 700 meg ISO file and end up with the same
checksum
> (and usually corrupts the filesystem in the process).
>
> Hardware:
> Asus A7N8X-Deluxe motherboard.  This has 2 parallel IDE connectors, each
> with a 40 gig IDE HD hanging off it, and 2 SATA connectors (driven by a
SiI
> 3112 chip) with (right now) 1 300G SATA HD and 1 250G SATA HD.  All of
these
> facts are important.
>
> On my PCI bus, I have a SiI 3114A card with 3 more 300G SATA HDs.  It
should
> be noted that only drives on the PCI card have corruption.  Neither the
> parallel IDE HDs, nor the SATA drives on the motherboard experience the
> problem. I have also tried replacing this card, which did not fix the
> problem.  Also, placing the same drive on the add-on card has corruption,
> the same drive, cable, power, etc. on the motherboard works fine.
>
> I've already swapped motherboards, CPU, and RAM.
>
> Booting to a Knoppix 5.1 CD shows the same problems.
>
> Reading is fine (i.e. I can read the same file 50 times and get the same
> md5sum).  Writing causes the corruption.
>
> The corruption happens no matter what filesystem I try (ext2, ext3,
reiser,
> xfs).  (This does mean I've reformatted, etc. several times, so its not a
> metadata problem)
>
> This happens with at least 3 different drives (the 300 and the 250,
> different manufacturers), with different SATA data cables, power supplies,
> power cables, etc.
>
> Now, here's the kicker.  Booting to an OpenBSD kernel, and using one of
the
> 300G drives off the 3114A card (the one that show corruption under Linux)
> works fine.
>
> This happens with the Knoppix 5.1 kernel (2.6.19), my own compiled
2.6.20.3,
> and Debian kernel 2.6.18-4-k7.
>
> More spammy data:
> # lspci
> 00:00.0 Host bridge: nVidia Corporation nForce2 AGP (different version?)
> (rev a2)
> 00:00.1 RAM memory: nVidia Corporation nForce2 Memory Controller 1 (rev
a2)
> 00:00.2 RAM memory: nVidia Corporation nForce2 Memory Controller 4 (rev
a2)
> 00:00.3 RAM memory: nVidia Corporation nForce2 Memory Controller 3 (rev
a2)
> 00:00.4 RAM memory: nVidia Corporation nForce2 Memory Controller 2 (rev
a2)
> 00:00.5 RAM memory: nVidia Corporation nForce2 Memory Controller 5 (rev
a2)
> 00:01.0 ISA bridge: nVidia Corporation nForce2 ISA Bridge (rev a3)
> 00:01.1 SMBus: nVidia Corporation nForce2 SMBus (MCP) (rev a2)
> 00:02.0 USB Controller: nVidia Corporation nForce2 USB Controller (rev a3)
> 00:02.1 USB Controller: nVidia Corporation nForce2 USB Controller (rev a3)
> 00:02.2 USB Controller: nVidia Corporation nForce2 USB Controller (rev a3)
> 00:04.0 Ethernet controller: nVidia Corporation nForce2 Ethernet
Controller
> (rev a1)
> 00:08.0 PCI bridge: nVidia Corporation nForce2 External PCI Bridge (rev
a3)
> 00:09.0 IDE interface: nVidia Corporation nForce2 IDE (rev a2)
> 00:0c.0 PCI bridge: nVidia Corporation nForce2 PCI Bridge (rev a3)
> 00:1e.0 PCI bridge: nVidia Corporation nForce2 AGP (rev a2)
> 01:06.0 VGA compatible controller: Matrox Graphics, Inc. MGA 2164W
> [Millennium II]
> 01:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
> Gigabit Ethernet (rev 10)
> 01:09.0 Mass storage controller: Silicon Image, Inc. SiI 3114
> [SATALink/SATARaid] Serial ATA Controller (rev 02)
> 01:0b.0 RAID bus controller: Silicon Image, Inc. SiI 3112
> [SATALink/SATARaid] Serial ATA Controller (rev 01)
> 02:01.0 Ethernet controller: 3Com Corporation 3C920B-EMB Integrated Fast
> Ethernet Controller [Tornado] (rev 40)
>
> Any assistance, input, etc. appreciated.  Thanks.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

