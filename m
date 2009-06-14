Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbZFNHVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbZFNHVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 03:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbZFNHUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 03:20:14 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60455 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbZFNHUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 03:20:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Sb6NmaljHD1y1GB5FWzSUPk2XuH8Z8fG/MTDP3ZJwNk1E47i/LpVyELmAU8XXeTgZ3
         GlsV9GFNqd+yhgu+qysXtNAV/6+7mjz9/6mMf2ecMPsGzTikOXP62RxyTgbNBv+69vgK
         Z0qiTugWnqEYhFdyF8282Xx6aNXdG0ibZeEMA=
Message-ID: <4A34A3C0.80103@gmail.com>
Date: Sun, 14 Jun 2009 09:16:16 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 14/14] Pramfs: XIP operations
References: <4A33A841.6080902@gmail.com> <20090613140647.GD30053@uranus.ravnborg.org>
In-Reply-To: <20090613140647.GD30053@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sat, Jun 13, 2009 at 03:23:13PM +0200, Marco wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> XIP operations.
>>
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>> ---
>>
>> diff -uprN linux-2.6.30-orig/fs/pramfs/xip.c linux-2.6.30/fs/pramfs/xip.c
>> --- linux-2.6.30-orig/fs/pramfs/xip.c	1970-01-01 01:00:00.000000000 +0100
>> +++ linux-2.6.30/fs/pramfs/xip.c	2009-06-13 12:54:26.000000000 +0200
>> @@ -0,0 +1,90 @@
>> +/*
>> + * FILE NAME fs/pramfs/xip.c
>> + *
>> + * BRIEF DESCRIPTION
>> + *
>> + * XIP operations.
>> + *
>> + * Copyright 2009 Marco Stornelli <marco.stornelli@gmail.com>
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2. This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#include <linux/mm.h>
>> +#include <linux/fs.h>
>> +#include <linux/genhd.h>
>> +#include <linux/buffer_head.h>
>> +#include "pram_fs.h"
>> +#include "xip.h"
>> +
>> +static int pram_find_and_alloc_blocks(struct inode *inode, sector_t iblock,
>> +				     sector_t *data_block, int create)
>> +{
>> +	int err = -EIO;
>> +	off_t block;
>> +
>> +	lock_kernel();
> 
> Can we find other solutions than taking the BKL?
> We are trying to get rid of it.
> 

I know. It wasn't my intention to introduce it but as I said in my first
patch I've done a porting of this code from 2.6.10 and to remove it I
need time to analyze well the code to avoid deadlock and so on. If
someone would like to help me I'd really appreciate it. However I see
the use of BKL even in other recent "mainlined" fs as ext4, so I
preferred to move the porting effort on other areas. However it's the
first item on my todo list.


