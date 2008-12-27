Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbYL0AfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbYL0AfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 19:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYL0Aew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 19:34:52 -0500
Received: from server515j.exghost.com ([72.32.253.74]:3436 "EHLO
	server515.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751785AbYL0Aev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 19:34:51 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE:  Re: RFC: detection of silent corruption via ATA long sector reads
Date: Fri, 26 Dec 2008 18:32:56 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C031B27E3@34093-C3-EVS3.exchange.rackspace.com>
In-Reply-To: A<49555797.3080009@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: RFC: detection of silent corruption via ATA long sector reads
Thread-Index: Aclnp7Xm+7JL/VypQ5+4IMN/XI4P6QAEg0yg
References: <87f94c370812261344s3f70de25r4d132101d2247e00@mail.gmail.com> A<49555797.3080009@shaw.ca>
From: "David Lethe" <david@santools.com>
To: "Robert Hancock" <hancockr@shaw.ca>, <linux-raid@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Dec 2008 00:34:15.0210 (UTC) FILETIME=[D896A8A0:01C967BA]
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
> Sent: Friday, December 26, 2008 4:16 PM
> To: linux-raid@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: RFC: detection of silent corruption via ATA long sector
> reads
> 
> Greg Freemyer wrote:
> > All,
> >
> > On the mdraid list, there was a recent thread about using raid
> > functionality to detect / repair silent corruption.
> >
> > The issues brought up were that a lot of silent data corruption
> occurs
> > when cables, controllers, power supplies, ram, cache, etc. goes bad.
> >
> > It made me think about another option for detecting silent
corruption
> > I have not seen discussed, but maybe I missed it.
> >
> > Aiui, the ATA spec allows for the reading of a long sector as well
as
> > the normal 512 byte sector.  When you get a long sector you also get
> > the CRC (or whatever checksum data there is on the disk that allows
> > the drive itself to detect media errors).
> >
> > I don't have any idea how easy or hard it would be to do, but I
would
> > like to see the entire block subsystem enhanced to optionally allow
> > long sector reads to be used in a "paranoid" fashion.
> >
> > Effectively it would be:
> >
> > 1) Read long sector from drive:  verify CRC in kernel.  This tests
> > most everything on the i/o path.
> >
> > 2) maintain CRC type information in block subsystem.  Verify no
> > corruption just before handing off to userspace.  This would
> > potentially identify CPU/cache/RAM failures.
> 
> Even if the drive supports those commands the problem is the CRC/ECC
> data is in a vendor-specific format, so it couldn't be processed
> generically.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Many of the RAID appliance/subsystem vendors format the disks to 520 or
528
Bytes/sector, but expose 512-byte blocks to the user.  The ECC logic is
done
by the firmware ... or if this ever gets implemented, would be done by
the
LINUX kernel.  True there are some issues with many of the cheap
consumer
class drives not supporting anything but 512-byte blocks, but we
shouldn't
code to lowest common denominator.

With 1TB SATA disks selling for $99, then it isn't as if the extra 8-16
bytes
for ECC on the disk drive is going to be a problem.

David



