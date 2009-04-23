Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZDWQYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZDWQYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbZDWQXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:23:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZDWQXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:23:54 -0400
Date: Thu, 23 Apr 2009 12:16:12 -0400
From: Valerie Aurora Henson <vaurora@redhat.com>
To: Theodore Tso <tytso@mit.edu>, Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090423161612.GG8476@shell>
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423112105.GA1589@shareable.org> <20090423124230.GF2723@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423124230.GF2723@mit.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 08:42:30AM -0400, Theodore Tso wrote:
> On Thu, Apr 23, 2009 at 12:21:05PM +0100, Jamie Lokier wrote:
> > Andrew Morton wrote:
> > > Would it be better to implement new syscall(s) with finer-grained control
> > > and better semantics?  Then userspace would just need to to:
> > > 
> > > 	fsync_on_steroids(fd, FSYNC_BEFORE_RENAME);
> > > 
> > > and that all gets down into the filesystem which can then work out what
> > > it needs to do to implement the command.
> > 
> > +1 from me.  Several flags come to mind for discussion.
> > FSYNC_HARDWARE.  FSYNC_ORDER_ONLY, FSYNC_FLUSH.
> > FSYNC_DATA_BEFORE_SIZE.  FSYNC_BEFORE_NEW_FILE.
> > 
> > Nick Piggin was working on  fsync_range().
> > 
> > Maybe it's time to do fsync properly?
> 
> We could create such a thing, but how many application programmers
> will actually *use* them?  People need to check out my blog, where my
> competence, my judgement, even my paternity was questioned about this
> issue.

I am sorry you were personally attacked over this issue - that was
uncalled for and unproductive.  I wish personal attacks were less
common in open source.

> Application writers don't care about OS portability (it only has to
> work on Linux), or working on multiple filesystems (it only has work
> on ext3, and any filesystems which doesn't do automagic fsync's at the
> right magic times automagically is broken by design).  This includes
> many GNOME and KDE developers.  So as we concluded at the filesystem
> and storage workshop, we probably will have to keep automagic
> hueristics out there, for all of the broken applications.  Heck, Linus
> even refused to call those applications "broken".  
> 
> So we can create a more finer-grained controlled system call ---
> although I would suggest that we just add some extra flags to
> sync_file_range() --- but it's doubtful that many application
> programmers will use it.

I remain hopeful. :) Application developers *want* to do the right
thing in general; they are just facing a hopeless catch-22 right now.
The POSIX-ly correct use of fsync() exposes them to potential
multi-second delays on 95% of file systems currently in existence -
and the fsync() isn't even needed in many cases!

For example, Red Hat is beginning to support XFS officially, and I
would be happy to fix any bugs we receive about applications failing
to do fsync() before rename() - if I was sure I wasn't introducing a
performance regression.

-VAL
