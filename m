Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZCXPTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZCXPTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZCXPTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:19:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38587 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753430AbZCXPTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:19:37 -0400
Date: Tue, 24 Mar 2009 15:18:25 +0000
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
Message-ID: <20090324151825.0570f37a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090324142837.GN5814@mit.edu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	<20090324103111.GA26691@elte.hu>
	<20090324132032.GK5814@mit.edu>
	<20090324135249.02e2caa2@lxorguk.ukuu.org.uk>
	<20090324142837.GN5814@mit.edu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Surely the elevator should have reordered the writes reasonably?  (Or
> is that what you meant by "the other one -- #8636 (I assume this is a
> kernel Bugzilla #?) seems to be a bug in the I/O schedulers as it goes
> away if you use a different I/O sched.?")

There are two cases there. One is a bug #8636 (kernel bugzilla) which is
where things like dump show awful performance with certain I/O scheduler
settings. That seems to be totally not connected to the fs but it is a
problem (and has a patch)

The second one the elevator is clearly trying to sort out but its
behaving as if someone is writing the file starting at say 0 and someone
else is trying to write it back starting some large distance further down
the file. The elevator can only do so much then.

> Yeah, I could see that doing it.  How big is the image, and out of
> curiosity, can you run the fsync-tester.c program I posted while

150MB+ for the pnm files from gimp used as temporaries by Eve (Etch
Validation Engine), more like 10MB for xcf/tif files.

> saving the gimp image, and tell me how much of a delay you end up
> seeing?

Added to the TODO list once I can set up a suitable test box (my new dev
box is somewhere between Dell and my desk right now)

> More testing would be appreciated --- and yeah, we need to groom the
> bugzilla.  

I'm currently doing this on a large scale (closed about 300 so far this
run). Bug 8147 might be worth a look as its a case where the jbd locking
and the jbd comments seem to disagree (the comments say you must hold a
lock but we don't seem to)
