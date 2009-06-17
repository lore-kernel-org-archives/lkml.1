Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbZFQSbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbZFQSbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZFQSbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:31:05 -0400
Received: from THUNK.ORG ([69.25.196.29]:35293 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbZFQSbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:31:03 -0400
Date: Wed, 17 Jun 2009 14:30:36 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-afs@lists.infradead.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Message-ID: <20090617183036.GA7867@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
	linux-afs@lists.infradead.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <alpine.LFD.2.01.0906171027470.16802@localhost.localdomain> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <28023.1245259479@redhat.com> <28259.1245261823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28259.1245261823@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 07:03:43PM +0100, David Howells wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > What _I_ mean is that THIS IS IMPOSSIBLE TO DO FROM USER SPACE!
> > 
> > Try it. Not doable. User space simply doesn't know enough, and has 
> > fundamental races with mount/umount.
> 
> Ummm...  I'm not sure I completely agree.  If you've managed to open, say,
> "/afs", where's the race with mount/umount?  You've got a file descriptor you
> can use as a handle.  Yes, you have to check that it's actually an inode of
> your fs, but that's not exactly difficult, and that's not going to change just
> because someone unmounts it or mounts over it whilst you've got it open.

I believe Linus is arguing that in the general case, it's impossible
to open the mountpoint of an arbitrarily mounted filesystem.  David,
you're arguing that by convention the afs root is *always* in /afs,
and that the afs utilities will always simply open "/afs", and thus
it's not hard to find the mount point, since afs works by having a
single top-level static mount point --- and AFS hides the
lookup of what volume server you might need to go to when you open
/afs/athena.mit.edu/user/t/y/tytso versus /afs/andrew.cmu.edu/usr/shadow.

There are no magic "automounts" such that OS won't know that
user.tytso AFS Volume in the athena.mit.edu AFS cell is at
/afs/athena.mit.edu/user/t/y/tytso, so the only "mountpoint" that
exists as far as AFS is concerned is at /afs --- and that in the AFS
world, it's essentially a universal convention that AFS pathnames
begin with "/afs", and so the AFS filesystem will always be mounted in /afs.

      	   	       	      	  	     	  - Ted
