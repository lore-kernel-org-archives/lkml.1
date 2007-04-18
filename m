Return-Path: <linux-kernel-owner+w=401wt.eu-S1161427AbXDRBsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161427AbXDRBsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 21:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161436AbXDRBsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 21:48:08 -0400
Received: from c-69-242-210-120.hsd1.mi.comcast.net ([69.242.210.120]:57965
	"EHLO heimdal.trondhjem.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161427AbXDRBsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 21:48:07 -0400
X-Greylist: delayed 1124 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 21:48:07 EDT
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Date: Tue, 17 Apr 2007 21:19:46 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Florin Iucha <florin@iucha.net>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Message-Id: <20070418011946.11679.34920.stgit@heimdal.trondhjem.org>
In-Reply-To: <20070416125905.GA2769@iucha.net> <1176736734.6761.45.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0704160904560.5473@woody.linux-foundation.org> <1176740307.6761.56.camel@heimdal.trondhjem.org> <1176741408.6761.62.camel@heimdal.trondhjem.org> <1176792399.3035.30.camel@twins> <20070416125905.GA2769@iucha.net> <1176792399.3035.30.camel@twins>  <1176796503.3035.33.camel@twins> <87hcrfaqam.fsf@duaron.myhome.or.jp>
References: <20070416125905.GA2769@iucha.net> <1176736734.6761.45.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0704160904560.5473@woody.linux-foundation.org> <1176740307.6761.56.camel@heimdal.trondhjem.org> <1176741408.6761.62.camel@heimdal.trondhjem.org> <1176792399.3035.30.camel@twins> <20070416125905.GA2769@iucha.net> <1176792399.3035.30.camel@twins>  <1176796503.3035.33.camel@twins> <87hcrfaqam.fsf@duaron.myhome.or.jp>
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

Cheers
  Trond
