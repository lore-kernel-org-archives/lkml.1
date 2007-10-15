Return-Path: <linux-kernel-owner+w=401wt.eu-S1765175AbXJOQjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765175AbXJOQjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759689AbXJOQi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:38:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56620 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbXJOQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:38:55 -0400
Subject: Re: nfs mmap adventure (was: 2.6.23-mm1)
From: Peter Zijlstra <peterz@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <1192463489.7529.11.camel@heimdal.trondhjem.org>
References: <1192451324.27435.71.camel@twins>
	 <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <21859.1192457172@redhat.com>
	 <1192463489.7529.11.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 18:38:34 +0200
Message-Id: <1192466314.27435.84.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 11:51 -0400, Trond Myklebust wrote:
> On Mon, 2007-10-15 at 15:06 +0100, David Howells wrote:
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > I get funny SIGBUS' like so:
> > > 
> > > fault
> > >   if (->page_mkwrite() < 0)
> > >     nfs_vm_page_mkwrite()
> > >       nfs_write_begin()
> > >         nfs_flush_incompatible()
> > >           nfs_wb_page()
> > >             nfs_wb_page_priority()
> > >               nfs_sync_mapping_wait()
> > >                 nfs_wait_on_request_locked()
> > >                   nfs_wait_on_request()
> > >                     nfs_wait_bit_interruptible()
> > >                       return -ERESTARTSYS
> > >     SIGBUS
> > > 
> > > trying to figure out what to do about this...
> > > 
> > 
> > Hmmm...  It sounds like the fault handler should deliver the appropriate
> > signal, should ->page_mkwrite() return ERESTARTSYS, and then retry the access
> > instruction that caused the fault when the signal handler has finished
> > running.
> 
> If you signal the process before msync() has completed, or before you
> have completed unmapping the region then your writes can potentially be
> lost. Why should we be providing any guarantees beyond that?

Good point, I'm trying to figure out where my signal is comming from.


