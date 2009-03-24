Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZCXNyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZCXNyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZCXNyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:54:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42381 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbZCXNyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:54:31 -0400
Date: Tue, 24 Mar 2009 13:52:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324135249.02e2caa2@lxorguk.ukuu.org.uk>
In-Reply-To: <20090324132032.GK5814@mit.edu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	<20090324103111.GA26691@elte.hu>
	<20090324132032.GK5814@mit.edu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> They don't solve the problem where there is a *huge* amount of writes
> going on, though --- if something is dirtying pages at a rate far

At very high rates other things seem to go pear shaped. I've not traced
it back far enough to be sure but what I suspect occurs from the I/O at
disk level is that two people are writing stuff out at once - presumably
the vm paging pressure and the file system - as I see two streams of I/O
that are each reasonably ordered but are interleaved.

> don't get *that* bad, even with ext3.  At least, I haven't found a
> workload that doesn't involve either dd if=/dev/zero or a massive
> amount of data coming in over the network that will cause fsync()
> delays in the > 1-2 second category.  Ext3 has been around for a long

I see it with a desktop when it pages hard and also when doing heavy
desktop I/O (in my case the repeatable every time case is saving large
images in the gimp - A4 at 600-1200dpi).

The other one (#8636) seems to be a bug in the I/O schedulers as it goes
away if you use a different I/O sched.

> solve.  Simply mounting an ext3 filesystem using ext4, without making
> any change to the filesystem format, should solve the problem.

I will try this experiment but not with production data just yet 8)

> some other users' data files.  This was the reason for Stephen Tweedie
> implementing the data=ordered mode, and making it the default.

Yes and in the server environment or for typical enterprise customers
this is a *big issue*, especially the risk of it being undetected that
they just inadvertently did something like put your medical data into the
end of something public during a crash.

> Try ext4, I think you'll like it.  :-)

I need to, so that I can double check none of the open jbd locking bugs
are there and close more bugzilla entries (#8147)

Thanks for the reply - I hadn't realised a lot of this was getting fixed
but in ext4 and quietly

Alan
