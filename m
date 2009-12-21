Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbZLUPFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZLUPFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZLUPFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:05:33 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57229 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbZLUPFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:05:32 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Eric Blake <ebb9@byu.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       Christoph Hellwig <hch@lst.de>
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
Date: Tue, 22 Dec 2009 00:05:27 +0900
In-Reply-To: <4B2F7A95.3010708@byu.net> (Eric Blake's message of "Mon, 21 Dec
	2009 06:39:33 -0700")
Message-ID: <87hbrkjrk8.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Blake <ebb9@byu.net> writes:

According to OGAWA Hirofumi on 12/21/2009 12:31 AM:
>>> This in turn caused a regression in coreutils 8.2, visible through 'touch -a':
>>> http://lists.gnu.org/archive/html/bug-coreutils/2009-12/msg00171.html
>>>
>>> GNU coreutils will end up working around the bug by calling fstat/[l]stat
>>> prior to futimens/utimensat, and populating the mtime field with the
>>> desired value rather than using UTIME_OMIT.  But this is a pointless stat
>>> call, which could be avoided if the kernel were fixed to comply with POSIX
>>> by updating ctime even when mtime is UTIME_OMIT.
>> 
>> I couldn't reproduce this with your test program on my machine (latest
>> linus tree). And that utime path looks like no problem, um..., can you
>> provide output of strace or something?

> According to Eric Blake on 12/21/2009 6:12 AM:
>
> It may also be file-system dependent.  On the machine where I saw the
> original failure:
>> $ uname -a
>> Linux fencepost 2.6.26-2-xen-amd64 #1 SMP Thu Nov 5 04:27:12 UTC 2009
>> x86_64 GNU/Linux
>
> $ df -T .
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/sdb1      xfs   419299328 269018656 150280672  65% /srv/data

Thanks.

This is good point. This would be xfs issue or design. xfs seems to have
own special handling of ctime.

Cc: to xfs peoples. Any idea?

> But on the machine where the test case is working:
>> $ uname -a
>> Linux vladim 2.6.31.6-166.fc12.i686 #1 SMP Wed Dec 9 11:14:59 EST 2009
>> i686 GNU/Linux
>
> $ df -T .
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/sda3     ext3    34123236  25894932   6494892  80% /

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
