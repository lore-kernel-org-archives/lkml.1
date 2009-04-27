Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbZD0McB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbZD0McB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 08:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbZD0Mbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 08:31:52 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:18872 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZD0Mbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 08:31:52 -0400
Message-ID: <49F5A5B2.7000307@monstr.eu>
Date: Mon, 27 Apr 2009 14:31:46 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <20090427113030.GA3681@infradead.org> <49F59A6E.9080900@monstr.eu> <200904271357.01681.arnd@arndb.de>
In-Reply-To: <200904271357.01681.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 27 April 2009, Michal Simek wrote:
>> Christoph Hellwig wrote:
> 
>>> Given that microblaze only got merged in the 2.6.30 window I would
>>> suggest fixing up the nommu variant.
>> ok. Let's do it.
>> Here are stats structures from xtensa.
>>
>> Arnd: Is it ok for asm-generic?
> 
> I carry a (not cleaned up) tree with changes in my playground
> (git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git)
> as branch generic-microblaze, where I try to use generic
> headers for everything. See below for my version of stat.h.
> In particular, it uses 64 bit st_size and st_blocks, but 32 bit
> time fields. It also defines struct stat to be identical to
> struct stat64 on 64 bit systems. 32 bit systems should only
> provide the stat64 syscalls, so the shorter types in struct
> stat do not hurt.
> 
> 	Arnd <><
> 
> ---
> #ifndef __ASM_GENERIC_STAT_H
> #define __ASM_GENERIC_STAT_H
> 
> /*
>  * Everybody gets this wrong and has to stick with it for all
>  * eternity. Hopefully, this version gets used by new architectures
>  * so they don't fall into the same traps.
>  *
>  * stat64 is copied from powerpc64, with explicit padding added.
>  * stat is the same structure layout on 64-bit, without the 'long long'
>  * types.
>  *
>  * By convention, 64 bit architectures use the stat interface, while
>  * 32 bit architectures use the stat64 interface. Note that we don't
>  * provide an __old_kernel_stat here, which new architecture should
>  * not have to start with.
>  */
> 
> #include <asm/bitsperlong.h>
> 
> #define STAT_HAVE_NSEC 1
> 
> struct stat {
> 	unsigned long	st_dev;		/* Device.  */
> 	unsigned long	st_ino;		/* File serial number.  */
> 	unsigned int	st_mode;	/* File mode.  */
> 	unsigned int	st_nlink;	/* Link count.  */
> 	unsigned int	st_uid;		/* User ID of the file's owner.  */
> 	unsigned int	st_gid;		/* Group ID of the file's group. */
> 	unsigned long	st_rdev;	/* Device number, if device.  */
> 	unsigned long	__pad1;
> 	long		st_size;	/* Size of file, in bytes.  */

Maybe unsigned? Make more sense to me that file size is not minus.
And for some types below.

Michal


> 	int		st_blksize;	/* Optimal block size for I/O.  */


> 	int		__pad2;
> 	long		st_blocks;	/* Number 512-byte blocks allocated. */

> 	int		st_atime;	/* Time of last access.  */
> 	unsigned int	st_atime_nsec;
> 	int		st_mtime;	/* Time of last modification.  */
> 	unsigned int	st_mtime_nsec;
> 	int		st_ctime;	/* Time of last status change.  */
> 	unsigned int	st_ctime_nsec;
> 	unsigned int	__unused4;
> 	unsigned int	__unused5;
> };
> 
> #if __BITS_PER_LONG != 64
> /* This matches struct stat64 in glibc2.1. Only used for 32 bit. */
> struct stat64 {
> 	unsigned long long st_dev;	/* Device.  */
> 	unsigned long long st_ino;	/* File serial number.  */
> 	unsigned int	st_mode;	/* File mode.  */
> 	unsigned int	st_nlink;	/* Link count.  */
> 	unsigned int	st_uid;		/* User ID of the file's owner.  */
> 	unsigned int	st_gid;		/* Group ID of the file's group. */
> 	unsigned long long st_rdev;	/* Device number, if device.  */
> 	unsigned long long __pad1;
> 	long long	st_size;	/* Size of file, in bytes.  */
> 	int		st_blksize;	/* Optimal block size for I/O.  */
> 	int		__pad2;
> 	long long	st_blocks;	/* Number 512-byte blocks allocated. */
> 	int		st_atime;	/* Time of last access.  */
> 	unsigned int	st_atime_nsec;
> 	int		st_mtime;	/* Time of last modification.  */
> 	unsigned int	st_mtime_nsec;
> 	int		st_ctime;	/* Time of last status change.  */
> 	unsigned int	st_ctime_nsec;
> 	unsigned int	__unused4;
> 	unsigned int	__unused5;
> };
> #endif
> 
> #endif /* __ASM_GENERIC_STAT_H */


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
