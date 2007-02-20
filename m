Return-Path: <linux-kernel-owner+w=401wt.eu-S965027AbXBTPPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027AbXBTPPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965031AbXBTPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:15:09 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33231 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965027AbXBTPPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:15:07 -0500
Date: Tue, 20 Feb 2007 10:13:56 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, unionfs@filesystems.org
Subject: Re: [-mm patch] UNION_FS must depend on SLAB
Message-ID: <20070220151356.GA19239@filer.fsl.cs.sunysb.edu>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <20070220000810.GK13958@stusta.de> <84144f020702192237k78a5045bl51e0871fb3cac253@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020702192237k78a5045bl51e0871fb3cac253@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 08:37:34AM +0200, Pekka Enberg wrote:
> On 2/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> >  CC      fs/unionfs/copyup.o
> >/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c: In 
> >function 'create_parents_named':
> >/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: 
> >error: 'malloc_sizes' undeclared (first use in this function)
> >/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: 
> >error: (Each undeclared identifier is reported only once
> >/home/bunk/linux/kernel-2.6/linux-2.6.20-mm2/fs/unionfs/copyup.c:620: 
> >error: for each function it appears in.)
> >make[3]: *** [fs/unionfs/copyup.o] Error 1
> 
> Hmm, why is unionfs playing around with malloc_sizes in the first place? 
> Jeff?

The code is in lookup.c:

if (oldsize) {
	int minsize = malloc_sizes[0].cs_size;

	if (!newsize || ((oldsize < newsize) && (newsize > minsize))) {
		kfree(info->lower_paths);
		info->lower_paths = NULL;
	}
}

That's the only user of malloc_sizes. It is supposed to be an optimization -
we get the smallest sized piece of memory even if we don't need all of it.
This way we don't reallocate & memcpy needlessly.

Josef "Jeff" Sipek.

-- 
In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like
that.
		- Linus Torvalds
