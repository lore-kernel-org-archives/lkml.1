Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0BXHDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:03:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab0BXHDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:03:53 -0500
Date: Tue, 23 Feb 2010 23:03:49 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Bret Towe <magnade@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reiserfs-devel@vger.kernel.org
Subject: Re: reiserfs issue with 2.6.32.8
In-Reply-To: <dda83e781002232131i53b59c8eu7192257fc4e4f3e0@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1002232249440.28195@bogon.housecafe.de>
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>  <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de> <dda83e781002232131i53b59c8eu7192257fc4e4f3e0@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/715YTZ5ZxA+nCTUbX4MLFYDIT2FN+KmjJXeR
 FUc0Ne1Y0zxwfVIeeIVD7HS4G20szhPfu/Gxs880leynuPpOLF
 9vj13IosN5gh7l6/CwksA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 at 21:31, Bret Towe wrote:
> ok attached is strace log of cp on 2.6.32.9

I've run cp through strace as well (copying something from an XFS 
partition to a reiserfs partition, I guess that's what you did too), and 
noticed a small difference at the end:

< open("/home/foo/1", O_RDONLY)          = 3
< fstat(3, {st_mode=S_IFREG|0640, st_size=755, ...}) = 0
< open("2", O_WRONLY|O_CREAT|O_EXCL, 0640) = 4         

While your cp(1) did:

> open("downloads/[DB]_Bleach_258_[27104F7A].avi", O_RDONLY) = 3
> fstat(3, {st_mode=S_IFREG|0644, st_size=178308328, ...}) = 0
> open("/mdhd/media/Episodes/unwatched/[DB]_Bleach_258_[27104F7A].avi", O_WRONLY|O_CREAT|O_EXCL, 0644) = -1 EINVAL (Invalid argument)


And open(2) will return -EINVAL when:
   - The implementation does not support synchronised I/O for this file. 
   - The value of the oflag argument is not valid.

As we're not passing O_SYNC, it's the latter, if I read this correctly. Which
still doesn't explain *why* (the filesystem?) returns "invalid flag". 

> now I've had a hd drop out of raid (running checks on it atm)

Hm, maybe it's all hardware related after all, let's see what these checks 
turn up. Strange though, that nothing gets reported in dmesg...

Christian.
-- 
BOFH excuse #159:

Stubborn processes
