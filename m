Return-Path: <linux-kernel-owner+w=401wt.eu-S934089AbXJPSEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089AbXJPSEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964910AbXJPSDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:03:47 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48078 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934866AbXJPSDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:03:42 -0400
Date: Tue, 16 Oct 2007 14:02:38 -0400
Message-Id: <200710161802.l9GI2ca6012758@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Erez Zadok" <ezk@cs.sunysb.edu>, "Hugh Dickins" <hugh@veritas.com>,
       "Ryan Finnie" <ryan@finnie.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       cjwatson@ubuntu.com, linux-mm@kvack.org
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland 
In-reply-to: Your message of "Mon, 15 Oct 2007 14:47:52 +0300."
             <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <84144f020710150447o94b1babo8b6e6a647828465f@mail.gmail.com>, "Pekka Enberg" writes:
> Hi,
> 
> On 10/15/07, Erez Zadok <ezk@cs.sunysb.edu> wrote:
> > Pekka, with a small change to your patch (to handle time-based cache
> > coherency), your patch worked well and passed all my tests.  Thanks.
> >
> > So now I wonder if we still need the patch to prevent AOP_WRITEPAGE_ACTIVATE
> > from being returned to userland.  I guess we still need it, b/c even with
> > your patch, generic_writepages() can return AOP_WRITEPAGE_ACTIVATE back to
> > the VFS and we need to ensure that doesn't "leak" outside the kernel.
> 
> I wonder whether _not setting_ BDI_CAP_NO_WRITEBACK implies that
> ->writepage() will never return AOP_WRITEPAGE_ACTIVATE for
> !wbc->for_reclaim case which would explain why we haven't hit this bug
> before. Hugh, Andrew?
> 
> And btw, I think we need to fix ecryptfs too.

Yes, ecryptfs needs this fix too (and probably a couple of other mmap fixes
I've made to unionfs recently -- Mike Halcrow already knows :-)

Of course, running ecryptfs on top of tmpfs is somewhat odd and uncommon;
but with unionfs, users use tmpfs as the copyup branch very often.

>                                            Pekka

Erez.
