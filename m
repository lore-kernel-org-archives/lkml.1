Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbZJDVmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbZJDVmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 17:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbZJDVmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 17:42:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbZJDVmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 17:42:03 -0400
Subject: Re: [PATCH 00/31] Swap over NFS -v20
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Hellwig <hch@infradead.org>
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       trond.myklebust@fys.uio.no
In-Reply-To: <20091001174201.GA30068@infradead.org>
References: <1254405858-15651-1-git-send-email-sjayaraman@suse.de>
	 <20091001174201.GA30068@infradead.org>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 23:41:22 +0200
Message-Id: <1254692482.21044.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 13:42 -0400, Christoph Hellwig wrote:
> One of them
> would be the whole VM/net work to just make swap over nbd/iscsi safe.

Getting those two 'fixed' is going to be tons of interesting work
because they involve interaction with userspace daemons.

NBD has fairly simple userspace, but iSCSI has a rather large userspace
footprint and a rather complicated user/kernel interaction which will be
mighty interesting to get allocation safe.

Ideally the swap-over-$foo bits have no userspace component.

That said, Wouter is the NBD userspace maintainer and has expressed
interest into looking at making that work, but its sure going to be
non-trivial, esp. since exposing PF_MEMALLOC to userspace is a, not over
my dead-bodym like thing.

