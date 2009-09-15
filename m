Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbZIOJ2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbZIOJ2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbZIOJ2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:28:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37150 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbZIOJ2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:28:33 -0400
Date: Tue, 15 Sep 2009 11:28:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [origin tree build failure] [PATCH] block: remove
	blk_iopoll_enabled
Message-ID: <20090915092822.GA15538@elte.hu>
References: <20090913175902.GP14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090913175902.GP14984@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note, upstream now breaks the build occasionally if CONFIG_BLOCK is 
disabled:

 kernel/built-in.o:(.data+0x17b0): undefined reference to `blk_iopoll_enabled'

Kamalesh Babulal posted a fix for that two weeks ago, i suspect it 
should be picked up - find it below.

	Ingo

-------------------->
>From 3b049b5e648ebfa508d52e9184d1c6c2cd456a72 Mon Sep 17 00:00:00 2001
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date: Fri, 21 Aug 2009 16:41:13 +0530
Subject: [PATCH] block: remove blk_iopoll_enabled

* Jens Axboe <jens.axboe@oracle.com> [2009-08-07 21:21:44]:

> On Fri, Aug 07 2009, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > New block-iopoll sysctl should be surrounded by CONFIG_BLOCK to
> > prevent build error:
> >
> > kernel/built-in.o:(.data+0x2990): undefined reference to `blk_iopoll_enabled'
>
> Thanks, I'll just kill off this sysctl, it should be driver controller
> anyway. Was just easier for testing :-)

This build failure is still seen with next-20090820 kernel, removing
the sysctl helps. Attaching the patch based on your recommendation.
Please drop the patch if you already have in queue.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: akpm <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
LKML-Reference: <20090821111113.GA5105@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
--
 kernel/sysctl.c |    8 --------
 1 file changed, 8 deletions(-)
---
 kernel/sysctl.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6bb59f7..95a1805 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -998,14 +998,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "blk_iopoll",
-		.data		= &blk_iopoll_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
