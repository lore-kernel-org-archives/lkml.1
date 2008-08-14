Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYHNLFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYHNLFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 07:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbYHNLEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 07:04:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1265 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753732AbYHNLEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 07:04:47 -0400
Date: Thu, 14 Aug 2008 07:53:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
Message-ID: <20080814055301.GH6995@ucw.cz>
References: <20080807224033.FFB3A2C1@kernel> <200808081146.54834.arnd@arndb.de> <1218221451.19082.36.camel@nimitz> <200808090013.41999.arnd@arndb.de> <1218234411.19082.58.camel@nimitz> <20080811150703.GA25930@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811150703.GA25930@us.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > I have to wonder if this is just a symptom of us trying to do this the
> > > > wrong way.  We're trying to talk the kernel into writing internal gunk
> > > > into a FD.  You're right, it is like a splice where one end of the pipe
> > > > is in the kernel.
> > > > 
> > > > Any thoughts on a better way to do this?  
> > > 
> > > Maybe you can invert the logic and let the new syscalls create a file
> > > descriptor, and then have user space read or splice the checkpoint
> > > data from it, and restore it by writing to the file descriptor.
> > > It's probably easy to do using anon_inode_getfd() and would solve this
> > > problem, but at the same time make checkpointing the current thread
> > > hard if not impossible.
> > 
> > Yeah, it does seem kinda backwards.  But, instead of even having to
> > worry about the anon_inode stuff, why don't we just put it in a fs like
> > everything else?  checkpointfs!
> 
> One reason is that I suspect that stops us from being able to send that
> data straight to a pipe to compress and/or send on the network, without
> hitting local disk.  Though if the checkpointfs was ram-based maybe not?
> 
> As Oren has pointed out before, passing in an fd means we can pass a
> socket into the syscall.

If you do pass a socket, will it handle blocking correctly? Getting
deadlocked task would be bad. What happens if I try to snapshot into
/proc/self/fd/0 ? Or maybe restore from /proc/cmdline?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
