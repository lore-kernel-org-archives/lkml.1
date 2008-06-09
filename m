Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYFIBa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYFIBa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 21:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYFIBas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 21:30:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYFIBar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 21:30:47 -0400
Message-ID: <484C83D9.2020402@kernel.org>
Date: Sun, 08 Jun 2008 18:14:01 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Adrian Bunk <bunk@kernel.org>,
       =?UTF-8?B?IlMuw4dhxJ9sYXIgT251ciI=?= <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       =?UTF-8?B?T251ciBLw7zDp8O8aw==?= <onur@pardus.org.tr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.26 patch] fat_valid_media() isn't for userspace
References: <200806082116.50355.caglar@pardus.org.tr>	<20080608184310.GD4048@cs181133002.pp.htv.fi> <87prqrn4d8.fsf@duaron.myhome.or.jp>
In-Reply-To: <87prqrn4d8.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> 
> Yes. This is new one, so it shouldn't have any users of that.
> Looks more better. Thanks.
> 

The other thing about this header that needs to be fixed is the 
definition of the following ioctls:

#define VFAT_IOCTL_READDIR_BOTH         _IOR('r', 1, struct dirent [2])
#define VFAT_IOCTL_READDIR_SHORT        _IOR('r', 2, struct dirent [2])

"struct dirent" is a kernel type here, but is a **different type** in 
userspace!  This means both the structure and the IOCTL number is wrong!

We need to make this either __kernel_dirent_t[*] or something like 
struct __msdos_fs_dirent.

	-hpa

[*] Yes, typedefs suck, but unfortunately C doesn't allow aliases in the 
structure tag namespace.
