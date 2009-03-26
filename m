Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbZCZTA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbZCZTA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758411AbZCZTAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:00:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40850 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758859AbZCZTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:00:05 -0400
Date: Thu, 26 Mar 2009 18:59:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326185900.166a1097@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
References: <20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
	<20090326140312.GB14822@elte.hu>
	<20090326144707.GA6239@mit.edu>
	<alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
	<20090326170714.GF6239@mit.edu>
	<alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And what's the argument for not doing it in the kernel?
> 
> The fact is, "atime" by default is just wrong.

It probably was a wrong default - twenty years ago. Actually it may well
have been a wrong default in Unix v6 8)

However
- atime behaviour is SuS required
- there are users with systems out there using atime and dependant on
  proper atime

So we can't change the ABI on them any more than we can decide that next
week write() should return short values on writes to disk interrupted by
signals...

Letting distros flip to relatime means new installs and gradual migration
occurs and nobody gets spectacularly blown up when their archiving
system, their usage profiling and disk balancing tools and the like go
wrong.
