Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZCZCwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZCZCwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZCZCwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:52:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48425 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbZCZCwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:52:07 -0400
Message-ID: <49CAEDA7.1080902@garzik.org>
Date: Wed, 25 Mar 2009 22:51:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324093245.GA22483@elte.hu>	 <20090324041249.1133efb6.akpm@linux-foundation.org>	 <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu>	 <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>	 <20090325185824.GO32307@mit.edu> <20090325194851.GA1617@infradead.org>	 <20090325215016.GP32307@mit.edu>	 <20090326021034.GA26559@srcf.ucam.org>	 <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com> <f73f7ab80903251946u593216eejb75d77c54fc8bdf@mail.gmail.com>
In-Reply-To: <f73f7ab80903251946u593216eejb75d77c54fc8bdf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
>> Really, the problem is the filesystem interfaces are incomplete.  There are plenty of ways to specify a "FLUSH CACHE"-type command for an individual file or for the whole filesystem, but there aren't really any ways for programs to specify barriers (either whole-blockdev or per-LBA-range).  An fsync() implies you want to *wait* for the data... there's no way to ask it all to be queued with some ordering constraints.
>> Perhaps we ought to add a couple extra open flags, O_BARRIER_BEFORE and O_BARRIER_AFTER, and rename3(), etc functions that take flags arguments?
>> Or maybe a new set of syscalls like barrier(file1, file2) and fbarrier(fd1, fd2), which cause all pending changes (perhaps limit to this process?) to the file at fd1 to occur before any successive changes (again limited to this process?) to the file at fd2.
>> It seems that rename(oldfile, newfile) with an already-existing newfile should automatically imply barrier(oldfile, newfile) before it occurs, simply because so many programs rely on that.
>> In the cross-filesystem case, the fbarrier() might simply fsync(fd1), since that would provide the equivalent guarantee, albeit with possibly significant performance penalties.  I can't think of any easy way to prevent one filesystem from syncing writes to a particular file until another filesystem has finished an asynchronous fsync() call.  Perhaps a half-way solution would be to asynchronously fsync(fd1) and simply block the next write()/ioctl()/etc on fd2 until the async fsync returns.

Then you have just reinvented the transactional userspace API that 
people often want to replace POSIX API with.  Maybe one day they will 
succeed.

But "POSIX API replacement" is an area never short of proposals... :)

	Jeff



