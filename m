Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab0CKWRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 17:17:43 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:39859 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865Ab0CKWRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 17:17:41 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition for > 512B sector
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
	<20100301141335.395dc4c3.akpm@linux-foundation.org>
	<873a0h1p2c.fsf@devron.myhome.or.jp>
	<876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com>
	<87pr3fd68r.fsf@devron.myhome.or.jp> <4B9440FC.3090502@zytor.com>
	<87zl2j9muz.fsf@devron.myhome.or.jp>
	<87wrxkw52s.fsf_-_@devron.myhome.or.jp>
	<87sk88w4xk.fsf_-_@devron.myhome.or.jp>
	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD87@wdscexbe01.sc.wdc.com>
	<873a07oyts.fsf@devron.myhome.or.jp>
	<3E0C3AE547FA504DA5E89EA5A24AC85803E2BD8E@wdscexbe01.sc.wdc.com>
Date: Fri, 12 Mar 2010 07:17:36 +0900
In-Reply-To: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD8E@wdscexbe01.sc.wdc.com>
	(Daniel Taylor's message of "Thu, 11 Mar 2010 13:25:55 -0800")
Message-ID: <87vdd2fqpr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Daniel Taylor" <Daniel.Taylor@wdc.com> writes:

>> Of course, if we can fix, it's better.
>> 
>> However, probably, users of this patch would be only boot loader,
>> because this is a first sector on extended-partition itself, not
>> logical-partitions in extended-partition.
>
> I have not yet tried booting from one of these disks.
>
> They are in USB-attached enclosures, attached well after boot, so the
> bootloader has never seen them.  They simply refuse to mount to a running
> Linux system because, when the storage for partition size and start was
> expanded to 64-bit, no one bothered to fix the intermediate storage in
> msdos.c, so the kernel cannot locate the start nor figure the size of
> the partitions.
>
> Logically, this patch is not complicated.  The data types in msdos.c
> are flat-out wrong, given that the real stored data is of type sector_t.
> The intermediate variables should not be u32.
>
> For users of small disks, that are not shared with Windows XP, the patch
> is totally innocuous.  It does not diminish any existing working behavior,
> for anyone, nor change any API, so I do not understand the resistance to
> using it.

Those are all about the first (1/2) patch, not this second patch.
Personally, I'm thinking we should apply the first patch as bugfix.

I'm talking about only second (2/2) patch in here.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
