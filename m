Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZLVMm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZLVMm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZLVMmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:42:25 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:50877
	"EHLO QMTA13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924AbZLVMmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:42:24 -0500
Message-ID: <4B30BEC9.5030706@byu.net>
Date: Tue, 22 Dec 2009 05:42:49 -0700
From: Eric Blake <ebb9@byu.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp> <4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net> <87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net> <20091222123436.GC9611@discord.disaster>
In-Reply-To: <20091222123436.GC9611@discord.disaster>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Dave Chinner on 12/22/2009 5:34 AM:
> Yeah, it looks like the change to utimesat() back in 2.6.26 for
> posix conformance made ATTR_CTIME appear outside inode truncation
> and XFS wasn't updated for this change in behaviour at the VFS level.
> Looks simple to fix, but I'm worried about introducing other
> unintended ctime modifications - is there a test suite that checks
> posix compliant atime/mtime/ctime behaviour around anywhere?

Yes - the gnulib unit test, consisting of:

http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/nap.h
http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-utimens-common.h
http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-utimens.h
http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-lutimens.h
http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-futimens.h
http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-futimens.c
http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-utimensat.c

Taken together, these files produce the executables test-futimens and
test-utimensat which can demonstrate compliance with POSIX.  They are also
bundled as part of GNU coreutils (the version bundled with coreutils 8.2
didn't test for ctime compliance, and coreutils 8.3 hasn't been released
yet) if you use 'make -C gnulib-tests check'.

-- 
Don't work too hard, make some time for fun as well!

Eric Blake             ebb9@byu.net
