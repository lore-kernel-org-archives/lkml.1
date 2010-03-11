Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab0CKWHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:07:23 -0500
Received: from wdscspam1.wdc.com ([129.253.170.130]:23663 "EHLO
	wdscspam1.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249Ab0CKWHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:07:20 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition for > 512B sector
Date: Thu, 11 Mar 2010 14:06:03 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD91@wdscexbe01.sc.wdc.com>
In-Reply-To: <4B99677B.80001@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition for > 512B sector
Thread-Index: AcrBZiESD+oSszhOTqOEbnJ+7fDlHgAABo5Q
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com><20100301141335.395dc4c3.akpm@linux-foundation.org><873a0h1p2c.fsf@devron.myhome.or.jp><876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com><87pr3fd68r.fsf@devron.myhome.or.jp> <4B9440FC.3090502@zytor.com><87zl2j9muz.fsf@devron.myhome.or.jp><87wrxkw52s.fsf_-_@devron.myhome.or.jp><87sk88w4xk.fsf_-_@devron.myhome.or.jp><3E0C3AE547FA504DA5E89EA5A24AC85803E2BD87@wdscexbe01.sc.wdc.com> <873a07oyts.fsf@devron.myhome.or.jp> <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD8E@wdscexbe01.sc.wdc.com> <4B99677B.80001@zytor.com>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Mar 2010 22:07:01.0473 (UTC) FILETIME=[2D075D10:01CAC167]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com] 
> Sent: Thursday, March 11, 2010 1:58 PM
> To: Daniel Taylor
> Cc: OGAWA Hirofumi; Andrew Morton; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] fs/partition/msdos: Fix unusable 
> extended partition for > 512B sector
> 
> On 03/11/2010 01:25 PM, Daniel Taylor wrote:
> >
> > I have not yet tried booting from one of these disks.
> >
> > They are in USB-attached enclosures,
> 
> Right...
> 
> > attached well after boot, so the
> > bootloader has never seen them.
> 
> Wrong.  A lot of BIOSes will attempt to boot from USB 
> storage.  Worse, a 
> fair number of BIOSes will hang during startup if a USB 
> storage device 
> that confuses them -- even if not the primary boot device.

BIOS failures prior to loading the kernel are not Linux'
responsibility.  Confused BIOS will still fail, even if the
patch is not implemented,  so how does that effect the
acceptance of a patch that fixes post-boot behavior?
 
>> They simply refuse to mount to a running
>> Linux system because, when the storage for partition size and start was
>> expanded to 64-bit, no one bothered to fix the intermediate storage in
>> msdos.c, so the kernel cannot locate the start nor figure the size of
>> the partitions.
>>
>> Logically, this patch is not complicated.  The data types in msdos.c
>> are flat-out wrong, given that the real stored data is of type sector_t.
>> The intermediate variables should not be u32.
> 
> I would consider this a bugfix.  As such, it should be pushed outside 
> the merge window.
> 
> 	-hpa
> 
