Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbYELBUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbYELBUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 21:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYELBUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 21:20:24 -0400
Received: from mail.fieldses.org ([66.93.2.214]:53381 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYELBUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 21:20:23 -0400
Date: Sun, 11 May 2008 21:20:22 -0400
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Tom Tucker <tom@opengridcomputing.com>
Subject: Re: [PATCH] net/sunrpc/xprtrdma: fix svc_rdma_create out of memory
	error path
Message-ID: <20080512012022.GA27353@fieldses.org>
References: <20080511200719.GM19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511200719.GM19058@joi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!  But I think Tom is just doing some final revisions on a patch
series that already includes this fix?

--b.

On Sun, May 11, 2008 at 10:07:25PM +0200, Marcin Slusarz wrote:
> ERR_PTR takes negative errno as a parameter
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Tom Tucker <tom@opengridcomputing.com>
> Cc: J. Bruce Fields <bfields@citi.umich.edu>
> ---
> compile tested only
> ---
>  net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> --- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
> @@ -661,7 +661,7 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
>  
>  	cma_xprt = rdma_create_xprt(serv, 1);
>  	if (!cma_xprt)
> -		return ERR_PTR(ENOMEM);
> +		return ERR_PTR(-ENOMEM);
>  	xprt = &cma_xprt->sc_xprt;
>  
>  	listen_id = rdma_create_id(rdma_listen_handler, cma_xprt, RDMA_PS_TCP);
> -- 
