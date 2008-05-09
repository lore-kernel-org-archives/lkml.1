Return-Path: <linux-kernel-owner+w=401wt.eu-S933616AbYEISLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616AbYEISLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYEISLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:11:13 -0400
Received: from mail.fieldses.org ([66.93.2.214]:39874 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYEISLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:11:12 -0400
Date: Fri, 9 May 2008 14:11:06 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [patch 1/9] lockd: dont return EAGAIN from blocking lock
	request
Message-ID: <20080509181106.GF1907@fieldses.org>
References: <20080509124107.645600519@szeredi.hu> <20080509124127.179314495@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509124127.179314495@szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 02:41:08PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> EAGAIN does not make sense as a return value from a blocking lock

But nlm_stat_to_errno() is called in the non-blocking case too, right?
What am I missing?

--b.

> request, the lock should be retried by the kernel until either it is
> successful or fails permanently.
> 
> Looking at the server side NLM_LCK_DENIED means a permanent error in
> this case, so just turn this into an ENOLCK.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: Trond Myklebust <trond.myklebust@fys.uio.no>
> CC: "J. Bruce Fields" <bfields@fieldses.org>
> ---
>  fs/lockd/clntproc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/fs/lockd/clntproc.c
> ===================================================================
> --- linux-2.6.orig/fs/lockd/clntproc.c	2008-05-09 14:04:16.000000000 +0200
> +++ linux-2.6/fs/lockd/clntproc.c	2008-05-09 14:04:46.000000000 +0200
> @@ -808,7 +808,7 @@ nlm_stat_to_errno(__be32 status)
>  	case NLM_LCK_GRANTED:
>  		return 0;
>  	case NLM_LCK_DENIED:
> -		return -EAGAIN;
> +		return -ENOLCK;
>  	case NLM_LCK_DENIED_NOLOCKS:
>  	case NLM_LCK_DENIED_GRACE_PERIOD:
>  		return -ENOLCK;
> 
> --
