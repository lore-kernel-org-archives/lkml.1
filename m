Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYLDB5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYLDB5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYLDB5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:57:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56574 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYLDB5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:57:42 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] - support inheritance of mlocks across fork/exec V2
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       hugh@veritas.com
In-Reply-To: <1228331069.6693.73.camel@lts-notebook>
References: <20081125152651.b4c3c18f.akpm@linux-foundation.org> <1228331069.6693.73.camel@lts-notebook>
Message-Id: <20081204105527.1D5F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  4 Dec 2008 10:57:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -600,9 +603,15 @@ asmlinkage long sys_mlockall(int flags)
>  	unsigned long lock_limit;
>  	int ret = -EINVAL;
>  
> -	if (!flags || (flags & ~(MCL_CURRENT | MCL_FUTURE)))
> +	if (!(flags & (MCL_CURRENT | MCL_FUTURE)))
>  		goto out;
>  
> +	if (flags & ~(MCL_CURRENT | MCL_FUTURE | MCL_INHERIT | MCL_RECURSIVE))
> +		goto out;	/* undefined flag bits */
> +
> +	if ((flags & (MCL_INHERIT | MCL_RECURSIVE)) == MCL_RECURSIVE)
> +		goto out;	/* 'RECURSIVE undefined without 'INHERIT */
> +
>  	ret = -EPERM;
>  	if (!can_do_mlock())
>  		goto out;

looks good to me.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



