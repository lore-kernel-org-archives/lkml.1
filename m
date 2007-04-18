Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXDRDBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXDRDBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 23:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965407AbXDRDBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 23:01:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:45127 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965379AbXDRDBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 23:01:45 -0400
Date: Tue, 17 Apr 2007 19:58:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Florin Iucha <florin@iucha.net>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-Id: <20070417195823.943f9472.akpm@linux-foundation.org>
In-Reply-To: <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
References: <20070416125905.GA2769@iucha.net>
	<1176736734.6761.45.camel@heimdal.trondhjem.org>
	<Pine.LNX.4.64.0704160904560.5473@woody.linux-foundation.org>
	<1176740307.6761.56.camel@heimdal.trondhjem.org>
	<1176741408.6761.62.camel@heimdal.trondhjem.org>
	<1176792399.3035.30.camel@twins>
	<20070416125905.GA2769@iucha.net>
	<1176792399.3035.30.camel@twins>
	<1176796503.3035.33.camel@twins>
	<87hcrfaqam.fsf@duaron.myhome.or.jp>
	<20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 21:19:46 -0400 Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> 
> I've split the issues introduced by the 2.6.21-rcX write code up into 4
> subproblems.
> 
> The first patch is just a cleanup in order to ease review.
> 
> Patch number 2 ensures that we never release the PG_writeback flag until
> _after_ we've either discarded the unstable request altogether, or put it
> on the nfs_inode's commit or dirty lists.
> 
> Patch number 3 fixes the 'desynchronized value of nfs_i.ncommit' error. It
> uses the PG_NEED_COMMIT flag as an indicator for whether or not the request
> may be redirtied.
> 
> Patch number 4 protects the NFS '.set_page_dirty' address_space operation
> against races with nfs_inode_add_request.

For 2.6.21, yes?

I diligently tried to review this code but alas, it seems that my NFS
knowledge remains not up to the task.  Please avoid buses.

At least it compiles with all the configs I could think of ;)
