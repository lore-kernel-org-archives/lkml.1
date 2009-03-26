Return-Path: <linux-kernel-owner+w=401wt.eu-S1759662AbZCZQZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759662AbZCZQZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 12:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbZCZQZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 12:25:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:57255 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbZCZQZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:25:03 -0400
Date: Thu, 26 Mar 2009 17:24:58 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090326162458.GA17159@duck.suse.cz>
References: <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <alpine.LFD.2.00.0903251649450.3032@localhost.localdomain> <20090326002253.GC11024@duck.suse.cz> <alpine.LFD.2.00.0903251826390.3032@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903251826390.3032@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 25-03-09 18:34:32, Linus Torvalds wrote:
> On Thu, 26 Mar 2009, Jan Kara wrote:
> >
> >  1) We have to writeout blocks full of zeros on allocation so that we don't
> > expose unallocated data => slight slowdown
> 
> Why? 
> 
> This is in _no_ way different from a regular "write()" system call. And 
> there, we just attach the buffers to the page. If something crashes before 
> the page actually gets written out, then we'll have hopefully never 
> written out the metadata (that's what "data=ordered" means).
  Sorry, I wasn't exact enough. We'll attach buffers to the running
transaction and they'll get written out at the transaction commit which is
usually earlier than when the writepage() is called and then later
writepage() will write the data again (this is a consequence of the fact
that JBD commit code just writes buffers without calling
clear_page_dirty_for_io())...
  At least ext4 has this fixed because JBD2 already writes out ordered data
via writepages().

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
