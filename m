Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbZD0Ln4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbZD0Ln4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZD0Lnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:43:47 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:64849 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZD0Lnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:43:46 -0400
Message-ID: <49F59A6E.9080900@monstr.eu>
Date: Mon, 27 Apr 2009 13:43:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <1240821139-7247-24-git-send-email-monstr@monstr.eu> <1240821139-7247-25-git-send-email-monstr@monstr.eu> <1240821139-7247-26-git-send-email-monstr@monstr.eu> <1240821139-7247-27-git-send-email-monstr@monstr.eu> <1240821139-7247-28-git-send-email-monstr@monstr.eu> <1240821139-7247-29-git-send-email-monstr@monstr.eu> <1240821139-7247-30-git-send-email-monstr@monstr.eu> <20090427095815.GA12323@infradead.org> <49F58A87.5020405@monstr.eu> <20090427113030.GA3681@infradead.org>
In-Reply-To: <20090427113030.GA3681@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Apr 27, 2009 at 12:35:51PM +0200, Michal Simek wrote:
>> types and I would like to know about more info.
>> For example
>> If make sense long long	type for st_blocks. IMHO unsigned will be better.
>> And I would like to create new stat64 structure where is not a fault for both noMMU/MMU version.
>> In noMMU implementation is st_blocks unsigned long. Is it OK? or unsigned long long is better?
> 
> You want unsigned long long for it.  Take a look at e.g. the xtensa
> stat.h and just reuse that one.  We should probaly create an
> asm-generic/stat.h that new architectures can simply use..
> 
> Given that microblaze only got merged in the 2.6.30 window I would
> suggest fixing up the nommu variant.

ok. Let's do it.
Here are stats structures from xtensa.

Arnd: Is it ok for asm-generic?

Thanks,
Michal

#ifndef _XTENSA_STAT_H
#define _XTENSA_STAT_H

#define STAT_HAVE_NSEC 1

struct stat {
	unsigned long	st_dev;
	unsigned long	st_ino;
	unsigned int	st_mode;
	unsigned int	st_nlink;
	unsigned int	st_uid;
	unsigned int	st_gid;
	unsigned long	st_rdev;
	long		st_size;
	unsigned long	st_blksize;
	unsigned long	st_blocks;
	unsigned long	st_atime;
	unsigned long	st_atime_nsec;
	unsigned long	st_mtime;
	unsigned long	st_mtime_nsec;
	unsigned long	st_ctime;
	unsigned long	st_ctime_nsec;
	unsigned long	__unused4;
	unsigned long	__unused5;
};

struct stat64  {
	unsigned long long st_dev;	/* Device */
	unsigned long long st_ino;	/* File serial number */
	unsigned int  st_mode;		/* File mode. */
	unsigned int  st_nlink;		/* Link count. */
	unsigned int  st_uid;		/* User ID of the file's owner. */
	unsigned int  st_gid;		/* Group ID of the file's group. */
	unsigned long long st_rdev;	/* Device number, if device. */
	long long st_size;		/* Size of file, in bytes. */
	unsigned long st_blksize;	/* Optimal block size for I/O. */
	unsigned long __unused2;
	unsigned long long st_blocks;	/* Number 512-byte blocks allocated. */
	unsigned long st_atime;		/* Time of last access. */
	unsigned long st_atime_nsec;
	unsigned long st_mtime;		/* Time of last modification. */
	unsigned long st_mtime_nsec;
	unsigned long st_ctime;		/* Time of last status change. */
	unsigned long st_ctime_nsec;
	unsigned long __unused4;
	unsigned long __unused5;
};



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
