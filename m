Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0CCXZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:25:29 -0500
Received: from wdscspam2.wdc.com ([129.253.170.131]:53470 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab0CCXZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:25:23 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] msdos: add support for large disks
Date: Wed, 3 Mar 2010 15:24:25 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD56@wdscexbe01.sc.wdc.com>
In-Reply-To: <4B8EEB2D.4090106@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] msdos: add support for large disks
Thread-Index: Acq7JgFSwDF2Z2sERNa/t+hCMuINAAAACGTg
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com><20100301141335.395dc4c3.akpm@linux-foundation.org> <873a0h1p2c.fsf@devron.myhome.or.jp> <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD53@wdscexbe01.sc.wdc.com> <4B8EEB2D.4090106@zytor.com>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Mar 2010 23:25:23.0789 (UTC) FILETIME=[CC85D7D0:01CABB28]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: H. Peter Anvin [mailto:hpa@zytor.com] 
Sent: Wednesday, March 03, 2010 3:05 PM
To: Daniel Taylor
Cc: OGAWA Hirofumi; Andrew Morton; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msdos: add support for large disks

On 03/03/2010 02:50 PM, Daniel Taylor wrote:
>> 
>> The drives report physical/logical sector sizes of 4096 bytes, which 
>> the kernel correctly detects.  32-bit fields in the MBR are then 
>> sufficient for storage capacites >2TiB (up to 16 TiB), and the storage 
>> in struct parsed_partitions is already sector_t.
>> 

> It's probably worth noting that such media:

> a) will not work with anything that is based on disk images;
> b) will not be bootable on most existing systems.

> Both of these are going to be issues for people in real-life use (and yes,
people boot from USB disks -- trust me, when it > doesn't work they send the
bug reports to *me* rather than to the hw/bios vendors.)  Of course, so is
XP compatibility.

> 	-hpa

Those are good points.  We (WD) are trying to get the NDAs, regarding our
specific not-yet-released products, in place to get the userspace utilities
updated, and WD is also in communication with the Windows tool developers.

Fundamentally, though, the way Windows XP, which only supports MBR
partitioning, can use a disk drive capacity larger than 2 TiB is with sector
sizes larger than 512 bytes.  That is far too large a slice of the installed
base for the disk drive makers to ignore, so these drives and partitions are
going to be released, whether by WD, or someone else.  When someone plugs
one of these disks into a system running Linux, we don't need to hear about
"Linux doesn't support it", if there's a reasonable accomodation.  In this
case, both the inputs MBR partitioning, and the data stored as a result, are
fully capable.  It is only the intermediate variables in the module that are
currently hard-coded to 32-bits, and which truncate the values.

dlt
