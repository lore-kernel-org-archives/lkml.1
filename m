Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0CHAJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 19:09:16 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:47975 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0CHAJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 19:09:12 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msdos: add support for large disks
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>
	<20100301141335.395dc4c3.akpm@linux-foundation.org>
	<873a0h1p2c.fsf@devron.myhome.or.jp>
	<876358iehd.fsf@devron.myhome.or.jp> <4B9430B6.701@zytor.com>
Date: Mon, 08 Mar 2010 09:09:08 +0900
In-Reply-To: <4B9430B6.701@zytor.com> (H. Peter Anvin's message of "Sun, 07
	Mar 2010 15:03:18 -0800")
Message-ID: <87pr3fd68r.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 03/07/2010 02:59 AM, OGAWA Hirofumi wrote:
>> This part is broken. If "size" is smaller than minimum blocksize (note,
>> "size" is number of 512b, not number of blocksize), we can't read any
>> block after all (it is handled as outside of i_size by bdev).
>>
>> Peter (or someone) know what do we want to in here? This is on extended
>  > partition itself (e.g. if sda1 sda2<sda5 sda6>, it's the size of sda2)
>
> We should presumably set it to one logical sector, regardless of size. 
> Either that, or the offset of the lowest contained partition.

It means,

	min(size, max(logical_sector_size / 512, 2));

or like this? ("size" is "nr_sects(part) * (logical_sector_size/512)")

This should keep old logic, i.e. if partition is bigger than 1kb, it
uses 1kb for (probably) LILO mentioned by comment.

>> [BTW, it seems subtypes stuff is not thinking about sector size>  512b...]
>
> Much else isn't, either.  With the exception of some MO disks, it was 
> nearly unheard of for 20 years.

Yes. So, well, if someone know the spec of those subtypes, let us know.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
