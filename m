Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYEDWcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYEDWcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 18:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYEDWcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 18:32:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:53625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYEDWcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 18:32:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 42/56] microblaze_v2: stats headers
Date: Mon, 5 May 2008 00:31:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu> <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
In-Reply-To: <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805050031.40054.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18GUJo7wkTL7M0NJnLivngMI8rA43xBZZuJZVW
 HOO6grT+KFRscsykGvmD2iQlNP0ZDO8cpS1RA8/msI/HiSWH6z
 a0kH1uYZbOdlzFNBJKPLg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:
> +struct stat {
> +	unsigned int	st_dev;
> +	unsigned long	st_ino;
> +	unsigned int	st_mode;
> +	unsigned int	st_nlink;
> +	unsigned int	st_uid;
> +	unsigned int	st_gid;
> +	unsigned int	st_rdev;
> +	long		st_size;
> +	unsigned long	st_blksize;
> +	unsigned long	st_blocks;
> +	unsigned long	st_atime;
> +	unsigned long	__unused1;
> +	unsigned long	st_mtime;
> +	unsigned long	__unused2;
> +	unsigned long	st_ctime;
> +	unsigned long	__unused3;
> +	unsigned long	__unused4;
> +	unsigned long	__unused5;
> +};
> +
> +struct stat64 {
> +	unsigned long long	st_dev;
> +	unsigned long	__unused1;
> +
> +	unsigned long long	st_ino;
> +
> +	unsigned int	st_mode;
> +	unsigned int	st_nlink;
> +
> +	unsigned int	st_uid;
> +	unsigned int	st_gid;
> +
> +	unsigned long long	st_rdev;
> +	unsigned long	__unused3;
> +
> +	long long	st_size;
> +	unsigned long	st_blksize;
> +
> +	unsigned long	st_blocks; /* No. of 512-byte blocks allocated */
> +	unsigned long	__unused4; /* future possible st_blocks high bits */
> +
> +	unsigned long	st_atime;
> +	unsigned long	st_atime_nsec;
> +
> +	unsigned long	st_mtime;
> +	unsigned long	st_mtime_nsec;
> +
> +	unsigned long	st_ctime;
> +	unsigned long	st_ctime_nsec;
> +
> +	unsigned long	__unused8;
> +};

There should only be a 'struct stat', not stat64, and it would be nice
to have that in asm-generic/stat.h.

I think it should be defined as

struct stat {
	unsigned long long	st_dev;

	unsigned long long	st_ino;

	unsigned int		st_mode;
	unsigned int		st_nlink;

	unsigned int		st_uid;
	unsigned int		st_gid;

	unsigned long long	st_rdev;

	long long		st_size;

	unsigned int		st_blksize;
	unsigned int		__unused1;

	unsigned long long	st_blocks; /* No. of 512-byte blocks allocated */

	unsigned int		st_atime;
	unsigned int		st_atime_nsec;

	unsigned int		st_mtime;
	unsigned int		st_mtime_nsec;

	unsigned int		st_ctime;
	unsigned int		st_ctime_nsec;

	unsigned int		__unused2;
	unsigned int		__unused3;
};

This way, you don't have any unnecessary padding, and the structure
is compatible in 32 and 64 bit architectures.

	Arnd <><
