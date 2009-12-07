Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbZLGPCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbZLGPCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 10:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932595AbZLGPCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 10:02:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbZLGPCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 10:02:23 -0500
Subject: Re: [PATCH 5/5] security/selinux/ss: correct size computation
From: Eric Paris <eparis@redhat.com>
To: Julia Lawall <julia@diku.dk>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0912061016310.20858@ask.diku.dk>
References: <Pine.LNX.4.64.0912061016310.20858@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 10:02:23 -0500
Message-Id: <1260198143.13226.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-06 at 10:16 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The size argument to kcalloc should be the size of desired structure,
> not the pointer to it.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @expression@
> expression *x;
> @@
> 
> x =
>  <+...
> -sizeof(x)
> +sizeof(*x)
> ...+>// </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Eric Paris <eparis@redhat.com>

no real hurry, to get this in, the sizeof() is the same in either case,
but it should be fixed.


> 
> ---
>  security/selinux/ss/services.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -u -p a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -2555,7 +2555,7 @@ int security_get_classes(char ***classes
>  	read_lock(&policy_rwlock);
>  
>  	*nclasses = policydb.p_classes.nprim;
> -	*classes = kcalloc(*nclasses, sizeof(*classes), GFP_ATOMIC);
> +	*classes = kcalloc(*nclasses, sizeof(**classes), GFP_ATOMIC);
>  	if (!*classes)
>  		goto out;
>  
> @@ -2602,7 +2602,7 @@ int security_get_permissions(char *class
>  	}
>  
>  	*nperms = match->permissions.nprim;
> -	*perms = kcalloc(*nperms, sizeof(*perms), GFP_ATOMIC);
> +	*perms = kcalloc(*nperms, sizeof(**perms), GFP_ATOMIC);
>  	if (!*perms)
>  		goto out;
>  


