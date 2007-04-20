Return-Path: <linux-kernel-owner+w=401wt.eu-S1767245AbXDTUe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767245AbXDTUe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767248AbXDTUeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:34:19 -0400
Received: from dh166.citi.umich.edu ([141.211.133.166]:47391 "EHLO
	heimdal.trondhjem.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767250AbXDTUeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:34:11 -0400
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 0/5] 2.6.21-rc7 NFS writes: fix a series of issues
Date: Fri, 20 Apr 2007 16:03:58 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Florin Iucha <florin@iucha.net>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Chuck Lever <chuck.lever@oracle.com>, linux-kernel@vger.kernel.org,
       nfs@lists.sourceforge.net
Message-Id: <20070420200358.7897.75870.stgit@heimdal.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've split the issues introduced by the 2.6.21-rcX write code up into 4
subproblems.

The first patch is just a cleanup in order to ease review.

Patch number 2 ensures that we never release the PG_writeback flag until
_after_ we've either discarded the unstable request altogether, or put it
on the nfs_inode's commit or dirty lists.

Patch number 3 fixes the 'desynchronized value of nfs_i.ncommit' error. It
uses the PG_NEED_COMMIT flag as an indicator for whether or not the request
may be redirtied.

Patch number 4 protects the NFS '.set_page_dirty' address_space operation
against races with nfs_inode_add_request.

Finally, patch number 5 fixes an issue with the RPC code that is supposed
ensure that NFSv4 disconnects before resending a request. The current code
will disconnect for every request it resends (and has a bunch of false
positive cases), instead of just ensuring that it disconnects once every
time a timeout or a garbage reply occurs.

My thanks to the various patient victim^Wpeople who helped with extensive
testing.

Cheers
  Trond
