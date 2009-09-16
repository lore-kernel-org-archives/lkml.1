Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbZIPNPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbZIPNPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbZIPNPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:15:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084AbZIPNPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:15:43 -0400
Date: Wed, 16 Sep 2009 09:15:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches for 2.6.31-git
Message-ID: <20090916131543.GA21107@infradead.org>
References: <20090915181247.GA32167@kroah.com> <20090916124533.GA11222@infradead.org> <20090916125919.GA24154@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916125919.GA24154@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 05:59:19AM -0700, Greg KH wrote:
> And I have never heard this complaint, in the 6 or so months that this
> has been discussed.

I've mentioned it before, as have others.

> >  - it then manipulates it using the high-level VFS functions which it
> >    could just do on any filesystem if it really wanted
> 
> I don't understand what you are trying to object to here.  What is wrong
> with that?

It's a very bad way to expose kernel state, and the same problem the
original devfs had.  A good kernel state filesystem is immutable to
changes from userspace, that is fully controlled by the kernel.  The
problem with devfs and your new devfstmpfs is that you have both
userspace and the kernel manipulating the same object.  Which for
example makes life time management impossible.

> > These lots of dicussions were basically people telling Greg that he
> > should come up wit ha real problem instead of just pushing it for it's
> > own sake.  Arjan And Eric have very well refuted the spped claim.
> 
> And Kay and I and many others have refuted the "it's only about speed"
> claim :)

As many people have asked you already then come up with a description
of what you actually want.  You ealize you're acting exactly like those
"But we need feature $FOO because we have it inhose / on windows / on
solaris" people everyone is upset at on lkml?

> > NACK from me from the VFS point of view - this is devfs 2.0, just worse
> > than the last version of devfs 1.
> 
> Hey, as one who actually remembers, and read the devfs 1 code, that's
> really harsh :(

It's not.  The last version we had in -mm for a while was the rewrite
from Adam richter that did exactly what devtmpfs does - use ramfs
(insteaf of tmpfs now) and use the vfs path helpers to work on it.

I also know who gladly killed it just to re-introduce the same thing
years later, not actually solving any of the problems in it.  The only
major-ish difference is that old devfs had explicit calls to create the
node names (and stupid choicses from Good times) while version 2.0 hides
the naming inside the driver core.

