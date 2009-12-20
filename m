Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZLTT7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZLTT7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 14:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZLTT7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 14:59:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46532 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZLTT7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 14:59:11 -0500
Date: Sun, 20 Dec 2009 20:59:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jeff Layton <jlayton@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
 and file bind mounts (try #5)
Message-ID: <20091220195903.GG23917@elf.ucw.cz>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
 <m1my2cdhi3.fsf@fess.ebiederm.org>
 <20091123173616.75c3f600@tlielax.poochiereds.net>
 <20091123224948.GB5598@shareable.org>
 <20091123181545.05ad004d@tlielax.poochiereds.net>
 <20091216123143.GA15784@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216123143.GA15784@ZenIV.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-12-16 12:31:43, Al Viro wrote:
> On Mon, Nov 23, 2009 at 06:15:45PM -0500, Jeff Layton wrote:
> 
> > The big question with all of this is: Should a task have the ability
> > to follow a /proc/pid symlink to a path that it wouldn't ordinarily be
> > able to resolve with a path lookup. The concensus that I got from the
> > bugtraq discussion was that it should not, and this patch is an attempt
> > to prevent that.
> > 
> > I take it from you and Eric's comments that you disagree? If so, what's
> > your rationale for allowing a task to resolve this symlink when it
> > wouldn't ordinarily be able to do so if it were a "normal" symlink?
> 
> WTF not?  It's convenient and doesn't lose any real security.  If your
> code relies on inaccessibility of <path> since some component of that
> path is inaccessible, you are *already* fscked.  Consider e.g. fchdir()
> and its implications - if you have an opened descriptor for parent,
> having no exec permissions on grandparent won't stop you at all.  Already.
> On all Unices, regardless of openat(), etc.

Consider FD passing over unix socket. Passing R/O file descriptor to
the other task, then having the task write to the file is certainly bad.

> I might buy the argument about restricting reopening with wider permissions,
> but
> 	a) we still are looking at possible userland breakage of the worst
> kind - random scripts passing /dev/fd/42 as command line arguments to
> random programs.  Once in a while.  With error checking being... not quite
> sufficient.
> 	b) it's not just open - we have at least chmod/chown/truncate to
> deal with.

That's indeed the sane way to solve that.

> Prohibiting *all* access is a complete non-starter - things like
> cmp foo /dev/stdin || ....
> would bloody better work and nobody cares whether you have redirect
> from something out of your reach at the moment.

Ok.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
