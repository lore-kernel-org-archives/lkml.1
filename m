Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbXJLO1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbXJLO1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 10:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXJLO1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 10:27:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49597 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbXJLO1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:27:32 -0400
Subject: Re: [PATCH] JFS: fix bio-related build breakage
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071012040121.GA16274@havoc.gtf.org>
References: <20071012040121.GA16274@havoc.gtf.org>
Content-Type: text/plain
Date: Fri, 12 Oct 2007 09:27:24 -0500
Message-Id: <1192199244.12485.15.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'd say add my ack, but I see it's already been picked up.

Thanks,
Shaggy

On Fri, 2007-10-12 at 00:01 -0400, Jeff Garzik wrote:
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index 57c3b8a..ccfd029 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -2162,7 +2162,7 @@ static void lbmStartIO(struct lbuf * bp)
>  	/* check if journaling to disk has been disabled */
>  	if (log->no_integrity) {
>  		bio->bi_size = 0;
> -		lbmIODone(bio, 0, 0);
> +		lbmIODone(bio, 0);
>  	} else {
>  		submit_bio(WRITE_SYNC, bio);
>  		INCREMENT(lmStat.submitted);
> @@ -2234,8 +2234,6 @@ static void lbmIODone(struct bio *bio, int error)
>  
>  		/* wakeup I/O initiator */
>  		LCACHE_WAKEUP(&bp->l_ioevent);
> -
> -		return 0;
>  	}
>  
>  	/*
> @@ -2260,7 +2258,6 @@ static void lbmIODone(struct bio *bio, int error)
>  	if (bp->l_flag & lbmDIRECT) {
>  		LCACHE_WAKEUP(&bp->l_ioevent);
>  		LCACHE_UNLOCK(flags);
> -		return 0;
>  	}
>  
>  	tail = log->wqueue;
> @@ -2339,8 +2336,6 @@ static void lbmIODone(struct bio *bio, int error)
>  
>  		LCACHE_UNLOCK(flags);	/* unlock+enable */
>  	}
> -
> -	return 0;
>  }
>  
>  int jfsIOWait(void *arg)
-- 
David Kleikamp
IBM Linux Technology Center

