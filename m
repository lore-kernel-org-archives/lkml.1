Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZLTVES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZLTVES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 16:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZLTVER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 16:04:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48459 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZLTVER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 16:04:17 -0500
Date: Sun, 20 Dec 2009 21:04:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jeff Layton <jlayton@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
	and file bind mounts (try #5)
Message-ID: <20091220210404.GN18217@ZenIV.linux.org.uk>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com> <m1my2cdhi3.fsf@fess.ebiederm.org> <20091123173616.75c3f600@tlielax.poochiereds.net> <20091123224948.GB5598@shareable.org> <20091123181545.05ad004d@tlielax.poochiereds.net> <20091216123143.GA15784@ZenIV.linux.org.uk> <20091220195903.GG23917@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220195903.GG23917@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 08:59:03PM +0100, Pavel Machek wrote:
> > WTF not?  It's convenient and doesn't lose any real security.  If your
> > code relies on inaccessibility of <path> since some component of that
> > path is inaccessible, you are *already* fscked.  Consider e.g. fchdir()
> > and its implications - if you have an opened descriptor for parent,
> > having no exec permissions on grandparent won't stop you at all.  Already.
> > On all Unices, regardless of openat(), etc.
> 
> Consider FD passing over unix socket. Passing R/O file descriptor to
> the other task, then having the task write to the file is certainly bad.

You've omitted the "R/O file descriptor of a file that is writable for
that other task" part...
