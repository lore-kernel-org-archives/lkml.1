Return-Path: <linux-kernel-owner+w=401wt.eu-S1751249AbXBMKpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbXBMKpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbXBMKpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:45:30 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:45323 "EHLO
	amsfep12-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751249AbXBMKp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:45:29 -0500
Subject: Re: [GIT] NFS client updates for 2.6.20
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       nfs <nfs@lists.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1171352394.6177.5.camel@heimdal.trondhjem.org>
References: <1171352394.6177.5.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 11:43:52 +0100
Message-Id: <1171363432.24923.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 23:39 -0800, Trond Myklebust wrote:

> commit 7c85d9007d05436e71d2b805b96c1e36a8193bd4
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Wed Dec 13 15:23:48 2006 -0500
> 
>     NFS: Fixup some outdated comments...
>     
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

A few new comments would be appreciated :-)

> commit 02241bc47e8961768de83d855accd0dcad1df045
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Sat Jan 13 02:28:07 2007 -0500
> 
>     NFS: Ensure that ->writepage() uses flush_stable() when reclaiming pages
>     
>     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

That patch seems to make all ->writepage() calls use stable storage.
Of course, given that there are no other ->writepage() calls this
works out.

I've been using this:
---

Subject: nfs: only use stable storage for swap

unstable writes don't make sense for swap pages.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
---
 fs/nfs/write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-git/fs/nfs/write.c
===================================================================
--- linux-2.6-git.orig/fs/nfs/write.c	2007-01-09 11:38:25.000000000 +0100
+++ linux-2.6-git/fs/nfs/write.c	2007-01-09 13:40:34.000000000 +0100
@@ -231,7 +231,7 @@ static int nfs_writepage_setup(struct nf
 static int wb_priority(struct writeback_control *wbc)
 {
 	if (wbc->for_reclaim)
-		return FLUSH_HIGHPRI;
+		return FLUSH_HIGHPRI|FLUSH_STABLE;
 	if (wbc->for_kupdate)
 		return FLUSH_LOWPRI;
 	return 0;


