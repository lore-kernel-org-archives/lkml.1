Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZFNHUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZFNHUB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 03:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbZFNHTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 03:19:38 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47489 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbZFNHTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 03:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=czBQksv5XjGUlLF7Y8AoKxaSZhsB/IAgveKqBR0WAFHdB8VOubqNafv/jYebp/lqc8
         utdfQW1DspVaT/BQM1cydFVTuZTn95AyAIkuj2Gg2gSiVsGep3ax8YM5/IScSMccP/mS
         4fCOoNKTy+kWK6v7qvsdR0BhB4CMx02OMOC8Q=
Message-ID: <4A34A39D.20803@gmail.com>
Date: Sun, 14 Jun 2009 09:15:41 +0200
From: Marco <marco.stornelli@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 06/14] Pramfs: Include files
References: <4A33A7EC.6070008@gmail.com> <20090613140459.GC30053@uranus.ravnborg.org>
In-Reply-To: <20090613140459.GC30053@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sat, Jun 13, 2009 at 03:21:48PM +0200, Marco wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> +#include <linux/types.h>
>> +
>> +#ifdef __KERNEL__
>> +#include <linux/sched.h>
>> +#include <linux/buffer_head.h>
>> +#include "pram_fs_sb.h"
>> +#endif
> 
> The only reason to have this header file in include/linux/
> is that it is used by userspace.
> So please split it up so we have one header suitable for exporting
> and another header with all the promfs local stuff.
> The latter should be in fs/pramsfs/

Yeah you're right. Actually it's not used by userspace so I think I can
remove the ifdef.

> 
> 
>> +
>> +
>> +/*
>> + * Debug code
>> + */
>> +#ifdef __KERNEL__
>> +#define PFX "pramfs"
>> +#ifdef PRAMFS_DEBUG
>> +#define pram_dbg(format, arg...) \
>> +    printk(KERN_DEBUG PFX ": " format , ## arg)
>> +#else
>> +#define pram_dbg(format, arg...) do {} while (0)
>> +#endif
>> +#define pram_err(format, arg...) \
>> +    printk(KERN_ERR PFX ": " format , ## arg)
>> +#define pram_info(format, arg...) \
>> +    printk(KERN_INFO PFX ": " format , ## arg)
>> +#define pram_warn(format, arg...) \
>> +    printk(KERN_WARNING PFX ": " format , ## arg)
>> +#endif
> 
> For a typical drivers we have some pr_* to avoid the above.
> Can they be used for a filesystem too?

Ok, I'll use them.

> 
>> +
>> +/*
>> + * The PRAM file system magic number
>> + */
>> +#define PRAM_SUPER_MAGIC	0xEFFA
> 
> Move to include/linux/magic.h
> 

Ok.

>> +
>> +/*
>> + * Structure of an inode in PRAMFS
>> + */
>> +struct pram_inode {
>> +	__u32   i_sum;          /* checksum of this inode */
>> +	__u32	i_uid;		/* Owner Uid */
>> +	__u32	i_gid;		/* Group Id */
>> +	__u16	i_mode;		/* File mode */
>> +	__u16	i_links_count;	/* Links count */
>> +	__u32	i_blocks;	/* Blocks count */
>> +	__u32	i_size;		/* Size of data in bytes */
>> +	__u32	i_atime;	/* Access time */
>> +	__u32	i_ctime;	/* Creation time */
>> +	__u32	i_mtime;	/* Modification time */
>> +	__u32	i_dtime;	/* Deletion Time */
>> +
>> +	union {
>> +		struct {
>> +			/*
>> +			 * ptr to row block of 2D block pointer array,
>> +			 * file block #'s 0 to (blocksize/4)^2 - 1.
>> +			 */
>> +			off_t row_block;
> 
> It is my understanding that we shall use: __kernel_off_t
> in exported headers.
> 
> The headers are not added to Kbuild - so it is not exported.
> I assume thats an oversight.
> 
> 	Sam
> 

As I said it shouldn't be an exported header.

Marco



