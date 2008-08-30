Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbYH3MbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbYH3MbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 08:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbYH3Max
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 08:30:53 -0400
Received: from mx.sz.bfs.de ([194.94.69.70]:33606 "EHLO mx.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbYH3Maw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 08:30:52 -0400
X-Greylist: delayed 1597 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Aug 2008 08:30:52 EDT
Message-ID: <48B93730.2020409@bfs.de>
Date: Sat, 30 Aug 2008 14:04:00 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Fix build warning in kernel/auditsc.c
References: <48b93353.02e2660a.0e28.3e54@mx.google.com>
In-Reply-To: <48b93353.02e2660a.0e28.3e54@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nice catch

I have only an older version here, in that n is constant.
maybe you can do a s/n/ctx->major/g ?
removing the need for the whole variable ?!

re,
  wh


Hannes Eder schrieb:
> Fix this:
> 
> kernel/auditsc.c: In function 'audit_match_perm':
> kernel/auditsc.c:249: warning: ISO C90 forbids mixed declarations and code
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  kernel/auditsc.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 972f8e6..e72b161 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -243,10 +243,12 @@ static inline int open_arg(int flags, int mask)
>  
>  static int audit_match_perm(struct audit_context *ctx, int mask)
>  {
> +	unsigned n;
> +
>  	if (unlikely(!ctx))
>  		return 0;
>  
> -	unsigned n = ctx->major;
> +	n = ctx->major;
>  	switch (audit_classify_syscall(ctx->arch, n)) {
>  	case 0:	/* native */
>  		if ((mask & AUDIT_PERM_WRITE) &&
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
