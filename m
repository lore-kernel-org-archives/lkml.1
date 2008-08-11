Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYHKPIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYHKPIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYHKPHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:07:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49577 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYHKPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:07:52 -0400
Date: Mon, 11 Aug 2008 10:07:03 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, containers@lists.linux-foundation.org,
       Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
Message-ID: <20080811150703.GA25930@us.ibm.com>
References: <20080807224033.FFB3A2C1@kernel> <200808081146.54834.arnd@arndb.de> <1218221451.19082.36.camel@nimitz> <200808090013.41999.arnd@arndb.de> <1218234411.19082.58.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218234411.19082.58.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Sat, 2008-08-09 at 00:13 +0200, Arnd Bergmann wrote:
> > > I have to wonder if this is just a symptom of us trying to do this the
> > > wrong way.  We're trying to talk the kernel into writing internal gunk
> > > into a FD.  You're right, it is like a splice where one end of the pipe
> > > is in the kernel.
> > > 
> > > Any thoughts on a better way to do this?  
> > 
> > Maybe you can invert the logic and let the new syscalls create a file
> > descriptor, and then have user space read or splice the checkpoint
> > data from it, and restore it by writing to the file descriptor.
> > It's probably easy to do using anon_inode_getfd() and would solve this
> > problem, but at the same time make checkpointing the current thread
> > hard if not impossible.
> 
> Yeah, it does seem kinda backwards.  But, instead of even having to
> worry about the anon_inode stuff, why don't we just put it in a fs like
> everything else?  checkpointfs!

One reason is that I suspect that stops us from being able to send that
data straight to a pipe to compress and/or send on the network, without
hitting local disk.  Though if the checkpointfs was ram-based maybe not?

As Oren has pointed out before, passing in an fd means we can pass a
socket into the syscall.

Using the anon_inodes would also prevent that, but if it makes for a
cleaner overall solution then I'm not against considering either one
of course.

> I'm also really not convinced that putting the entire checkpoint in one
> glob is really the solution, either.  I mean, is system call overhead
> really a problem here?
> 
> -- Dave
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
