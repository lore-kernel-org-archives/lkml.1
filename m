Return-Path: <linux-kernel-owner+w=401wt.eu-S1760917AbYHFUNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917AbYHFUNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYHFUNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:13:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51655 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYHFUNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:13:36 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5355"; a="5371535"
Message-ID: <489A05EF.7000108@qualcomm.com>
Date: Wed, 06 Aug 2008 13:13:35 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: pj@sgi.com, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset : Handling improper memory allocation.
References: <b9df5fa10808061022r34e3a009k5060c8fab06bcd5c@mail.gmail.com>
In-Reply-To: <b9df5fa10808061022r34e3a009k5060c8fab06bcd5c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakib Mullick wrote:
> This patch makes sure that , if kmalloc fails in
> "rebuild_sched_domains", then we've a place to go. If anything else,
> please let me know.
> 

partition_sched_domains() can deal with attrs==NULL case. So we do not
have to abort domain building.

Max


> Thanks.
> 
> Signed-off-by: Md.Rakib H. Mullick (rakib.mullick@gmail.com)
> 
> --- linux-2.6.27-rc2.orig/kernel/cpuset.c	2008-08-06 16:23:26.000000000 +0600
> +++ linux-2.6.27-rc2/kernel/cpuset.c	2008-08-06 23:07:59.504441992 +0600
> @@ -615,7 +615,8 @@ void rebuild_sched_domains(void)
>  		if (dattr) {
>  			*dattr = SD_ATTR_INIT;
>  			update_domain_attr_tree(dattr, &top_cpuset);
> -		}
> +		} else
> +			goto rebuild;
>  		*doms = top_cpuset.cpus_allowed;
>  		goto rebuild;
>  	}
> @@ -685,6 +686,8 @@ restart:
>  	if (!doms)
>  		goto rebuild;
>  	dattr = kmalloc(ndoms * sizeof(struct sched_domain_attr), GFP_KERNEL);
> +	if (!dattr)
> +		goto rebuild;
> 
>  	for (nslot = 0, i = 0; i < csn; i++) {
>  		struct cpuset *a = csa[i];
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

