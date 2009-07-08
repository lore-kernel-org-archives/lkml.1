Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZGHMse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZGHMse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZGHMs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:48:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbZGHMsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:48:25 -0400
Date: Wed, 8 Jul 2009 14:48:24 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090708124824.GS2714@wotan.suse.de>
References: <20090707144823.GE2714@wotan.suse.de> <20090707145820.GA9976@infradead.org> <20090707150257.GG2714@wotan.suse.de> <20090707150758.GA18075@infradead.org> <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <20090708124056.GA26701@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708124056.GA26701@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 08:40:56AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 08, 2009 at 02:34:12PM +0200, Nick Piggin wrote:
> > On Wed, Jul 08, 2009 at 06:47:01AM -0400, Christoph Hellwig wrote:
> > > On Wed, Jul 08, 2009 at 08:32:25AM +0200, Nick Piggin wrote:
> > > > Thanks for the patch, I think I will fold it in to the series. I
> > > > think we probably do need to call simple_setsize in inode_setattr
> > > > though (unless you propose to eventually convert every filesystem
> > > > to define a .setattr). This would also require eg. your ext2
> > > > conversion to strip ATTR_SIZE before passing through to inode_setattr.
> > > 
> > > Yes, we should eventually make .setattr mandatory.  Doing a default
> > > action when a method lacks tends to cause more issues than it solves.
> > > 
> > > I'm happy to help in doing that part of the conversion (and also other
> > > bits)
> > 
> > OK well here is what I have now for 3/4 and 4/4. Basically just
> > folded your patch on top, changed ordering of some checks, have
> > fs clear ATTR_SIZE before calling inode_setattr, add a .new_truncate
> > field to check against rather than .truncate, and provide a default
> > ATTR_SIZE handler in inode_setattr (simple_setsize).
> 
> Can we leave that last part out?  Converting those filesystems that do
> not have a ->truncate method to a trivial ->setattr is easy, and I can
> do it pretty soon (next week probably).
> 
> That allows us to get rid of all that ATTR_SIZE clearing which is pretty
> ugly.

Is it not common procedure to use when handling some attributes
and passing others to inode_setattr?

Anyway, no big deal either way. And it's using .new_truncate, so
there is no rush to convert everything (and it will remain back
compatible either way until we remove .new_truncate and all the
vmtruncate calls).


> 
> > +			 *
> > +			 * Filesystems which define i_op->new_truncate must
> > +			 * handle this themselves. Eventually this will go
> > +			 * away because everyone will be converted.
> 
> s/define/set/ ?

Yes.

