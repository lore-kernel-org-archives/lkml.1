Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbZCPQN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbZCPQN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbZCPQNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:13:01 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:42585 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbZCPQNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:13:00 -0400
Date: Mon, 16 Mar 2009 12:12:44 -0400
From: Woody Suwalski <woodys@xandros.com>
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org
Message-ID: <49BE7A7C.9070307@xandros.com>
In-Reply-To: <20090315112438.79f40526@infradead.org>
References: <20090315112345.764fc4ac@infradead.org>
References: <20090315112438.79f40526@infradead.org>
Subject: Re: [PATCH] async: remove the temporary (2.6.29) "async is off by default" code
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> From bfcfecd5ccfaa76011d8eba8f6c8ed486d57e0ab Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 15 Mar 2009 11:11:44 -0700
> Subject: [PATCH] async: remove the temporary (2.6.29) "async is off by default" code
>
> Now that everyone has been able to test the async code (and it's being used
> in the Moblin betas by default), we can enable it by default.
> The various fixes needed have gone into 2.6.29 already.
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  kernel/async.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/async.c b/kernel/async.c
> index f565891..247ab12 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -391,16 +391,8 @@ static int __init async_init(void)
>  		if (IS_ERR(kthread_run(async_manager_thread, NULL,
>  				       "async/mgr")))
>  			async_enabled = 0;
> -	return 0;
> -}
> -
> -static int __init setup_async(char *str)
> -{
>  	async_enabled = 1;
> -	return 1;
> +	return 0;
>  }
>  
> -__setup("fastboot", setup_async);
> -
> -
>  core_initcall(async_init);
>   
Arjan, when I try this one - kernel will not boot. I see it initializing 
the touchpad and then wait for ever.
If I pass fastboot on cmdline - it works OK. Any ideas?

Thanks, Woody


-- 
Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414

