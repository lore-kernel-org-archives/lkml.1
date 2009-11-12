Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbZKLIQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbZKLIQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZKLIQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:16:14 -0500
Received: from tundra.namei.org ([65.99.196.166]:56986 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZKLIQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:16:13 -0500
Date: Thu, 12 Nov 2009 19:16:14 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Julia Lawall <julia@diku.dk>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
In-Reply-To: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
Message-ID: <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org>
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> As observed by Joe Perches, sizeof of a constant string includes the
> trailing 0.  If what is wanted is to check the initial characters of
> another string, this trailing 0 should not be taken into account.  If an
> exact match is wanted, strcmp should be used instead.

> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -448,7 +448,7 @@ static int sb_finish_set_opts(struct sup
>  		sbsec->flags &= ~SE_SBLABELSUPP;
>  
>  	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
> -	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
> +	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs") - 1) == 0)
>  		sbsec->flags |= SE_SBLABELSUPP;

Shouldn't this be a simple strcmp() ?


-- 
James Morris
<jmorris@namei.org>
