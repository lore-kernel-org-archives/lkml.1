Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbXJZKsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbXJZKsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXJZKsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:48:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45173
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbXJZKsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:48:15 -0400
Date: Fri, 26 Oct 2007 03:48:16 -0700 (PDT)
Message-Id: <20071026.034816.178511694.davem@davemloft.net>
To: 12o3l@tiscali.nl
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/?] Unlock when sn_oemdata can't be extended
From: David Miller <davem@davemloft.net>
In-Reply-To: <471F1C48.1000803@tiscali.nl>
References: <471E9322.1030408@tiscali.nl>
	<471F1C48.1000803@tiscali.nl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <12o3l@tiscali.nl>
Date: Wed, 24 Oct 2007 12:19:52 +0200

>      Several unlocking issues
>      Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Some of these are wrong, for example:

> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index 817169e..b09c499 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -282,8 +282,10 @@ find_inlist_lock_noload(struct list_head *head, const char *name, int *error,
>  		return NULL;
>  
>  	list_for_each_entry(e, head, list) {
> -		if (strcmp(e->name, name) == 0)
> +		if (strcmp(e->name, name) == 0) {
> +			mutex_unlock(mutex);
>  			return e;
> +		}
>  	}
>  	*error = -ENOENT;
>  	mutex_unlock(mutex);

Please look at the comment right about this function, it clearly
explains that if the named object is found, the function returns
with the mutex locked.

The rest of the networking cases look OK, please just resubmit
the correct networking cases to netdev@vger.kernel.org.

Thanks.
