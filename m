Return-Path: <linux-kernel-owner+w=401wt.eu-S1031524AbXEHUDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031524AbXEHUDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031953AbXEHUDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:03:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:43537 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031942AbXEHUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ForRpThMUg/n5y5Ptit/KxEq6rai+I4wASCUc5f9K1QT1mcjpuSUUNtZwf+7DR5gDJsESgEgvCNIs2CfY3b5fMdFcNX2NojYc7GTUMA6ePhZlD6DXXAiZ/DB4YYwdS++g8mf5nwoSDvDGvh8u3Fp4Tq9qqq7Kn4A5IDW4Av4kz4=
Date: Wed, 9 May 2007 00:03:19 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Type cast some size_t arguments to 'unsigned int' to avoid (harmless) gcc printk warnings.
Message-ID: <20070508200319.GA7035@martell.zuzino.mipt.ru>
References: <20070508185142.9ED501827261@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508185142.9ED501827261@tuatara.stupidest.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 11:29:26AM -0700, Chris Wedgwood wrote:
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

For one, size_t should be printed with %zu.
For two, this is already fixed in mainline.

