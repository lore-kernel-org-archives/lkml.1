Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYLKJ5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYLKJ5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 04:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYLKJ45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 04:56:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbYLKJ44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 04:56:56 -0500
Date: Thu, 11 Dec 2008 10:56:53 +0100
From: Karsten Keil <kkeil@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Karsten Keil <kkeil@novell.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] use rwlock runtime init for drivers/isdn/mISDN/tei.c
Message-ID: <20081211095653.GB25500@pingi.kke.suse.de>
References: <alpine.DEB.1.10.0812101438520.11805@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812101438520.11805@gandalf.stny.rr.com>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.60-0.27-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 02:40:32PM -0500, Steven Rostedt wrote:
> 
Thanks for bring up this again, I already sent this patch
several times some months ago:


>From 65b212b2e8dc37904e3b88882fa15cf9eceb3510 Mon Sep 17 00:00:00 2001
From: Karsten Keil <kkeil@suse.de>
Date: Wed, 6 Aug 2008 15:14:58 +0200
Subject: [PATCH] Fix lockdep warning

use correct dynamic spinlock init function.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/mISDN/tei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index 6fbae42..d8af45c 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -1287,7 +1287,7 @@ create_teimanager(struct mISDNdevice *dev)
 	if (!mgr)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&mgr->layer2);
-	mgr->lock = __RW_LOCK_UNLOCKED(mgr->lock);
+	rwlock_init(&mgr->lock);
 	skb_queue_head_init(&mgr->sendq);
 	mgr->nextid = 1;
 	mgr->lastid = MISDN_ID_NONE;
-- 
1.5.6.4



> The following patch is in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: cleanups
> 
> 
> Steven Rostedt (1):
>       use rwlock runtime init for drivers/isdn/mISDN/tei.c
> 
> ----
>  drivers/isdn/mISDN/tei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> ---------------------------
> commit 30bb0d7d6956526eedb5ad30b9d6ff085801d788
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Wed Dec 10 14:25:23 2008 -0500
> 
>     use rwlock runtime init for drivers/isdn/mISDN/tei.c
>     
>     Impact: clean up
>     
>     __RW_LOCK_UNLOCKED(lock) is meant for compile time initializations.
>     rwlock_init(&lock) is used for run time initialization.
>     
>     This patch converts drivers/isdn/mISDN/tei.c to initialize the
>     mrg->lock rwlock.
>     
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
> index 6fbae42..d8af45c 100644
> --- a/drivers/isdn/mISDN/tei.c
> +++ b/drivers/isdn/mISDN/tei.c
> @@ -1287,7 +1287,7 @@ create_teimanager(struct mISDNdevice *dev)
>  	if (!mgr)
>  		return -ENOMEM;
>  	INIT_LIST_HEAD(&mgr->layer2);
> -	mgr->lock = __RW_LOCK_UNLOCKED(mgr->lock);
> +	rwlock_init(&mgr->lock);
>  	skb_queue_head_init(&mgr->sendq);
>  	mgr->nextid = 1;
>  	mgr->lastid = MISDN_ID_NONE;

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
