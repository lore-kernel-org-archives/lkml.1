Return-Path: <linux-kernel-owner+w=401wt.eu-S933528AbXCJIQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528AbXCJIQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933529AbXCJIQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:16:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3890 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933528AbXCJIQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:16:57 -0500
Date: Sat, 10 Mar 2007 08:06:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch v2] epoll use a single inode ...
Message-ID: <20070310080607.GA6511@ucw.cz>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > @@ -763,15 +767,17 @@
> > >  	 * using the inode number.
> > >  	 */
> > >  	error = -ENOMEM;
> > > -	sprintf(name, "[%lu]", inode->i_ino);
> > >  	this.name = name;
> > > -	this.len = strlen(name);
> > > -	this.hash = inode->i_ino;
> > > +	this.len = sprintf(name, "[%p]", ep);
> > > +	this.hash = 0;
> > 
> > Please don't expose kernel pointers to user space.
> > 
> > It's much better to do something like
> > 
> > 	static unsigned int epoll_inode;
> > 
> > 	this.len = sprintf(name, "[%u]", ++epoll_inode);
> > 
> > if you just need some pseudo-unique name to distinguish two epoll things 
> > from each other (vs from a dup'ed fd).
> 
> Heh, this is what Al was saying ;)
> I'm fine with that, but how about counter cycles (going back to zero)? 

Just use u64?
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
