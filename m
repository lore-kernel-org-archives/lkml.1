Return-Path: <linux-kernel-owner+w=401wt.eu-S969457AbXEIDmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969457AbXEIDmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965724AbXEIDmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:42:02 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60698 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbXEIDmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:42:01 -0400
Message-ID: <46414307.90504@zytor.com>
Date: Tue, 08 May 2007 20:41:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Wedgwood <cw@f00f.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Type cast some size_t arguments to 'unsigned int' to
 avoid (harmless) gcc printk warnings.
References: <20070508185142.9ED501827261@tuatara.stupidest.org>
In-Reply-To: <20070508185142.9ED501827261@tuatara.stupidest.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wedgwood wrote:
> Signed-off-by: Chris Wedgwood <cw@f00f.org>
> ---
>  net/sunrpc/sched.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
> index 4a53e94..60df3c1 100644
> --- a/net/sunrpc/sched.c
> +++ b/net/sunrpc/sched.c
> @@ -764,7 +764,7 @@ void *rpc_malloc(struct rpc_task *task, size_t size)
>  		buf = kmalloc(size, gfp);
>  	*buf = size;
>  	dprintk("RPC: %5u allocated buffer of size %u at %p\n",
> -			task->tk_pid, size, buf);
> +			task->tk_pid, (unsigned int)size, buf);
>  	return (void *) ++buf;
>  }
>  
> @@ -783,7 +783,7 @@ void rpc_free(void *buffer)
>  	buf--;
>  
>  	dprintk("RPC:       freeing buffer of size %u at %p\n",
> -			size, buf);
> +			(unsigned int)size, buf);
>  	if (size <= RPC_BUFFER_MAXSIZE)
>  		mempool_free(buf, rpc_buffer_mempool);
>  	else

NAK.  This is wrong for multiple reasons.
Use %zu instead.

	-hpa


