Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbXJXP17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbXJXP17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbXJXP1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:27:50 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:51506 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbXJXP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:27:49 -0400
To: staubach@redhat.com
CC: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <471F5EA2.8060203@redhat.com> (message from Peter Staubach on
	Wed, 24 Oct 2007 11:02:58 -0400)
Subject: Re: [PATCH] VFS: new fgetattr() file operation
References: <E1Iketp-0005dr-00@dorka.pomaz.szeredi.hu> <471F4254.9040206@redhat.com> <E1IkgW1-0005i0-00@dorka.pomaz.szeredi.hu> <471F5EA2.8060203@redhat.com>
Message-Id: <E1Iki8O-0005nu-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 24 Oct 2007 17:27:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The constraint is that the server has to be an ordinary unprivileged
> > process.  How should it identify the file, other than by name, or by
> > an open file descriptor?
> >
> >   
> 
> I explained this.  The fileid and the generation count along
> with the file system id will uniquely identify the file.

Yes, those filesystems, which have a file ID that can be used to index
the inodes.  Lot of filesystems (mostly those not originating from
UNIX) don't have such an ID.

> >> Clearly, this is broken on many levels.  It can't handle
> >> situations as described nor can it handle different instances
> >> of the same filename being used.
> >>     
> >
> > Can you please give concrete examples what it can't handle, and how
> > should the implementation be improved to be able to handle it, given
> > the above constraints?
> >
> >   
> >> This is why NFS, a network file system, does not use the filename
> >> as part of the file handle.
> >>     
> >
> > And the nfs server isn't a userspace process, or if it is, it must use
> > horrible hacks to convert the file handle to a name, that don't work
> > half the time.
> >
> >   
> 
> Nice try.  Wrong.  Try a different rationalization.

What's wrong with it?

> >> Wouldn't you be better off by attempting to implement an "open
> >> by ino" operation and an operation to get the generation count
> >> for the file and then modifying the network protocol of interest
> >> to use these as identifiers for the file to be manipulated?
> >>     
> >
> > You mean an "open by inode" on the userspace API?  My guess, it
> > wouldn't get very far.
> >
> >   
> 
> This isn't a new idea and has been implemented on a variety of
> different systems.

Like?

> > Anyway, that would still not work on old servers, and servers running
> > other OS's.
> >
> >   
> 
> I didn't think that we were talking about old servers and other
> OS's.  My concern at the moment is Linux and the changes being
> made to it.

In what way does passing the open file to the filesystem for the
fstat() syscall negatively impact Linux?

Usually it is best to design midlayers, so that they do the minimal
stuff, and pass the maximum of information to the low-layer, and
providing helper functions that the low-layer doesn't want to do
anything special.  Hiding information from the low-layer is pointless.

> > Note, the point is _not_ to make a brand new NFS replacement
> > filesystem, that can use names instead of file handles.  The point is
> > to use existing infrastructure, to make the setup as easy as ssh'ing
> > to a different machine.  And sshfs does just that.
> 
> And the solution is limiting.  It is not scalable nor particularly
> interesting to anyone interested in security.  Unless there is a
> way of limiting access to a particular set of files, then it is
> not generally useful outside of hackers or perhaps small groups
> of users not concerned about too many aspects of security.

I'm not sure what you are talking about here.  AFAICS this change
has absolutely nothing to do with filesystem (or any other kind of)
security.

> I am not interested in an extended discussion of this topic.

No problem.  Thanks anyway for your comments.

Miklos
