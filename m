Return-Path: <linux-kernel-owner+w=401wt.eu-S1764809AbYHHW1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764809AbYHHW1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764670AbYHHW04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:26:56 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42889 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763823AbYHHW0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:26:55 -0400
Subject: Re: [RFC][PATCH 1/4] checkpoint-restart: general infrastructure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>
In-Reply-To: <200808090013.41999.arnd@arndb.de>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808081146.54834.arnd@arndb.de> <1218221451.19082.36.camel@nimitz>
	 <200808090013.41999.arnd@arndb.de>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 15:26:51 -0700
Message-Id: <1218234411.19082.58.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-09 at 00:13 +0200, Arnd Bergmann wrote:
> > I have to wonder if this is just a symptom of us trying to do this the
> > wrong way.  We're trying to talk the kernel into writing internal gunk
> > into a FD.  You're right, it is like a splice where one end of the pipe
> > is in the kernel.
> > 
> > Any thoughts on a better way to do this?  
> 
> Maybe you can invert the logic and let the new syscalls create a file
> descriptor, and then have user space read or splice the checkpoint
> data from it, and restore it by writing to the file descriptor.
> It's probably easy to do using anon_inode_getfd() and would solve this
> problem, but at the same time make checkpointing the current thread
> hard if not impossible.

Yeah, it does seem kinda backwards.  But, instead of even having to
worry about the anon_inode stuff, why don't we just put it in a fs like
everything else?  checkpointfs!

I'm also really not convinced that putting the entire checkpoint in one
glob is really the solution, either.  I mean, is system call overhead
really a problem here?

-- Dave

