Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbZIIHbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbZIIHbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 03:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZIIHbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 03:31:49 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:56169 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbZIIHbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 03:31:49 -0400
Subject: Re: [patch 00/48] 2.6.27.32-stable review
References: <20090909030843.GC10608@suse.de>
From: Michael Tokarev <mjt@tls.msk.ru>
To: Linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Message-Id: <20090909073150.44F8C12B5F@gandalf.tls.msk.ru>
Date: Wed,  9 Sep 2009 11:31:50 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Sep 08, 2009 at 09:47:51AM -0500, Jayson King wrote:
> > Greetings,
> > 
> > Patch 41/48 (ocfs2: Initialize the...) of this series causes a build 
> > failure:
> > 
> > fs/ocfs2/aops.c: In function `ocfs2_write_cluster':
> > fs/ocfs2/aops.c:1286: error: `should_zero' undeclared (first use in this function)
> > fs/ocfs2/aops.c:1286: error: (Each undeclared identifier is reported only once
> > fs/ocfs2/aops.c:1286: error: for each function it appears in.)
> > fs/ocfs2/aops.c: In function `ocfs2_write_cluster_by_desc':
... 
> > 
> > A line from the upstream patch is missing in this patch:
> > 
> >   static int ocfs2_write_cluster(struct address_space *mapping,
> >                      u32 phys, unsigned int unwritten,
> > +                   unsigned int should_zero,
> >                      struct ocfs2_alloc_context *data_ac,
> >                      struct ocfs2_alloc_context *meta_ac,
> >                      struct ocfs2_write_ctxt *wc, u32 cpos,
> >                      loff_t user_pos, unsigned user_len)
> > 
> > 
> > Attached is the corrected patch with the above line placed back in.
> 
> There was an add-on ocfs2 patch that should have now resolved this
> issue.  If you still have this problem with the released kernel, please
> let me know.

Well, with just-released 2.6.27.32 exactly the same issue occurs.
I used patch-2.6.27.32.bz2 on top of linux-2.6.26.tar.bz2, not
the tarball (linux-2.6.27.32.tar.bz2).

fs/ocfs2/aops.c: In function 'ocfs2_write_cluster':
fs/ocfs2/aops.c:1286: error: 'should_zero' undeclared (first use in this function)
fs/ocfs2/aops.c:1286: error: (Each undeclared identifier is reported only once
fs/ocfs2/aops.c:1286: error: for each function it appears in.)
fs/ocfs2/aops.c: In function 'ocfs2_write_cluster_by_desc':
fs/ocfs2/aops.c:1360: warning: passing argument 4 of 'ocfs2_write_cluster' makes pointer from integer without a cast
fs/ocfs2/aops.c:1360: warning: passing argument 6 of 'ocfs2_write_cluster' from incompatible pointer type
fs/ocfs2/aops.c:1360: warning: passing argument 7 of 'ocfs2_write_cluster' makes integer from pointer without a cast
fs/ocfs2/aops.c:1360: error: too many arguments to function 'ocfs2_write_cluster'

Which add-on you're referring to?  In the stable-queue/releases/2.6.27.32/
I only see two patches related to ocfs:
 ocfs2-initialize-the-cluster-we-re-writing-to-in-a-non-sparse-extend.patch
 ocfs2-ocfs2_write_begin_nolock-should-handle-len-0.patch
Neither of which looks like an addon, and only one (the first)
has references to this "should_zero" variable.

Thanks!

/mjt
