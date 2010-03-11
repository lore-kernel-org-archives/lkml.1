Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0CKVge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:36:34 -0500
Received: from wdscspam1.wdc.com ([129.253.170.130]:63221 "EHLO
	wdscspam1.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0CKVgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:36:32 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 16:36:32 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition for > 512B sector
Date: Thu, 11 Mar 2010 13:25:55 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD8E@wdscexbe01.sc.wdc.com>
In-Reply-To: <873a07oyts.fsf@devron.myhome.or.jp>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition for > 512B sector
Thread-Index: AcrBEhYhIjFloX5cRjee6uRAJqhQHgATfThw
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com><20100301141335.395dc4c3.akpm@linux-foundation.org><873a0h1p2c.fsf@devron.myhome.or.jp><876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com><87pr3fd68r.fsf@devron.myhome.or.jp> <4B9440FC.3090502@zytor.com><87zl2j9muz.fsf@devron.myhome.or.jp><87wrxkw52s.fsf_-_@devron.myhome.or.jp><87sk88w4xk.fsf_-_@devron.myhome.or.jp><3E0C3AE547FA504DA5E89EA5A24AC85803E2BD87@wdscexbe01.sc.wdc.com> <873a07oyts.fsf@devron.myhome.or.jp>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Mar 2010 21:26:44.0567 (UTC) FILETIME=[8C70C670:01CAC161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: OGAWA Hirofumi [mailto:hirofumi@mail.parknet.co.jp] 
> Sent: Thursday, March 11, 2010 3:58 AM
> To: Daniel Taylor
> Cc: Andrew Morton; H. Peter Anvin; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] fs/partition/msdos: Fix unusable 
> extended partition for > 512B sector
> 
> "Daniel Taylor" <Daniel.Taylor@wdc.com> writes:
> 
> > In the near future, WD will be releasing products that need 
> this patch.
> >
> > Wouldn't it be a better Linux user experience to never have 
> the problem,
> > rather than wait for a bug-fix cycle on the kernel?
> 
> Of course, if we can fix, it's better.
> 
> However, probably, users of this patch would be only boot loader,
> because this is a first sector on extended-partition itself, not
> logical-partitions in extended-partition.

I have not yet tried booting from one of these disks.

They are in USB-attached enclosures, attached well after boot, so the
bootloader has never seen them.  They simply refuse to mount to a running
Linux system because, when the storage for partition size and start was
expanded to 64-bit, no one bothered to fix the intermediate storage in
msdos.c, so the kernel cannot locate the start nor figure the size of
the partitions.

Logically, this patch is not complicated.  The data types in msdos.c
are flat-out wrong, given that the real stored data is of type sector_t.
The intermediate variables should not be u32.

For users of small disks, that are not shared with Windows XP, the patch
is totally innocuous.  It does not diminish any existing working behavior,
for anyone, nor change any API, so I do not understand the resistance to
using it.

> 
> So, maybe this wouldn't be so major problem for normal users, and what
> is needed actually is not sure to me for now (I guess it might be
> depending to BIOS, if boot loader is using BIOS call.).
> 
> So, this patch provides one logical sector, but it's just guess.
> 
> > OTOH, it would be reasonable to wait until someone else had 
> a chance to
> > test the change.  We are awaiting NDAs from RedHat, Canonical, and
> > Novell/SUSE to send them the affected products for 
> library/application
> > development.
> 
> Thanks.
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
