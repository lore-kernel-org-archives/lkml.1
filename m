Return-Path: <linux-kernel-owner+w=401wt.eu-S1763715AbXIUWGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763715AbXIUWGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761247AbXIUWFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:05:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760039AbXIUWFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:05:53 -0400
Date: Fri, 21 Sep 2007 15:05:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [Ecryptfs-devel] [PATCH 3/11] eCryptfs: read_write.c routines
Message-Id: <20070921150540.fa285609.akpm@linux-foundation.org>
In-Reply-To: <20070921215125.GB11833@halcrow.austin.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
	<20070917214632.GK13679@halcrow.austin.ibm.com>
	<20070919223850.3e1132ac.akpm@linux-foundation.org>
	<20070921215125.GB11833@halcrow.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 16:51:25 -0500
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> On Wed, Sep 19, 2007 at 10:38:50PM -0700, Andrew Morton wrote:
> > > +	virt = kmap(page_for_lower);
> > > +	rc = ecryptfs_write_lower(ecryptfs_inode, virt, offset, size);
> > > +	kunmap(page_for_lower);
> > > +	return rc;
> > > +}
> > 
> > argh, kmap.  http://lkml.org/lkml/2007/9/15/55
> 
> Here is a patch that moves to kmap_atomic(), adding an intermediate
> copy. Although I would really like to find a way to avoid having to do
> this extra copy.

We might as well stick with kmap.  I was just having a whine - I don't know
what to do about this really, apart from perhaps giving in to reality and
making kmap work better.


btw, I'm not really a great admirer of the whole patchset: it does some
pretty nasty-looking things: allocating dynamic memory, grabbing the
underlying pageframes with virt_to_page(), passing them back into kernel
APIs which are supposed to be called from userspace, etc.  It's all rather
ugly and abusive-looking.

But given that you're trying to do things which the kernel just isn't set
up to do, it isn't immediately obvious what can be done to fix it.

Perhaps there are problems whcih I didn't have time to spot, and perhaps
there are things which could be done to improve it.  But I don't have time
to sit down and absorb it all to a sufficient level of detail to be able to
suggest anything, and nobody else seems to be interested in reading the
patches so whoop, in it all goes.

