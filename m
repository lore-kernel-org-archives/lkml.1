Return-Path: <linux-kernel-owner+w=401wt.eu-S1946210AbXBCB6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946210AbXBCB6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 20:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946203AbXBCB6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 20:58:09 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50706 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946202AbXBCB6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 20:58:07 -0500
Date: Fri, 2 Feb 2007 17:58:01 -0800
From: Andrew Morton <akpm@osdl.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 1/9] fs: libfs buffered write leak fix
Message-Id: <20070202175801.3f97f79b.akpm@linux-foundation.org>
In-Reply-To: <20070203013316.GB27300@wotan.suse.de>
References: <20070129081905.23584.97878.sendpatchset@linux.site>
	<20070129081914.23584.23886.sendpatchset@linux.site>
	<20070202155236.dae54aa2.akpm@linux-foundation.org>
	<20070203013316.GB27300@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007 02:33:16 +0100
Nick Piggin <npiggin@suse.de> wrote:

> > > ===================================================================
> > > --- linux-2.6.orig/fs/buffer.c
> > > +++ linux-2.6/fs/buffer.c
> > > @@ -2344,6 +2344,8 @@ int nobh_prepare_write(struct page *page
> > >  
> > >  	if (is_mapped_to_disk)
> > >  		SetPageMappedToDisk(page);
> > > +
> > > +	/* XXX: information leak vs read(2) */
> > >  	SetPageUptodate(page);
> > >  
> > >  	/*
> > 
> > That comment is too terse to be useful.
> 
> OK, similar problem here - we have brought all the buffers uptodate
> that we are *not* going to write over, or partially write over, but
> we can have an uninitialised hole over the region we want to write.
> 
> I think just setting page uptodate in commit_write might do the
> trick? (and getting rid of the set_page_dirty there).

Yes, the page just isn't uptodate yet in prepare_write() - moving things
to commti_write() sounds sane.

But please, can we have sufficient changelogs and comments in the next version?
