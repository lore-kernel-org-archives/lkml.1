Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbZKJSQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbZKJSQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbZKJSQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:16:11 -0500
Received: from lo.gmane.org ([80.91.229.12]:35133 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbZKJSQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:16:10 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@collabora.co.uk>
Subject: Re: SM501: Fix missing uses of resource_size()
Date: Tue, 10 Nov 2009 13:15:36 -0500
Message-ID: <20091110131536.427b5caf@mycelium.queued.net>
References: <20091110171734.085189722@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Vincent Sanders <vince@simtec.co.uk>,
       Simtec Linux Team <linux@simtec.co.uk>, akpm@linux-foundation.org,
       krzysztof.h1@wp.pl, lethal@linux-sh.org
X-Gmane-NNTP-Posting-Host: wireless.queued.net
In-Reply-To: <20091110171734.085189722@fluff.org.uk>
X-Newsreader: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 17:17:34 +0000
Ben Dooks <ben@simtec.co.uk> wrote:

> There are several places in the SM501 fb driver that could do with
> using resource_size() to calculate the size of a resource.
> 

Yes, please!  Also, as Thiago suggested, please submit this inline.

[...]
> @@ -1363,7 +1363,7 @@ static int sm501fb_start(struct sm501fb_
>  	}
>  
>  	info->fbmem_res = request_mem_region(res->start,
> -					     (res->end -
> res->start)+1,
> +					     resource_size(res),
>  					     pdev->name);
>  	if (info->fbmem_res == NULL) {
>  		dev_err(dev, "cannot claim framebuffer\n");
> @@ -1377,7 +1377,7 @@ static int sm501fb_start(struct sm501fb_

Looks like you missed one here; the ioremap on line 1374 should also
use resource_size.


>  		goto err_mem_res;
>  	}
>  
> -	info->fbmem_len = (res->end - res->start)+1;
> +	info->fbmem_len = resource_size(res);
>  
>  	/* clear framebuffer memory - avoids garbage data on unused
> fb */ memset(info->fbmem, 0, info->fbmem_len);
> 


