Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbZKXM2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbZKXM2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 07:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbZKXM2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 07:28:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34900 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645AbZKXM2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 07:28:16 -0500
Date: Tue, 24 Nov 2009 13:09:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@redhat.com>, jamie@shareable.org,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
	and file bind mounts (try #5)
Message-ID: <20091124120906.GA1700@ucw.cz>
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com> <m1my2cdhi3.fsf@fess.ebiederm.org> <20091123173616.75c3f600@tlielax.poochiereds.net> <20091123224948.GB5598@shareable.org> <20091123181545.05ad004d@tlielax.poochiereds.net> <m1ljhwbyr3.fsf@fess.ebiederm.org> <20091123193426.55f1530a@tlielax.poochiereds.net> <20091124012027.GA14645@shareable.org> <20091124062621.744beddb@tlielax.poochiereds.net> <E1NCtxF-0000rn-1z@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NCtxF-0000rn-1z@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-24 12:53:09, Miklos Szeredi wrote:
> On Tue, 24 Nov 2009, Jeff Layton wrote:
> > Since it's clear that these symlinks do need to have special semantics,
> > perhaps the approach you suggest would be the best thing. I'll have to
> > think about it a bit more.
> 
> open() is not the only thing you need to think about.  Anything that
> checks read or write permission on the inode (truncate, utimes,
> *xattr) would have to be changed to respect the open mode.
> 
> See, this is not just about hacking the proc follow_symlink code to
> check some lookup intent.  It's about changing the permission checking
> mechanism for theses beasts.  And since the permission checking is
> inode based, this is not at all trivial to do.
> 
> I still believe leaving the current semantics and documenting them is
> the best option.

I believe that current semantics is ugly enough that 'documenting' it
is not enough... and people want to port from other systems, too, not
expecting nasty surprises like this...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
