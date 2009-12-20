Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZLTVGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZLTVGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 16:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbZLTVGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 16:06:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45857 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbZLTVG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 16:06:27 -0500
Date: Sun, 20 Dec 2009 22:06:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jeff Layton <jlayton@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
 and file bind mounts (try #5)
Message-ID: <20091220210619.GK23917@elf.ucw.cz>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
 <m1my2cdhi3.fsf@fess.ebiederm.org>
 <20091123173616.75c3f600@tlielax.poochiereds.net>
 <20091123224948.GB5598@shareable.org>
 <20091123181545.05ad004d@tlielax.poochiereds.net>
 <20091216123143.GA15784@ZenIV.linux.org.uk>
 <20091220195903.GG23917@elf.ucw.cz>
 <20091220210404.GN18217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220210404.GN18217@ZenIV.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-20 21:04:04, Al Viro wrote:
> On Sun, Dec 20, 2009 at 08:59:03PM +0100, Pavel Machek wrote:
> > > WTF not?  It's convenient and doesn't lose any real security.  If your
> > > code relies on inaccessibility of <path> since some component of that
> > > path is inaccessible, you are *already* fscked.  Consider e.g. fchdir()
> > > and its implications - if you have an opened descriptor for parent,
> > > having no exec permissions on grandparent won't stop you at all.  Already.
> > > On all Unices, regardless of openat(), etc.
> > 
> > Consider FD passing over unix socket. Passing R/O file descriptor to
> > the other task, then having the task write to the file is certainly bad.
> 
> You've omitted the "R/O file descriptor of a file that is writable for
> that other task" part...

That is 666 for the other task. But the other task can't access it due
to directory being 700 or something. Your fchdir() argument  does not
apply here.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
