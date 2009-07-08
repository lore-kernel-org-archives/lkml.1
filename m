Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZGHMlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZGHMlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZGHMk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:40:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41476 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZGHMk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:40:57 -0400
Date: Wed, 8 Jul 2009 08:40:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090708124056.GA26701@infradead.org>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144823.GE2714@wotan.suse.de> <20090707145820.GA9976@infradead.org> <20090707150257.GG2714@wotan.suse.de> <20090707150758.GA18075@infradead.org> <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708123412.GQ2714@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 02:34:12PM +0200, Nick Piggin wrote:
> On Wed, Jul 08, 2009 at 06:47:01AM -0400, Christoph Hellwig wrote:
> > On Wed, Jul 08, 2009 at 08:32:25AM +0200, Nick Piggin wrote:
> > > Thanks for the patch, I think I will fold it in to the series. I
> > > think we probably do need to call simple_setsize in inode_setattr
> > > though (unless you propose to eventually convert every filesystem
> > > to define a .setattr). This would also require eg. your ext2
> > > conversion to strip ATTR_SIZE before passing through to inode_setattr.
> > 
> > Yes, we should eventually make .setattr mandatory.  Doing a default
> > action when a method lacks tends to cause more issues than it solves.
> > 
> > I'm happy to help in doing that part of the conversion (and also other
> > bits)
> 
> OK well here is what I have now for 3/4 and 4/4. Basically just
> folded your patch on top, changed ordering of some checks, have
> fs clear ATTR_SIZE before calling inode_setattr, add a .new_truncate
> field to check against rather than .truncate, and provide a default
> ATTR_SIZE handler in inode_setattr (simple_setsize).

Can we leave that last part out?  Converting those filesystems that do
not have a ->truncate method to a trivial ->setattr is easy, and I can
do it pretty soon (next week probably).

That allows us to get rid of all that ATTR_SIZE clearing which is pretty
ugly.

> +			 *
> +			 * Filesystems which define i_op->new_truncate must
> +			 * handle this themselves. Eventually this will go
> +			 * away because everyone will be converted.

s/define/set/ ?

