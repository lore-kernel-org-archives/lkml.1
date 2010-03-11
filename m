Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab0CKV6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:58:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53908 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757234Ab0CKV6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:58:33 -0500
Message-ID: <4B99677B.80001@zytor.com>
Date: Thu, 11 Mar 2010 13:58:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Daniel Taylor <Daniel.Taylor@wdc.com>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fs/partition/msdos: Fix unusable extended partition
 for > 512B sector
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com><20100301141335.395dc4c3.akpm@linux-foundation.org><873a0h1p2c.fsf@devron.myhome.or.jp><876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com><87pr3fd68r.fsf@devron.myhome.or.jp> <4B9440FC.3090502@zytor.com><87zl2j9muz.fsf@devron.myhome.or.jp><87wrxkw52s.fsf_-_@devron.myhome.or.jp><87sk88w4xk.fsf_-_@devron.myhome.or.jp><3E0C3AE547FA504DA5E89EA5A24AC85803E2BD87@wdscexbe01.sc.wdc.com> <873a07oyts.fsf@devron.myhome.or.jp> <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD8E@wdscexbe01.sc.wdc.com>
In-Reply-To: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD8E@wdscexbe01.sc.wdc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 01:25 PM, Daniel Taylor wrote:
>
> I have not yet tried booting from one of these disks.
>
> They are in USB-attached enclosures,

Right...

> attached well after boot, so the
> bootloader has never seen them.

Wrong.  A lot of BIOSes will attempt to boot from USB storage.  Worse, a 
fair number of BIOSes will hang during startup if a USB storage device 
that confuses them -- even if not the primary boot device.

> They simply refuse to mount to a running
> Linux system because, when the storage for partition size and start was
> expanded to 64-bit, no one bothered to fix the intermediate storage in
> msdos.c, so the kernel cannot locate the start nor figure the size of
> the partitions.
>
> Logically, this patch is not complicated.  The data types in msdos.c
> are flat-out wrong, given that the real stored data is of type sector_t.
> The intermediate variables should not be u32.

I would consider this a bugfix.  As such, it should be pushed outside 
the merge window.

	-hpa
