Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXBVCah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXBVCah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbXBVCag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:30:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34078 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbXBVCaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:30:19 -0500
Date: Wed, 21 Feb 2007 18:26:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: Re: [-mm patch] UNION_FS must depend on SLAB
Message-Id: <20070221182657.57264123.akpm@linux-foundation.org>
In-Reply-To: <20070222020036.GE5867@filer.fsl.cs.sunysb.edu>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	<20070220000810.GK13958@stusta.de>
	<84144f020702192237k78a5045bl51e0871fb3cac253@mail.gmail.com>
	<20070220151356.GA19239@filer.fsl.cs.sunysb.edu>
	<20070221141944.af6001db.akpm@linux-foundation.org>
	<20070222020036.GE5867@filer.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 21:00:39 -0500 Josef Sipek <jsipek@fsl.cs.sunysb.edu> wrote:

> > I can't say more until I've managed to understand your description, which
> > might take a while.
> 
> It is intended for reallocation of a buffer. The code in lookup.c allocates
> some memory, and it may have to reallocate the buffer. The code tries to
> prevent some unneeded allocations by looking at what the smallest object the
> slabcache gives you is.
> 
> I hope this explains it better. There's some discussion about this in the
> threads by Pekka Enberg.

Problem is, it doesn't seem that we'll be merging unionfs any time soon so
we shouldn't be adding slab infrastructure on its behalf.  And I'd prefer
not to have to carry slab changes in a filesystem tree.

Although if the changes are generally ok-looking and are compact then it'd
be OK, but I do need to be alert for someone who comes along and uses that
infrastructure in an unrelated patch, which has happened before.  When I
prep the patch for an upstream merge, oops, doesn't compile any more.


So for now, it'd be best to jsut forget about the optimisation.

How useful is it, anyway?
