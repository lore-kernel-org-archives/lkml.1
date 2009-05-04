Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbZEDUFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbZEDUFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZEDUFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:05:05 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43493 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZEDUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:05:03 -0400
Date: Mon, 4 May 2009 15:05:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utsns: extract creeate_uts_ns()
Message-ID: <20090504200501.GA29833@us.ibm.com>
References: <20090503232510.GA16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090503232510.GA16631@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> create_uts_ns() will be used by C/R to create fresh uts_ns.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

thanks,
-serge

> ---
>  kernel/utsname.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/utsname.c b/kernel/utsname.c
> index 815237a..8a82b4b 100644
> --- a/kernel/utsname.c
> +++ b/kernel/utsname.c
> @@ -15,6 +15,16 @@
>  #include <linux/err.h>
>  #include <linux/slab.h>
> 
> +static struct uts_namespace *create_uts_ns(void)
> +{
> +	struct uts_namespace *uts_ns;
> +
> +	uts_ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);
> +	if (uts_ns)
> +		kref_init(&uts_ns->kref);
> +	return uts_ns;
> +}
> +
>  /*
>   * Clone a new ns copying an original utsname, setting refcount to 1
>   * @old_ns: namespace to clone
> @@ -24,14 +34,13 @@ static struct uts_namespace *clone_uts_ns(struct uts_namespace *old_ns)
>  {
>  	struct uts_namespace *ns;
> 
> -	ns = kmalloc(sizeof(struct uts_namespace), GFP_KERNEL);
> +	ns = create_uts_ns();
>  	if (!ns)
>  		return ERR_PTR(-ENOMEM);
> 
>  	down_read(&uts_sem);
>  	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
>  	up_read(&uts_sem);
> -	kref_init(&ns->kref);
>  	return ns;
>  }
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
