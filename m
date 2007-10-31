Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXJaEI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXJaEI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbXJaEIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:08:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48795
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbXJaEIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:08:47 -0400
Date: Tue, 30 Oct 2007 21:08:46 -0700 (PDT)
Message-Id: <20071030.210846.215166155.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_key: suppress a warning for 64k pages.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071031145954.fe106f73.sfr@canb.auug.org.au>
References: <20071031145954.fe106f73.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 31 Oct 2007 14:59:54 +1100

> On PowerPC allmodconfig build we get this:
> 
> net/key/af_key.c:400: warning: comparison is always false due to limited range of data type
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
...
>  
> +	/* sadb_x_ctx_len is uint16_t */
> +#if PAGE_SIZE < (1 << 16)
>  	if (sec_ctx->sadb_x_ctx_len > PAGE_SIZE)
>  		return -EINVAL;
> +#endif
>  
>  	len = pfkey_sec_ctx_len(sec_ctx);
>  

I'm not so sure ifdef'ing things up all over the place is the way to
solve this.  It makes the code ultra ugly.

I think we should retain the check, but modify it so that GCC knows we
understand that it's OK if it is always false.  Perhaps a simple (u32)
cast on the left branch of the comparison is sufficient?
