Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbXHaVqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbXHaVqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXHaVpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:45:54 -0400
Received: from mail.fieldses.org ([66.93.2.214]:52966 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbXHaVpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:45:53 -0400
Date: Fri, 31 Aug 2007 17:45:51 -0400
To: "Morrison, Tom" <tmorrison@empirix.com>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Follow up to: NFS/RPC Hangs after updating time...
Message-ID: <20070831214551.GP11165@fieldses.org>
References: <BD261180E6D35F4D9D32F3E44FD3D90108F975FB@EMPBEDEX.empirix.com> <20070822202639.GL20946@fieldses.org> <BD261180E6D35F4D9D32F3E44FD3D901091DE759@EMPBEDEX.empirix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD261180E6D35F4D9D32F3E44FD3D901091DE759@EMPBEDEX.empirix.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 02:35:19PM -0400, Morrison, Tom wrote:
> This is a follow-up...
> 
> After a huge pain in the rear upgrading from a 
> 2.6.11++ to a 2.6.23-rc3 (I'll give the powerpc
> folks a 'piece' of my mind on that front) - the 
> NFS hang problem that I was experiencing on the 
> older kernel is NOT occurring on this new version.
> 
> Now what do I do?

Well, between the time jump and the rpc debugging output, you've got
some great clues there--given some time I'm sure it would be possible to
completely figure out what's going on.

Unfortunately the people with the most knowledge of the code probably
don't have the time to fix problems on old kernels, so unless somebody
else recognizes the problem immediately, I'm not sure what to suggest.
Obviously, a wholesale upgrade to a more recent kernel would be the one
sure bet....

> Is the net/sunrpc net/nfsx pieces isolated enough 
> from the rest of the kernel that I could fork-lift 
> it back to the 2.6.11 (or is that really a lost cause).

I suspect it's a lost cause.  A lot has happened in the last couple
years.

--b.

> > It hangs after attempting to update the time from a 
> > nonsensical time (e.g.: 2 months ago) - the most significant
> > part of it is that it only hangs IFF it has started 
> > serving its NFS client boards before I attempt to 
> > update the time.
> > 
> > 
> > The most significant output (when turning on 
> > RPC debugging) is from:
> > 
> >   linux/net/sunrpc/cache.c (cache_check) - line 90:
> > 
> >          >> Want update, refage=1800, age=4288285
> > 
> > It continually loops through this method - and the cache
> > never gets updated...even thought with some additional
> > sleuthing (aka: additional debug printks - it thinks 
> > that there is an cache update pending).
> 
> Can you reproduce the problem with the current kernel? (Say 2.6.22 or
> later?)
> 
> --b.
