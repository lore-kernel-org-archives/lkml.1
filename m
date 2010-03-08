Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab0CHTNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:13:25 -0500
Received: from server109c.appriver.com ([72.32.253.87]:1293 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753576Ab0CHTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:13:19 -0500
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G179 G180 G181 G182 G186 G187 G198 G285 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Message-ID: <4B954CCE.8080902@intcomgrp.com>
Date: Mon, 08 Mar 2010 14:15:26 -0500
From: James Kosin <jkosin@intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Security: key: keyring: fix code style issues
References: <elPIC-7L6-15@gated-at.bofh.it>
In-Reply-To: <elPIC-7L6-15@gated-at.bofh.it>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2010 19:15:26.0876 (UTC) FILETIME=[B5BB45C0:01CABEF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See below my comments,

James Kosin

On 3/8/2010 1:20 PM, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues like to include <linux/uaccess.h> instead
> <asm/uaccess.h> and to remove some innecessary braces.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>
> ---
>  security/keys/keyring.c |   11 ++++-------
>  1 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/security/keys/keyring.c b/security/keys/keyring.c
> index e814d21..5a44965 100644
> --- a/security/keys/keyring.c
> +++ b/security/keys/keyring.c
> @@ -17,7 +17,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/err.h>
>  #include <keys/keyring-type.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>  #include "internal.h"
>  
>  /*
> @@ -170,12 +170,10 @@ static void keyring_describe(const struct key *keyring, struct seq_file *m)
>  {
>  	struct keyring_list *klist;
>  
> -	if (keyring->description) {
> +	if (keyring->description)
>  		seq_puts(m, keyring->description);
> -	}
> -	else {
> +	else
>  		seq_puts(m, "[anon]");
> -	}

I'm just going to put my 2-cents in here.

a)  removing the braces doesn't change the functionality here; HOWEVER,
b)  it may introduce a serious BUG later.

The main reason is some people don't look carefully at code and often
add statements inside an if else block ...  and if not caught will
change the meaning of the statements and the order of execution.  The
worst possible case is if the else {} block is matchable to another if
statement above this... then the compiler never complains about the else
without an if test.

I'm okay with changing this to be like below with the {} matching and in
the same format if you like.

>  
>  	rcu_read_lock();
>  	klist = rcu_dereference(keyring->payload.subscriptions);
> @@ -775,8 +773,7 @@ int __key_link(struct key *keyring, struct key *key)
>  		smp_wmb();
>  		klist->nkeys++;
>  		smp_wmb();
> -	}
> -	else {
> +	} else {
>  		/* grow the key list */
>  		max = 4;
>  		if (klist)

