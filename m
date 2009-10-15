Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbZJOKyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbZJOKyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 06:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbZJOKyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 06:54:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131AbZJOKyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 06:54:09 -0400
Date: Thu, 15 Oct 2009 12:53:32 +0200
From: Nick Piggin <npiggin@suse.de>
To: Anton Blanchard <anton@samba.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: Latest vfs scalability patch
Message-ID: <20091015105332.GB3127@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091015100854.GA19948@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015100854.GA19948@kryten>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 09:08:54PM +1100, Anton Blanchard wrote:
> 
> Hi Nick,
> 
> > Several people have been interested to test my vfs patches, so rather
> > than resend patches I have uploaded a rollup against Linus's current
> > head.
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/
> > 
> > I have used ext2,ext3,autofs4,nfs as well as in-memory filesystems
> > OK (although this doesn't mean there are no bugs!). Otherwise, if your
> > filesystem compiles, then there is a reasonable chance of it working,
> > or ask me and I can try updating it for the new locking.
> > 
> > I would be interested in seeing any numbers people might come up with,
> > including single-threaded performance.
> 
> Thanks for doing a rollup patch, it made it easy to test. I gave it a spin on
> a 64 core (128 thread) POWER5+ box. I started simple by looking at open/close
> performance, eg:

I wonder what other good performance tests you can add to your test
framework? creat/unlink is another easy one. And for each case, putting
threads in their own cwd versus a common cwd are the variants.

BTW. for these cases in your tests it will be nice if you can run on
ramfs because that will isolate purely the vfs. Perhaps also include
other filesystems as you get time, but I think ramfs is the most
useful for us to start with.

