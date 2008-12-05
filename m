Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYLEWWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYLEWWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 17:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYLEWVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 17:21:53 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41936 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYLEWVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 17:21:53 -0500
Date: Fri, 5 Dec 2008 22:21:45 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] shmem: unify regular and tiny shmem
In-Reply-To: <1228500936.3255.210.camel@calx>
Message-ID: <Pine.LNX.4.64.0812052218120.27321@blonde.anvils>
References: <1228425564.3255.121.camel@calx>  <Pine.LNX.4.64.0812051311530.10157@blonde.anvils>
 <1228500936.3255.210.camel@calx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008, Matt Mackall wrote:
> On Fri, 2008-12-05 at 13:18 +0000, Hugh Dickins wrote:
> > I agree with where you're going (surrendering your empire to mine!
> > or perhaps you don't you see it quite that way?), but I think this
> > isn't quite the patch you meant to send: it shouldn't contain that
> > 
> > > -			&shmem_file_operations);
> > > +		  &shmem_file_operations);
> > > +
> > > +#ifndef CONFIG_MMU
> > > +	error = ramfs_nommu_expand_for_mapping(inode, size);
> > > +	if (error)
> > > +		goto close_file;
> > > +#endif
> > 
> > hunk in mm/shmem.c
> 
> I'm staring at the source and I'm at a loss as to why not? SHMEM depends
> on MMU, so this only gets done when !SHMEM && !MMU, which makes it the
> same as the tiny-shmem.c code it's unifying, no?

Sorry for wasting your time puzzling over that, it was just me getting
confused with the ramfs_nommu_get_unmapped_area() bit which does vanish:
this part is fine.

Hugh

> 
> > and it should be deleting mm/tiny-shmem.c?
> 
> Not sure how that bit fell off, yes.
