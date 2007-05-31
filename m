Return-Path: <linux-kernel-owner+w=401wt.eu-S1761929AbXEaTDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929AbXEaTDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbXEaTCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:02:55 -0400
Received: from brick.kernel.dk ([80.160.20.94]:17290 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130AbXEaTCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:02:54 -0400
Date: Thu, 31 May 2007 21:01:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tom Zanussi <zanussi@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, Linus Torvalds <torvalds@osdl.org>, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070531190150.GE32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk> <1180625611.4514.57.camel@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180625611.4514.57.camel@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31 2007, Tom Zanussi wrote:
> On Thu, 2007-05-31 at 12:33 +0200, Jens Axboe wrote:
> > Hi,
> > 
> > This patch removes the ->sendfile() hook from the file_operations
> > structure, and replaces the sys_sendfile() mechanism to be based on
> > ->splice_read() instead. There should be no functional changes.
> > 
> > Work to be done:
> > 
> > - The ext2 xip support needs a splice_read() implementation, currently I
> >   just if 0'ed out the send xip_file_sendfile(). CC'ed Carsten, who
> >   seems to be the author of this code.
> > 
> > - shmem needs a splice_read() implementation. Optimistically CC'ed Hugh.
> > 
> > - nfds: The ->rq_sendfile_ok optimization is gone for now. I can't
> >   determine the value of it, but I'm assuming it's there for a reason.
> >   Any chance this can be converted to splice, or use something else than
> >   ->sendfile()? CC'ed Neil.
> > 
> > - relay: needs a splice_read() implementation. I think Tom already has
> >   one, CC'ed him.
> > 
> 
> Hi Jens,
> 
> Yeah, I have it lying around somewhere - the patch I sent you awhile
> back of an initial version of splice_read() is the last work I did on
> this.  Basically, it worked OK but IIRC there were a couple things in
> the code that needed fixing.  I also modified blktrace to use splice so
> I could use it for testing; I'll send a patch for that too once I get it
> working again.  
> 
> Anyway, that was ages ago (sometime last year ;-) so I'm going to have
> to dig up the code and probably rework it a bit.

It'd be great if you can polish it a bit (basically just make it apply
to the current kernel). I don't think it's hard, aside from moving the
code from fs/relayfs/ to kernel/relay.c, there hasn't been many changes.

-- 
Jens Axboe

