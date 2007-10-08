Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbXJHR3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbXJHR3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbXJHR3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:29:04 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29070 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbXJHR3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:29:02 -0400
Date: Mon, 8 Oct 2007 09:13:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: [PATCH] param_sysfs_builtin memchr argument fix
Message-Id: <20071008091354.30598ee4.randy.dunlap@oracle.com>
In-Reply-To: <20071008071730.GA2979@darkstar.te-china.tietoenator.com>
References: <20071008071730.GA2979@darkstar.te-china.tietoenator.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007 15:17:30 +0800 Dave Young wrote:

> Hi,
> Thanks for comment.
> fixed.
> 
> Regards
> dave
> -----
> 
> If memchr argument is longer than strlen(kp->name), there will be some
> weird result.

Just to clarify:  this was causing duplicate filenames in sysfs ?


> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> 
> ---
> kernel/params.c |    8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff -upr linux/kernel/params.c linux.new/kernel/params.c
> --- linux/kernel/params.c	2007-10-08 14:30:06.000000000 +0800
> +++ linux.new/kernel/params.c	2007-10-08 15:13:04.000000000 +0800
> @@ -592,11 +592,17 @@ static void __init param_sysfs_builtin(v
>  
>  	for (i=0; i < __stop___param - __start___param; i++) {
>  		char *dot;
> +		size_t kplen;
>  
>  		kp = &__start___param[i];
> +		kplen = strlen(kp->name);
>  
>  		/* We do not handle args without periods. */
> -		dot = memchr(kp->name, '.', MAX_KBUILD_MODNAME);
> +		if (kplen > MAX_KBUILD_MODNAME) {
> +			DEBUGP("kernel parameter %s is too long\n", kp->name);

how about
	kernel parameter name %s is too long
or
	kernel parameter name is too long: %s

(primary is addition of "name")

> +			continue;
> +		}
> +		dot = memchr(kp->name, '.', kplen);
>  		if (!dot) {
>  			DEBUGP("couldn't find period in %s\n", kp->name);
>  			continue;
> -


---
~Randy
