Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182Ab0CGXD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 18:03:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59657 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab0CGXD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 18:03:26 -0500
Message-ID: <4B9430B6.701@zytor.com>
Date: Sun, 07 Mar 2010 15:03:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msdos: add support for large disks
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com>	<20100301141335.395dc4c3.akpm@linux-foundation.org>	<873a0h1p2c.fsf@devron.myhome.or.jp> <876358iehd.fsf@devron.myhome.or.jp>
In-Reply-To: <876358iehd.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 02:59 AM, OGAWA Hirofumi wrote:
> This part is broken. If "size" is smaller than minimum blocksize (note,
> "size" is number of 512b, not number of blocksize), we can't read any
> block after all (it is handled as outside of i_size by bdev).
>
> Peter (or someone) know what do we want to in here? This is on extended
 > partition itself (e.g. if sda1 sda2<sda5 sda6>, it's the size of sda2)

We should presumably set it to one logical sector, regardless of size. 
Either that, or the offset of the lowest contained partition.

> [BTW, it seems subtypes stuff is not thinking about sector size>  512b...]

Much else isn't, either.  With the exception of some MO disks, it was 
nearly unheard of for 20 years.

	-hpa
