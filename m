Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZDWMna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZDWMna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758664AbZDWMms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:42:48 -0400
Received: from thunk.org ([69.25.196.29]:60835 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758645AbZDWMmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:42:46 -0400
Date: Thu, 23 Apr 2009 08:42:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jamie Lokier <jamie@shareable.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Valerie Aurora Henson <vaurora@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090423124230.GF2723@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jamie Lokier <jamie@shareable.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Valerie Aurora Henson <vaurora@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423112105.GA1589@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423112105.GA1589@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 12:21:05PM +0100, Jamie Lokier wrote:
> Andrew Morton wrote:
> > Would it be better to implement new syscall(s) with finer-grained control
> > and better semantics?  Then userspace would just need to to:
> > 
> > 	fsync_on_steroids(fd, FSYNC_BEFORE_RENAME);
> > 
> > and that all gets down into the filesystem which can then work out what
> > it needs to do to implement the command.
> 
> +1 from me.  Several flags come to mind for discussion.
> FSYNC_HARDWARE.  FSYNC_ORDER_ONLY, FSYNC_FLUSH.
> FSYNC_DATA_BEFORE_SIZE.  FSYNC_BEFORE_NEW_FILE.
> 
> Nick Piggin was working on  fsync_range().
> 
> Maybe it's time to do fsync properly?

We could create such a thing, but how many application programmers
will actually *use* them?  People need to check out my blog, where my
competence, my judgement, even my paternity was questioned about this
issue.

Application writers don't care about OS portability (it only has to
work on Linux), or working on multiple filesystems (it only has work
on ext3, and any filesystems which doesn't do automagic fsync's at the
right magic times automagically is broken by design).  This includes
many GNOME and KDE developers.  So as we concluded at the filesystem
and storage workshop, we probably will have to keep automagic
hueristics out there, for all of the broken applications.  Heck, Linus
even refused to call those applications "broken".  

So we can create a more finer-grained controlled system call ---
although I would suggest that we just add some extra flags to
sync_file_range() --- but it's doubtful that many application
programmers will use it.

					- Ted
