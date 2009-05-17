Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZEQNGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZEQNGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 09:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZEQNGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 09:06:08 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:39780 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZEQNGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 09:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mcyslK0fx7swOBw+J8cUAlMJ63aev0s3A7LCkFmpUaxPo4ti3lVQY4ynBEEHJbtQZ7
         VeLBOEHRv21ig/DjUQfVBpk/YqjS+LoqZJjMMDxCX+V88Y7Qj1Mdu7QPr2fornKRpZlQ
         26SB7xkIy+FPWJrlEwRLVz7AR3wRAXar4gRb4=
Date: Sun, 17 May 2009 15:06:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: tom.leiming@gmail.com
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] ftrace:fix check for return value of
	register_module_notifier
Message-ID: <20090517130601.GA4640@nowhere>
References: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242545498-7285-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 17, 2009 at 03:31:38PM +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> return zero should be correct, so fix it.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  kernel/trace/ftrace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5b606f4..140699a 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2826,7 +2826,7 @@ void __init ftrace_init(void)
>  				  __stop_mcount_loc);
>  
>  	ret = register_module_notifier(&ftrace_module_nb);
> -	if (!ret)
> +	if (ret)
>  		pr_warning("Failed to register trace ftrace module notifier\n");
>  
>  	return;


Indeed!

register_module_notifier returns blocking_notifier_chain_register():

 *
 *	Currently always returns zero.
 */
int blocking_notifier_chain_register(struct blocking_notifier_head *nh,
		struct notifier_block *n)

For now it will never return anything else than 0 but we can keep
the warning in case it changes one day, as you did.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

