Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbYFBLnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbYFBLnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 07:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbYFBLnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 07:43:24 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5991 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759580AbYFBLnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 07:43:23 -0400
Date: Mon, 2 Jun 2008 13:43:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@suse.cz>, mtk.manpages@gmail.com,
       Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sync_file_range(SYNC_FILE_RANGE_WRITE) blocks?
Message-ID: <20080602114319.GI5757@kernel.dk>
References: <20080530102619.GA2468@elf.ucw.cz> <Pine.LNX.4.64.0805301451020.19914@blonde.site> <20080530204307.GA4978@ucw.cz> <Pine.LNX.4.64.0805311925190.27293@blonde.site> <20080531173950.c4f04028.akpm@linux-foundation.org> <Pine.LNX.4.64.0806010752510.24919@blonde.site> <20080601011501.199af80c.akpm@linux-foundation.org> <20080601114008.GC16843@elf.ucw.cz> <20080601133727.4e62ae55.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601133727.4e62ae55.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01 2008, Andrew Morton wrote:
> > > I expect major users of this system call will be applications which do
> > > small-sized overwrites into large files, mainly databases.  That is,
> > > once the application developers discover its existence.  I'm still
> > > getting expressions of wonder from people who I tell about the
> > > five-year-old fadvise().
> > 
> > Hey, you have one user now, its called s2disk. But for this call to be
> > useful, we'd need asynchronous variant... is there such thing?
> 
> Well if you're asking the syscall to shove more data into the block
> layer than it can concurrently handle, sure, the block layer will
> block.  It's tunable...

Ehm, lets get the history right, please :-)

The block layer pretty much doesn't care about how large the queue
size is, it's largely at 128 to prevent the vm from shitting itself
like it has done in the past (and continues to do I guess, though
your reply leaves me wondering).

So you think the vm will be fine with a huge number of requests?
It wont go nuts scanning and reclaiming, wasting oodles of CPU
cycles?

-- 
Jens Axboe

