Return-Path: <linux-kernel-owner+w=401wt.eu-S1751489AbXBVDLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbXBVDLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXBVDLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:11:51 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39172 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbXBVDLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:11:50 -0500
Date: Wed, 21 Feb 2007 22:10:31 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: Re: [-mm patch] UNION_FS must depend on SLAB
Message-ID: <20070222031031.GF5867@filer.fsl.cs.sunysb.edu>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <20070220000810.GK13958@stusta.de> <84144f020702192237k78a5045bl51e0871fb3cac253@mail.gmail.com> <20070220151356.GA19239@filer.fsl.cs.sunysb.edu> <20070221141944.af6001db.akpm@linux-foundation.org> <20070222020036.GE5867@filer.fsl.cs.sunysb.edu> <20070221182657.57264123.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221182657.57264123.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 06:26:57PM -0800, Andrew Morton wrote:
> On Wed, 21 Feb 2007 21:00:39 -0500 Josef Sipek <jsipek@fsl.cs.sunysb.edu> wrote:
> 
> > > I can't say more until I've managed to understand your description, which
> > > might take a while.
> > 
> > It is intended for reallocation of a buffer. The code in lookup.c allocates
> > some memory, and it may have to reallocate the buffer. The code tries to
> > prevent some unneeded allocations by looking at what the smallest object the
> > slabcache gives you is.
> > 
> > I hope this explains it better. There's some discussion about this in the
> > threads by Pekka Enberg.
> 
> Problem is, it doesn't seem that we'll be merging unionfs any time soon so
> we shouldn't be adding slab infrastructure on its behalf.  And I'd prefer
> not to have to carry slab changes in a filesystem tree.
> 
> Although if the changes are generally ok-looking and are compact then it'd
> be OK, but I do need to be alert for someone who comes along and uses that
> infrastructure in an unrelated patch, which has happened before.  When I
> prep the patch for an upstream merge, oops, doesn't compile any more.
 
Sounds reasonable to be weary of patches like that...
 
> So for now, it'd be best to jsut forget about the optimisation.

Well...

> How useful is it, anyway?

The code in lookup gets called frequently enough that I'm not sure. Whenever
one touches a file on a read-only branch, a copyup is done. This may have to
recreate the directory hierarchy leading up to the file - since the VFS
doesn't have such code, unionfs builds up a stack of all the path
components, and then it pops them off one at a time calling vfs_mkdir for
each. The stack creation is where we do this "reallocation."

Josef "Jeff" Sipek.

-- 
I'm somewhere between geek and normal.
		- Linus Torvalds
