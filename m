Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZD1U23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZD1U23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZD1U2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:28:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45505 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbZD1U2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:28:07 -0400
Date: Sun, 26 Apr 2009 11:26:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Valerie Aurora Henson <vaurora@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, Jamie Lokier <jamie@shareable.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@redhat.com>,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [RFC PATCH] fpathconf() for fsync() behavior
Message-ID: <20090426092601.GC1354@ucw.cz>
References: <20090423001257.GA16540@shell> <20090422221748.8c9022d1.akpm@linux-foundation.org> <20090423112105.GA1589@shareable.org> <20090423124230.GF2723@mit.edu> <20090423161612.GG8476@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423161612.GG8476@shell>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Application writers don't care about OS portability (it only has to
> > work on Linux), or working on multiple filesystems (it only has work
> > on ext3, and any filesystems which doesn't do automagic fsync's at the
> > right magic times automagically is broken by design).  This includes
> > many GNOME and KDE developers.  So as we concluded at the filesystem
> > and storage workshop, we probably will have to keep automagic
> > hueristics out there, for all of the broken applications.  Heck, Linus
> > even refused to call those applications "broken".  
> > 
> > So we can create a more finer-grained controlled system call ---
> > although I would suggest that we just add some extra flags to
> > sync_file_range() --- but it's doubtful that many application
> > programmers will use it.
> 
> I remain hopeful. :) Application developers *want* to do the right
> thing in general; they are just facing a hopeless catch-22 right now.
> The POSIX-ly correct use of fsync() exposes them to potential
> multi-second delays on 95% of file systems currently in existence -
> and the fsync() isn't even needed in many cases!

Perhaps we should create documentation file explaining what kernel
guarantees and what works mostly by mistake?

For example (and I tried to watch the discussion...):

On ext3 data=ordered, is "echo new > bar.new; mv -f bar.new bar "
actually safe?

Is it still safe on ext4 with workarounds, or is it that you just
shrank the window?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
