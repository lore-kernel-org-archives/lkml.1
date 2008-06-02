Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYFBCPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYFBCPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 22:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYFBCPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 22:15:42 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:47669 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753568AbYFBCPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 22:15:41 -0400
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, menage@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [RFC][PATCH 1/2] memcg: res_counter hierarchy
In-Reply-To: Your message of "Fri, 30 May 2008 10:45:15 +0900"
	<20080530104515.9afefdbb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080530104515.9afefdbb.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Cue version 0.8 (080521-1813/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080602021540.5C6705A0D@siro.lan>
Date: Mon,  2 Jun 2008 11:15:40 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -135,13 +138,118 @@ ssize_t res_counter_write(struct res_cou
>  		if (*end != '\0')
>  			goto out_free;
>  	}
> -	spin_lock_irqsave(&counter->lock, flags);
> -	val = res_counter_member(counter, member);
> -	*val = tmp;
> -	spin_unlock_irqrestore(&counter->lock, flags);
> -	ret = nbytes;
> +	if (member != RES_LIMIT || !callback) {

is there any reason to check member != RES_LIMIT here,
rather than in callers?

> +/*
> + * Move resource to its parent.
> + *   child->limit -= val.
> + *   parent->usage -= val.
> + *   parent->limit -= val.

s/limit/for_children/

> + */
> +
> +int res_counter_repay_resource(struct res_counter *child,
> +				struct res_counter *parent,
> +				unsigned long long val,
> +				res_shrink_callback_t callback, int retry)

can you reduce gratuitous differences between
res_counter_borrow_resource and res_counter_repay_resource?
eg. 'success' vs 'done', how to decrement 'retry'.

YAMAMOTO Takashi
