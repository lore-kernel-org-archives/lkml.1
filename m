Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZIISia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZIISia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZIISi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:38:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:35931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZIISi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:38:29 -0400
Date: Wed, 9 Sep 2009 11:36:40 -0700
From: Greg KH <gregkh@suse.de>
To: Michael Tokarev <mjt@tls.msk.ru>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/48] 2.6.27.32-stable review
Message-ID: <20090909183640.GA17027@suse.de>
References: <20090909030843.GC10608@suse.de>
 <20090909073150.44F8C12B5F@gandalf.tls.msk.ru>
 <20090909132340.GA12391@suse.de>
 <20090909182802.GA12456@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909182802.GA12456@mail.oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 11:28:02AM -0700, Joel Becker wrote:
> On Wed, Sep 09, 2009 at 06:23:40AM -0700, Greg KH wrote:
> > On Wed, Sep 09, 2009 at 11:31:50AM +0400, Michael Tokarev wrote:
> > > > On Tue, Sep 08, 2009 at 09:47:51AM -0500, Jayson King wrote:
> > > > > A line from the upstream patch is missing in this patch:
> > > > > 
> > > > >   static int ocfs2_write_cluster(struct address_space *mapping,
> > > > >                      u32 phys, unsigned int unwritten,
> > > > > +                   unsigned int should_zero,
> > > > >                      struct ocfs2_alloc_context *data_ac,
> > > > >                      struct ocfs2_alloc_context *meta_ac,
> > > > >                      struct ocfs2_write_ctxt *wc, u32 cpos,
> > > > >                      loff_t user_pos, unsigned user_len)
> 
> <snip>
> 
> > >  ocfs2-initialize-the-cluster-we-re-writing-to-in-a-non-sparse-extend.patch
> > >  ocfs2-ocfs2_write_begin_nolock-should-handle-len-0.patch
> > > Neither of which looks like an addon, and only one (the first)
> > > has references to this "should_zero" variable.
> > 
> > I thought the second one would solve the problem.
> > 
> > What happened here, I took the upstream patch, was it incorrect?  If so,
> > was there a patch, also upstream, that fixed this problem?
> 
> 	The upstream first patch is
> e7432675f8ca868a4af365759a8d4c3779a3d922.  It has this line.  The second
> patch fixes a bug in the first patch, but the bug is not around this
> line, it's totally separate.
> 	Ok, I'm confused.  In linux-2.6-stable.git, the 2.6.30.y branch
> has this for the diff:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6-stable.git;a=blobdiff;f=fs/ocfs2/aops.c;h=122fb7978f60f7dde54ac0567f578159900f163b;hp=b2c52b3a1484f1c57c4b098bf9706fe21c186ac0;hb=9baf278cca4043a1312f3a40bf17b979b6238ebc;hpb=8c668814e3e2be7d633447bf6e78237d4cedabb7
> It has the correct line.
> 	But in 2.6.27.y branch, referencing the same upstream commit,
> there is this diff:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6-stable.git;a=blobdiff;f=fs/ocfs2/aops.c;h=50bb561860dfb5ee024e7a992bb4d72bc71f0372;hp=a53da1466277abd843b0117f89df9850423ba92b;hb=8338941200d9188e3c866dd16cc2848754947895;hpb=7e8287379470a7c18153be389c9516e31ae141f3
> It is missing the line.  I think the cherry-pick for 2.6.27.y got
> broken.

Very wierd.  I used the same patch to pick from :(

I'll go fix this up and do a new release for the .27 tree.  Thanks for
working it out for me.

greg k-h
