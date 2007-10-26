Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbXJZJdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbXJZJdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753721AbXJZJde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:33:34 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:56860 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbXJZJdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:33:33 -0400
To: dgc@sgi.com
CC: staubach@redhat.com, akpm@linux-foundation.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20071025235206.GA995458@sgi.com> (message from David Chinner on
	Fri, 26 Oct 2007 09:52:06 +1000)
Subject: Re: [PATCH] VFS: new fgetattr() file operation
References: <E1Iketp-0005dr-00@dorka.pomaz.szeredi.hu> <471F4254.9040206@redhat.com> <E1IkgW1-0005i0-00@dorka.pomaz.szeredi.hu> <471F5EA2.8060203@redhat.com> <E1Iki8O-0005nu-00@dorka.pomaz.szeredi.hu> <20071025224235.GZ995458@sgi.com> <E1IlBqA-0006yj-00@dorka.pomaz.szeredi.hu> <20071025235206.GA995458@sgi.com>
Message-Id: <E1IlLZi-0007Iv-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 26 Oct 2007 11:33:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Oct 26, 2007 at 01:10:14AM +0200, Miklos Szeredi wrote:
> > > On Wed, Oct 24, 2007 at 05:27:04PM +0200, Miklos Szeredi wrote:
> > > > > >> Wouldn't you be better off by attempting to implement an "open
> > > > > >> by ino" operation and an operation to get the generation count
> > > > > >> for the file and then modifying the network protocol of interest
> > > > > >> to use these as identifiers for the file to be manipulated?
> > > > > >>     
> > > > > >
> > > > > > You mean an "open by inode" on the userspace API?  My guess, it
> > > > > > wouldn't get very far.
> > > > > 
> > > > > This isn't a new idea and has been implemented on a variety of
> > > > > different systems.
> > > > 
> > > > Like?
> > > 
> > > XFS.
> > > 
> > > 'man open_by_handle'
> > 
> > Doesn't seem widely used, with 600 something google hits.
> 
> from the man page:
> 
> "They are intended  for  use  by a limited set of system utilities such
> as backup programs."
> 
> It also gets used by HSMs and so it is current, tested and is not
> going away....

Sure.

> > And in this
> > old thread Linus is not entirely enthusiastic about the concept:
> > 
> >   http://lkml.org/lkml/1999/1/11/244
> 
> That was "open by inode number", AFAICT. A handle is an opaque
> blob that can be an arbitrary length defined by the filesystem.
> You have to convert a fd or path to a handle first before you can
> use it later, so any filesystem can implement it...
> 
> i.e. it is exactly what this (unanswered) post suggested:
> 
> http://lkml.org/lkml/1999/1/13/186

Well, yeah, if a filesystem doesn't have a global index, the whole
path could just be stuffed into the handle.

But there's not much point in that, is there?  And because the
interface bypasses normal access checking on parent directories, it
has security implications, making it not generally useful.

Specifically, it is not useful for the "unprivileged file server" case
that Peter was suggesting.

Miklos
