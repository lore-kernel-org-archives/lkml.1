Return-Path: <linux-kernel-owner+w=401wt.eu-S1751986Ab0AAPka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0AAPka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883Ab0AAPk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:40:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45458 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab0AAPk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:40:28 -0500
Date: Fri, 1 Jan 2010 16:40:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jeff Layton <jlayton@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks and file bind mounts (try #5)
Message-ID: <20100101154027.GK3944@atrey.karlin.mff.cuni.cz>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com> <m1my2cdhi3.fsf@fess.ebiederm.org> <20091123173616.75c3f600@tlielax.poochiereds.net> <20091123224948.GB5598@shareable.org> <20091123181545.05ad004d@tlielax.poochiereds.net> <20091216123143.GA15784@ZenIV.linux.org.uk> <20091220195903.GG23917@elf.ucw.cz> <20091220210404.GN18217@ZenIV.linux.org.uk> <20091220210619.GK23917@elf.ucw.cz> <20091220212340.GO18217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220212340.GO18217@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Consider FD passing over unix socket. Passing R/O file descriptor to
> > > > the other task, then having the task write to the file is certainly bad.
> > > 
> > > You've omitted the "R/O file descriptor of a file that is writable for
> > > that other task" part...
> > 
> > That is 666 for the other task. But the other task can't access it due
> > to directory being 700 or something. Your fchdir() argument  does not
> > apply here.
> 
> *snort*
> 
> What you are advocating is a very limited class of setups that might be
> usable for protecting files if not for the existing behaviour on a shitload
> of systems.
> 
> The thing is, that class *is* very limited.  E.g. introduce links and it's
> fallen apart.  Introduce bindings and the same will happen.  Just try to
> extend it one level deeper and fchdir() will bite you, etc.  All of that
> is not dependent on procfs even being there.
> 
> Access rights belong to file, not to a pathname (and there's no such thing
> as _the_ pathname of a file).
> 
> I'd buy that as a minor QoI issue; as a security one - no way.

Ok, so you see it as a (QoI) problem, but not too major. Good; I hope
it gets fixed one day.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
