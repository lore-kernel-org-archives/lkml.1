Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYL3SOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYL3SOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 13:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYL3SOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 13:14:23 -0500
Received: from server515f.exghost.com ([72.32.253.82]:4622 "EHLO
	server515.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbYL3SOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 13:14:22 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE:  Re: 2.6.27.10: ata1.00: HPA detected: current 293044655, native   293046768
Date: Tue, 30 Dec 2008 12:12:57 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C0337C2AA@34093-C3-EVS3.exchange.rackspace.com>
In-Reply-To: A<495A5A9F.9020406@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: 2.6.27.10: ata1.00: HPA detected: current 293044655, native   293046768
Thread-Index: AclqpwsZuoVRqOfASCyxXPa3hCzlWQAAWOAg
References: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan> A<495A5A9F.9020406@shaw.ca>
From: "David Lethe" <david@santools.com>
To: "Robert Hancock" <hancockr@shaw.ca>, <linux-raid@vger.kernel.org>
Cc: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Dec 2008 18:14:19.0464 (UTC) FILETIME=[6EEADC80:01C96AAA]
X-Policy: GLOBAL - santools.com
X-Policy: GLOBAL - santools.com
X-Policy: GLOBAL - santools.com
X-Policy: GLOBAL - santools.com
X-Primary: david@santools.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: david@santools.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 72.32.49.5
X-Note-Reverse-DNS: 
X-Note-WHTLIST: david@santools.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: 94 95 96 97 101 102 170 
X-Note: Mail Class: ALLOWEDSENDER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Robert Hancock
> Sent: Tuesday, December 30, 2008 11:30 AM
> To: linux-raid@vger.kernel.org
> Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: 2.6.27.10: ata1.00: HPA detected: current 293044655,
> native 293046768
> 
> Justin Piszcz wrote:
> > On one system, two Raptor 150s:
> >
> > [    0.739402] ata1.00: HPA detected: current 293044655, native
> 293046768
> > [    0.739491] ata1.00: ATA-7: WDC WD1500ADFD-00NLR5, 21.07QR5, max
> > UDMA/133
> > [    0.739577] ata1.00: 293044655 sectors, multi 0: LBA48 NCQ (depth
> 31/32)
> > [    0.742454] ata1.00: configured for UDMA/133
> >
> > [    1.059146] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl
300)
> > [    1.061406] ata2.00: ATA-7: WDC WD1500ADFD-00NLR5, 21.07QR5, max
> > UDMA/133
> > [    1.061494] ata2.00: 293046768 sectors, multi 0: LBA48 NCQ (depth
> 31/32)
> > [    1.064360] ata2.00: configured for UDMA/133
> >
> > Two disks in a RAID-1 (mdadm) configuration, how come the first one
> > has an issue w/HPA as the firmware of both disks is the same..?
> >
> > l1:~# smartctl -a /dev/sda | grep -i bytes
> > User Capacity:    150,038,863,360 bytes
> > l1:~# smartctl -a /dev/sdb | grep -i bytes
> > User Capacity:    150,039,945,216 bytes
> > l1:~#
> >
> > Why does this occur?
> 
> Presumably somebody or something set up a host protected area on one
> drive and not the other.. I believe there are some utilities out there
> that can be used to disable the HPA and allow the full capacity to be
> used.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Warning - this hidden area could have been used to circumvent some
security, hold viruses,
steal data, whatever.  I have unfortunately seen this trick more times
than I care to 
get into.

If this disk drive is installed on a computer where such things are
a possibility, then I suggest bringing system down to single user mode,
having a witness
by your side, then resizing the disk and using dd to grab contents of
the "new" blocks,
so you can inspect it.  

With the right software, and access to the sg driver, then one can
easily use this area as
their own private repository to keep stuff until the opportunity
presents itself to take
the data offsite.  

FYI, there is no way to prevent somebody from resizing disk in this way
if they can write
to the sg driver, some of our customers use our software to resize in
this way and to monitor
changes, but you can really just set up a shell script to do this
yourself.

David
http://www.santools.com/smart/unix/manual



