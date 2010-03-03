Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab0CCW74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:59:56 -0500
Received: from wdscspam2.wdc.com ([129.253.170.131]:3783 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0CCW7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:59:49 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 17:59:49 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] msdos: add support for large disks
Date: Wed, 3 Mar 2010 14:50:02 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD53@wdscexbe01.sc.wdc.com>
In-Reply-To: <873a0h1p2c.fsf@devron.myhome.or.jp>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] msdos: add support for large disks
Thread-Index: Acq62h1eIGo12+LySnmUC0YkqHQTlQARth4Q
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com><20100301141335.395dc4c3.akpm@linux-foundation.org> <873a0h1p2c.fsf@devron.myhome.or.jp>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Mar 2010 22:50:04.0636 (UTC) FILETIME=[DD68C1C0:01CABB23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: OGAWA Hirofumi [mailto:hirofumi@mail.parknet.co.jp] 
Sent: Wednesday, March 03, 2010 6:02 AM
To: Andrew Morton
Cc: Daniel Taylor; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msdos: add support for large disks

Andrew Morton <akpm@linux-foundation.org> writes:

>> On Wed, 24 Feb 2010 19:17:47 -0800
>> "Daniel Taylor" <Daniel.Taylor@wdc.com> wrote:
>>
>>> In order to use disks larger than 2TiB on Windows XP, it is necessary 
>>> to use 4096-byte logical sectors in an MBR.

> BTW, you can use GPT instead?

Windows XP does not support GPT, although Vista/7 do.

> And to make sure, "4096-byte logical sectors in an MBR" is meaning, the
storage must be supporting 4096B and is using it?

The drives report physical/logical sector sizes of 4096 bytes, which the
kernel correctly detects.  32-bit fields in the MBR are then sufficient for
storage capacites >2TiB (up to 16 TiB), and the storage in struct
parsed_partitions is already sector_t.

>>> Although the kernel storage and functions called from msdos.c used 
>>> "sector_t" internally, msdos.c still used u32 variables, which 
>>> results in the ability to handle XP-compatible large disks.
>>> 
>>> This patch changes the internal variables to "sector_t".
>>> 
>>
>> Please Cc OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> and myself on 
>> this work.

>> BTW, to make sure, this is fs/partitions/, not fs/fat/. So, I'm not sure,
my knowledge is enough or not, and/or you just missed fs/partitions/.

This is definitely a change in fs/partitions (fs/partitions/msdos.c).  I
could not find a maintainer for fs/partitions, but FAT and MBR are vaguely
related.  Andrew Morton asked me to copy you on the change, also.

> Well, I'll make time to check. BTW, basically it sounds good to me except
implementation details. But, I'd like to compare > and check other implement
a bit if possible. IIRC, this is not a well defined specification.

Sanity checking patches is a good idea, particularly from someone who has no
other significant change in place.

> Thanks.
--
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
