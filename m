Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbXJMTf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbXJMTf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 15:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbXJMTfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 15:35:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60991 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbXJMTfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 15:35:47 -0400
Date: Sat, 13 Oct 2007 12:28:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, shaggy@linux.vnet.ibm.com
Subject: Re: [PATCH] JFS: Bio cleanup: Replace missing return statements
Message-Id: <20071013122853.aafd3c00.randy.dunlap@oracle.com>
In-Reply-To: <20071013191110.GA20203@havoc.gtf.org>
References: <20071013191110.GA20203@havoc.gtf.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 15:11:10 -0400 Jeff Garzik wrote:

> 
> From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> 
> commit 6712ecf8f648118c3363c142196418f89a510b90 removed some "return 0;"
> statements, rather than changing them to null returns.

Is my git tree mucked up?  It looks to me like it was commit
e30408b2a99cb7b8bf529c7dc2328a19d71894cf  that removed the return 0's.


> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
> Dave sent this under a different cover, but just in case it was missed
> in the middle of the thread, I wanted to make sure it was not missed.
> 
>  fs/jfs/jfs_logmgr.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index ccfd029..15a3974 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -2234,6 +2234,8 @@ static void lbmIODone(struct bio *bio, int error)
>  
>  		/* wakeup I/O initiator */
>  		LCACHE_WAKEUP(&bp->l_ioevent);
> +
> +		return;
>  	}
>  
>  	/*
> @@ -2258,6 +2260,7 @@ static void lbmIODone(struct bio *bio, int error)
>  	if (bp->l_flag & lbmDIRECT) {
>  		LCACHE_WAKEUP(&bp->l_ioevent);
>  		LCACHE_UNLOCK(flags);
> +		return;
>  	}
>  
>  	tail = log->wqueue;

---
~Randy
