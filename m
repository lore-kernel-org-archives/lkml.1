Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYBJWXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYBJWXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 17:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbYBJWXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 17:23:09 -0500
Received: from mail.fieldses.org ([66.93.2.214]:45963 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbYBJWXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 17:23:08 -0500
Date: Sun, 10 Feb 2008 17:23:04 -0500
To: Roland Dreier <rdreier@cisco.com>
Cc: Tom Tucker <tom@opengridcomputing.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SUNPRC: Fix printk format warning
Message-ID: <20080210222304.GA20829@fieldses.org>
References: <aday79v0zgj.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aday79v0zgj.fsf@cisco.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 04:02:04PM -0800, Roland Dreier wrote:
> net/sunrpc/xprtrdma/svc_rdma_sendto.c:160: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'

OK, thanks.  Applied (with the long line split).

--b.

> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> index 3e32194..4b913e7 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> @@ -159,7 +159,7 @@ static int send_write(struct svcxprt_rdma *xprt, struct svc_rqst *rqstp,
>  	BUG_ON(sge_count >= 32);
>  	dprintk("svcrdma: RDMA_WRITE rmr=%x, to=%llx, xdr_off=%d, "
>  		"write_len=%d, xdr_sge=%p, sge_count=%d\n",
> -		rmr, to, xdr_off, write_len, xdr_sge, sge_count);
> +		rmr, (unsigned long long) to, xdr_off, write_len, xdr_sge, sge_count);
>  
>  	ctxt = svc_rdma_get_context(xprt);
>  	ctxt->count = 0;
