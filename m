Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYLRX1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYLRX1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYLRX1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:27:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270AbYLRX1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:27:14 -0500
Date: Thu, 18 Dec 2008 15:26:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: nfsv4@linux-nfs.org, hch@infradead.org, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, steved@redhat.com, dhowells@redhat.com,
       linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-Id: <20081218152616.a24c013f.akpm@linux-foundation.org>
In-Reply-To: <200812190007.34581.bernd.schubert@fastmail.fm>
References: <8930.1229560221@redhat.com>
	<20081218142420.GA16728@infradead.org>
	<20081218123601.11810b7f.akpm@linux-foundation.org>
	<200812190007.34581.bernd.schubert@fastmail.fm>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 00:07:33 +0100
Bernd Schubert <bernd.schubert@fastmail.fm> wrote:

> On Thursday 18 December 2008, Andrew Morton wrote:
> > On Thu, 18 Dec 2008 09:24:20 -0500
> >
> > Christoph Hellwig <hch@infradead.org> wrote:
> > > On Thu, Dec 18, 2008 at 10:44:18PM +1100, Stephen Rothwell wrote:
> > > > Added from today.
> > > >
> > > > Usual spiel: all patches in that branch must have been
> > > > 	posted to a relevant mailing list
> > > > 	reviewed
> > > > 	unit tested
> > > > 	destined for the next merge window (or the current release)
> > > > *before* they are included.
> > >
> > > I don't think we want fscache for .29 yet.  I'd rather let the
> > > credential code settle for one release, and have more time for actually
> > > reviewing it properly and have it 100% ready for .30.
> >
> > I don't believe that it has yet been convincingly demonstrated that we
> > want to merge it at all.
> >
> > It's a huuuuuuuuge lump of new code, so it really needs to provide
> > decent value.  Can we revisit this?  Yet again?  What do we get from
> > all this?
> >
> 
> I really don't understand why fs-cache is always rejected.

It's never been rejected.  For a long time it has been in a state where
we're looking for the data which would allow us to agree that its
benefits are worth its costs.  AFAIK that has never really been
convincingly demonstrated.  Nor has the converse case been
demonstrated, so it floats in limbo.

> Actually it is the 
> perfect solution for NFS booted systems - you have a big cluster of nodes and 
> in order to minimize administration overhead the nodes are booted over NFS 
> from one common chroot. With unionfs (preferred solution here is unionfs-fuse) 
> one then maintains files required to be differently by different clients.
> 
> Caching files on the local disk minimized the network access and boosts the 
> performance, so at least for this usage example fs-cache would be great.
> (Actually I have been thinking about to implement a caching branch into 
> unionfs-fuse, but if the kernel can do it on its own, it is also fine.)

Have you actually used cachefs/cachefiles for this?

> In the past David already posted many benchmarks and just a few weeks ago 
> again:
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0811.3/00584.html

OK, benchmarks are good.   But look:

 303 files changed, 21049 insertions(+), 3726 deletions(-)

it's an enormous hunk of code.  That will be in the kernel for ever and
ever, needing maintenance, adding additional burden to our effort to
evolve the kernel, etc.


Are any distros pushing for this?  Or shipping it?  If so, are they
able to weigh in and help us with this quite difficult decision?

