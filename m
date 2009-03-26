Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbZCZXGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbZCZXGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZCZXG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:06:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbZCZXGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:06:25 -0400
Date: Thu, 26 Mar 2009 15:57:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-Id: <20090326155725.c2150ab2.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0903261534490.3032@localhost.localdomain>
References: <20090324041249.1133efb6.akpm@linux-foundation.org>
	<20090325123744.GK23439@duck.suse.cz>
	<20090325150041.GM32307@mit.edu>
	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	<20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326181106.GC17159@duck.suse.cz>
	<alpine.LFD.2.00.0903261534490.3032@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 15:39:53 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 26 Mar 2009, Jan Kara wrote:
> >
> >   Reads are measurably better with the patch - the test with cat you
> > describe below took ~0.5s per file without the patch and always less than
> > 0.02s with the patch. So it seems to help something.
> 
> That would seem to be a _huge_ improvement.

It's strange that we still don't have an ext3_writepages().  Open a
transaction, do a large pile of writes, close the transaction again. 
We don't even have a data=writeback writepages() implementation, which
should be fairly simple.

Bizarre.

Mingming had a shot at it a few years ago and I think Badari did as
well, but I guess it didn't work out.

Falling back to generic_writepages() on our main local fs is a bit lame.
