Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727Ab0ANWmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab0ANWmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332Ab0ANWmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:42:44 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:45125 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756144Ab0ANWmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:42:42 -0500
Subject: Re: [PATCH] xprtsock.c: make bc_{malloc/free} static
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de,
       davem@davemloft.net
In-Reply-To: <201001141538.31496.hartleys@visionengravers.com>
References: <201001141538.31496.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 17:42:36 -0500
Message-ID: <1263508956.2724.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 12 msgs/h 4 sum rcpts/h 14 sum msgs/h 4 total rcpts 2239 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 96E1E6645AB3E0CADE27D566EE45FC91397281C5
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 4 total 102 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 15:38 -0700, H Hartley Sweeten wrote: 
> xprtsock.c: make bc_{malloc/free} static
> 
> The server backchannel buf_alloc and buf_free methods should
> be static since they are not used outside this file.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: J. Bruce Fields <bfields@fieldses.org>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Cc: David S. Miller <davem@davemloft.net>
> 
> ---
> 
> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
> index 3d739e5..721bafd 100644
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -2100,7 +2100,7 @@ static void xs_tcp_print_stats(struct rpc_xprt *xprt, struct seq_file *seq)
>   * we allocate pages instead doing a kmalloc like rpc_malloc is because we want
>   * to use the server side send routines.
>   */
> -void *bc_malloc(struct rpc_task *task, size_t size)
> +static void *bc_malloc(struct rpc_task *task, size_t size)
>  {
>  	struct page *page;
>  	struct rpc_buffer *buf;
> @@ -2120,7 +2120,7 @@ void *bc_malloc(struct rpc_task *task, size_t size)
>  /*
>   * Free the space allocated in the bc_alloc routine
>   */
> -void bc_free(void *buffer)
> +static void bc_free(void *buffer)
>  {
>  	struct rpc_buffer *buf;
>  

Thanks! I'll put this in the sunrpc-for-next branch.

Trond

