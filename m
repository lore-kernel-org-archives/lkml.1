Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZLWHxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZLWHxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 02:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZLWHxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 02:53:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZLWHxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 02:53:24 -0500
Date: Wed, 23 Dec 2009 02:53:02 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Blake <ebb9@byu.net>
Cc: Dave Chinner <david@fromorbit.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, Christoph Hellwig <hch@lst.de>
Subject: Re: utimensat fails to update ctime
Message-ID: <20091223075302.GA27744@infradead.org>
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp> <4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net> <87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net> <20091222123436.GC9611@discord.disaster> <4B30BEC9.5030706@byu.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B30BEC9.5030706@byu.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 05:42:49AM -0700, Eric Blake wrote:
> According to Dave Chinner on 12/22/2009 5:34 AM:
> > Yeah, it looks like the change to utimesat() back in 2.6.26 for
> > posix conformance made ATTR_CTIME appear outside inode truncation
> > and XFS wasn't updated for this change in behaviour at the VFS level.
> > Looks simple to fix, but I'm worried about introducing other
> > unintended ctime modifications - is there a test suite that checks
> > posix compliant atime/mtime/ctime behaviour around anywhere?
> 
> Yes - the gnulib unit test, consisting of:
> 
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/nap.h
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-utimens-common.h
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-utimens.h
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-lutimens.h
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-futimens.h
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-futimens.c
> http://git.savannah.gnu.org/cgit/gnulib.git/tree/tests/test-utimensat.c
> 
> Taken together, these files produce the executables test-futimens and
> test-utimensat which can demonstrate compliance with POSIX.  They are also
> bundled as part of GNU coreutils (the version bundled with coreutils 8.2
> didn't test for ctime compliance, and coreutils 8.3 hasn't been released
> yet) if you use 'make -C gnulib-tests check'.

Ok, I'll see if I can add the last GPLv2 licensed version into xfstests.

