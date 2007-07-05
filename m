Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbXGELdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbXGELdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXGELda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:33:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52903 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbXGELd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:33:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 13:40:40 +0200
User-Agent: KMail/1.9.5
Cc: oliver@neukum.org, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, mjg59@srcf.ucam.org,
       benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051202.59375.oliver@neukum.org> <E1I6OLf-0000JP-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6OLf-0000JP-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051340.41901.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 12:14, Miklos Szeredi wrote:
> > > > > And teach VFS to block suspension, while waiting on a mutex held by
> > > > > another process performing a fuse operation.
> > > > > 
> > > > > I can already hear the beautiful praise from Al Viro at the sight of
> > > > > that ;)
> > > > 
> > > > There is that.
> > > > 
> > > > OK, bite the bullet. Tasks involved in fuse are special. Give them a flag
> > > > and teach the freezer to put them on ice only after all other task are
> > > > frozen. In a way they are kernel, there's no use denying that.
> > > 
> > > And flag every other process, that the flagged process is
> > > communicating with?  How are you proposing to do that?
> > > 
> > > Quoting Paul:
> > > 
> > > "1. The freezer cannot be guaranteed deadlock-free without constructing
> > >    a dependency graph between tasks (both user and kernel), which is
> > >    virtually impossible since the dependencies are not externally
> > >    observable."

This statement is ganarally false.

There is the limitation in the freezer that it cannot handle uninterruptible
tasks and that's all.

Now, this is not usual for user space tasks to make other user space
tasks become uninterruptible.  I'd say this is a little strange.

> > A deadlock requires that the circular wait is uninterruptible. Normal IPC
> > isn't.
> > 
> > What are you doing in the userland portions of fuse? Some kind of IPC
> > with other tasks?
> 
> Anything, writing to a file, writing to shared memory, sending things
> over the network.  There's no limit to what a filesystem daemon may
> do.  It's a perfectly ordinary unprivileged userspace process.  And
> this is a feature not a bug.
> 
> > There is a limit to which you can push kernel functionality into
> > user space.
> 
> Limiting what a userspace filesystem can do would defeat the whole
> purpose of the bloody thing.  This is not negotiable ;)

Which doesn't change the fact that FUSE _is_ special, because it adds
dependencies between processed that were not present before.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
