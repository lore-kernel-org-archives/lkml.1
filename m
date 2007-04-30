Return-Path: <linux-kernel-owner+w=401wt.eu-S1423348AbXD3PPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423348AbXD3PPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423347AbXD3PPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:15:41 -0400
Received: from thunk.org ([69.25.196.29]:52658 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453AbXD3PPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:15:06 -0400
To: linux-ext4@vger.kernel.org
cc: Johann Lombardi <johann.lombardi@bull.net>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Dave Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: 2.6.21-ext4-1
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Date: Mon, 30 Apr 2007 11:14:57 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've respun the ext4 development patchset, with Amit's updated fallocate
patches.  I've added Dave's patch to add ia64 support to the fallocate
system call, but *not* the XFS fallocate support patches.  (Probably
better for them to live in an xfs tree, where they can more easily
tested and updated.)  Yes, we haven't reached complete closure on the
fallocate system call calling convention, but it's enough for us to get
more testing in -mm.

Also added Johann's jbd2-stats-through-procfs patches; it provides
useful help in turning the size of the journal, which will be useful in
benchmarking efforts.  In addition, Alex Tomas's patch to free
just-allocated patches when there is an error inserting the extent into
the extent tree has also been included.

The patches have been compile-tested on x86, and compile/run-tested on
x86/UML.  Would appreciate reports about testing on other platforms.

Thanks,

						- Ted

P.S.  One bug which I've noted --- if there is a failure due to disk
filling up, running e2fsck on the filesystem will show that the i_blocks
fields on the inodes where there was a failure to allocate disk blocks
are left incorrect.  I'm guessing this is a bug in the delayed
allocation patches.  Alex, when you have a moment, could you take a
look?  Thanks!!
