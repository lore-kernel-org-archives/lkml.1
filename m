Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbXJTRWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbXJTRWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 13:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbXJTRWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 13:22:23 -0400
Received: from mx2.netapp.com ([216.240.18.37]:24903 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbXJTRWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 13:22:22 -0400
X-IronPort-AV: E=Sophos;i="4.21,304,1188802800"; 
   d="scan'208";a="115462095"
Subject: Re: [NFS] [GIT] NFS client fixes for 2.6.23++
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0710191929340.3794@woody.linux-foundation.org>
References: <200710200219.l9K2JMI8015439@agora.fsl.cs.sunysb.edu>
	 <alpine.LFD.0.999.0710191929340.3794@woody.linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Sat, 20 Oct 2007 13:22:37 -0400
Message-Id: <1192900957.7440.10.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-OriginalArrivalTime: 20 Oct 2007 17:22:21.0061 (UTC) FILETIME=[C5AF9350:01C8133D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-10-19 at 19:32 -0700, Linus Torvalds wrote:
> 
> On Fri, 19 Oct 2007, Erez Zadok wrote:
> > 
> > Trond, with Linus's latest tree, you need to #include <linux/sched.h> in
> > fs/nfs/unlink.c, else I get:
> > 
> >   CC [M]  fs/nfs/unlink.o
> > fs/nfs/unlink.c: In function 'nfs_dec_sillycount':
> > fs/nfs/unlink.c:67: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
> ...
> 
> Hmm? Which architecture?
> 
> That said, I do think that there is a distinct lack of proper includes in 
> that file. It seems to depend on getting much of the includes indirectly 
> from <linux/nfs_fs.h> and friends. And with different architectures having 
> different header files..
> 
> 		Linus

This ought to fix it.
----------------------------------------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Sat, 20 Oct 2007 13:21:04 -0400
NFS: Fix the include files needed by fs/nfs/unlink.c

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/unlink.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 6ecd46c..057e6ce 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -5,9 +5,14 @@
  *
  */
 
+#include <asm/atomic.h>
+#include <linux/dcache.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/dcache.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/sunrpc/auth.h>
 #include <linux/sunrpc/sched.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfs_fs.h>
