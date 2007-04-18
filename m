Return-Path: <linux-kernel-owner+w=401wt.eu-S1031320AbXDRDGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031320AbXDRDGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031319AbXDRDGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:06:12 -0400
Received: from mx2.netapp.com ([216.240.18.37]:36874 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030851AbXDRDGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:06:08 -0400
X-IronPort-AV: i="4.14,420,1170662400"; 
   d="scan'208"; a="52137548:sNHT15584415"
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Florin Iucha <florin@iucha.net>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070417195823.943f9472.akpm@linux-foundation.org>
References: <20070416125905.GA2769@iucha.net>
	 <1176736734.6761.45.camel@heimdal.trondhjem.org>
	 <Pine.LNX.4.64.0704160904560.5473@woody.linux-foundation.org>
	 <1176740307.6761.56.camel@heimdal.trondhjem.org>
	 <1176741408.6761.62.camel@heimdal.trondhjem.org>
	 <1176792399.3035.30.camel@twins> <20070416125905.GA2769@iucha.net>
	 <1176792399.3035.30.camel@twins> <1176796503.3035.33.camel@twins>
	 <87hcrfaqam.fsf@duaron.myhome.or.jp>
	 <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
	 <20070417195823.943f9472.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Tue, 17 Apr 2007 23:06:05 -0400
Message-Id: <1176865565.6796.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 18 Apr 2007 03:06:12.0016 (UTC) FILETIME=[84ED9B00:01C78166]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 19:58 -0700, Andrew Morton wrote:
> On Tue, 17 Apr 2007 21:19:46 -0400 Trond Myklebust <Trond.Myklebust@netapp.com> wrote:
> 
> > 
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
> For 2.6.21, yes?

Right. A couple of nasty regressions have been sighted. This series
attempts to deal with them all.

> I diligently tried to review this code but alas, it seems that my NFS
> knowledge remains not up to the task.  Please avoid buses.
> 
> At least it compiles with all the configs I could think of ;)

I was mainly interested in feedback from Peter, Florin and Ogawa-san to
find out if this series fixes their problems. You were unfortunate
enough to have been on earlier Ccs, so I didn't dare trim you off. :-)

Cheers
  Trond
