Return-Path: <linux-kernel-owner+w=401wt.eu-S2992841AbXDRQla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992841AbXDRQla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992842AbXDRQla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:41:30 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:8374 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992841AbXDRQl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:41:29 -0400
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Florin Iucha <florin@iucha.net>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1176884362.7066.3.camel@twins>
References: <20070416125905.GA2769@iucha.net>
	 <1176736734.6761.45.camel@heimdal.trondhjem.org>
	 <Pine.LNX.4.64.0704160904560.5473@woody.linux-foundation.org>
	 <1176740307.6761.56.camel@heimdal.trondhjem.org>
	 <1176741408.6761.62.camel@heimdal.trondhjem.org>
	 <1176792399.3035.30.camel@twins> <20070416125905.GA2769@iucha.net>
	 <1176792399.3035.30.camel@twins>  <1176796503.3035.33.camel@twins>
	 <87hcrfaqam.fsf@duaron.myhome.or.jp>
	 <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
	 <1176884362.7066.3.camel@twins>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 18:41:25 +0200
Message-Id: <1176914485.7066.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 10:19 +0200, Peter Zijlstra wrote:
> On Tue, 2007-04-17 at 21:19 -0400, Trond Myklebust wrote:
> > I've split the issues introduced by the 2.6.21-rcX write code up into 4
> > subproblems.
> > 
> > The first patch is just a cleanup in order to ease review.
> > 
> > Patch number 2 ensures that we never release the PG_writeback flag until
> > _after_ we've either discarded the unstable request altogether, or put it
> > on the nfs_inode's commit or dirty lists.
> > 
> > Patch number 3 fixes the 'desynchronized value of nfs_i.ncommit' error. It
> > uses the PG_NEED_COMMIT flag as an indicator for whether or not the request
> > may be redirtied.
> > 
> > Patch number 4 protects the NFS '.set_page_dirty' address_space operation
> > against races with nfs_inode_add_request.
> 
> Ok, stuck them in, and my debug patch from yesterday, just in case...
> 
> However, I can't seem to run long enough to establish whether the
> problem is gone. It deadlocks between 10-30 minutes due to missing IO
> completions, whereas yesterday it took between 45-60 minutes to trigger
> the 'desynchronized value of nfs_i.ncommit' messages.
> 
> I will continue trying go get a good run,

Just got one around 80-90 minutes, no 'desynchronized value of
nfs_i.ncommit' errors.

