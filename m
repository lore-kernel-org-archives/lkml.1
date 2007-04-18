Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbXDRDys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbXDRDys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbXDRDys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:54:48 -0400
Received: from mx2.netapp.com ([216.240.18.37]:36877 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXDRDyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:54:47 -0400
X-IronPort-AV: i="4.14,420,1170662400"; 
   d="scan'208"; a="52147120:sNHT15984031"
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Florin Iucha <florin@iucha.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070418033055.GA24044@iucha.net>
References: <1176740307.6761.56.camel@heimdal.trondhjem.org>
	 <1176741408.6761.62.camel@heimdal.trondhjem.org>
	 <1176792399.3035.30.camel@twins> <20070416125905.GA2769@iucha.net>
	 <1176792399.3035.30.camel@twins> <1176796503.3035.33.camel@twins>
	 <87hcrfaqam.fsf@duaron.myhome.or.jp>
	 <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
	 <20070417195823.943f9472.akpm@linux-foundation.org>
	 <1176865565.6796.16.camel@heimdal.trondhjem.org>
	 <20070418033055.GA24044@iucha.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Tue, 17 Apr 2007 23:54:45 -0400
Message-Id: <1176868485.6796.42.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 18 Apr 2007 03:54:51.0627 (UTC) FILETIME=[5126E3B0:01C7816D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 22:30 -0500, Florin Iucha wrote:
> On Tue, Apr 17, 2007 at 11:06:05PM -0400, Trond Myklebust wrote:
> > > > I've split the issues introduced by the 2.6.21-rcX write code up into 4
> > > > subproblems.
> > > > 
> > > > The first patch is just a cleanup in order to ease review.
> > > > 
> > > > Patch number 2 ensures that we never release the PG_writeback flag until
> > > > _after_ we've either discarded the unstable request altogether, or put it
> > > > on the nfs_inode's commit or dirty lists.
> > > > 
> > > > Patch number 3 fixes the 'desynchronized value of nfs_i.ncommit' error. It
> > > > uses the PG_NEED_COMMIT flag as an indicator for whether or not the request
> > > > may be redirtied.
> > > > 
> > > > Patch number 4 protects the NFS '.set_page_dirty' address_space operation
> > > > against races with nfs_inode_add_request.
> > > 
> > > For 2.6.21, yes?
> > 
> > Right. A couple of nasty regressions have been sighted. This series
> > attempts to deal with them all.
> 
> The good news is that the Gnome session log-in progresses to the point
> where both top and bottom bars are painted (gray) and the bottom bar
> is populated with icons (2.6.21-rc7 vanilla stops after displaying the
> splash).  The bad news is that it stops there.
> 
> Big-copy fails as well, after 2.5G transferred.
> 
> The process traces are at:
> 
>    http://iucha.net/nfs/21-rc7-nfs1/gnome-session
>    http://iucha.net/nfs/21-rc7-nfs1/big-copy
> 
> Regards,
> florin

Could you tell us a bit more about what happens when these hangs occur?
Does the networking stop too, or just NFS? How about CIFS?

Cheers
  Trond
