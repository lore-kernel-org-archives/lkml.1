Return-Path: <linux-kernel-owner+w=401wt.eu-S1423196AbXBUWXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423196AbXBUWXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423200AbXBUWXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:23:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423196AbXBUWXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:23:06 -0500
Date: Wed, 21 Feb 2007 14:19:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: Re: [-mm patch] UNION_FS must depend on SLAB
Message-Id: <20070221141944.af6001db.akpm@linux-foundation.org>
In-Reply-To: <20070220151356.GA19239@filer.fsl.cs.sunysb.edu>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	<20070220000810.GK13958@stusta.de>
	<84144f020702192237k78a5045bl51e0871fb3cac253@mail.gmail.com>
	<20070220151356.GA19239@filer.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 10:13:56 -0500
Josef Sipek <jsipek@fsl.cs.sunysb.edu> wrote:

> On Tue, Feb 20, 2007 at 08:37:34AM +0200, Pekka Enberg wrote:
> > On 2/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> > >  CC      fs/unionfs/copyup.o
> > >/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c: In 
> > >function 'create_parents_named':
> > >/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: 
> > >error: 'malloc_sizes' undeclared (first use in this function)
> > >/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: 
> > >error: (Each undeclared identifier is reported only once
> > >/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: 
> > >error: for each function it appears in.)
> > >make[3]: *** [fs/unionfs/copyup.o] Error 1
> > 
> > Hmm, why is unionfs playing around with malloc_sizes in the first place? 
> > Jeff?
> 
> The code is in lookup.c:
> 
> if (oldsize) {
> 	int minsize = malloc_sizes[0].cs_size;
> 
> 	if (!newsize || ((oldsize < newsize) && (newsize > minsize))) {
> 		kfree(info->lower_paths);
> 		info->lower_paths = NULL;
> 	}
> }
> 
> That's the only user of malloc_sizes. It is supposed to be an optimization -
> we get the smallest sized piece of memory even if we don't need all of it.
> This way we don't reallocate & memcpy needlessly.
> 

urgh, no, please don't poke around in slab internals like that.

If you want to propose an extension to the slab ABI the please do so and
we'll take a look at it.

I can't say more until I've managed to understand your description, which
might take a while.

