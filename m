Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYFYXiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYFYXiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYFYXiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:38:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35095 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756775AbYFYXiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:38:21 -0400
Date: Wed, 25 Jun 2008 16:37:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: yamamoto@valinux.co.jp, menage@google.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [1/2] memrlimit handle attach_task() failure, add can_attach()
 callback
Message-Id: <20080625163753.6039c46b.akpm@linux-foundation.org>
In-Reply-To: <20080620150142.16094.48612.sendpatchset@localhost.localdomain>
References: <20080620150132.16094.29151.sendpatchset@localhost.localdomain>
	<20080620150142.16094.48612.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008 20:31:42 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> +/*
> + * Add the value val to the resource counter and check if we are
> + * still under the limit.
> + */
> +static inline bool res_counter_add_check(struct res_counter *cnt,
> +						unsigned long val)
> +{
> +	bool ret = false;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&cnt->lock, flags);
> +	if (cnt->usage + val <= cnt->limit)
> +		ret = true;
> +	spin_unlock_irqrestore(&cnt->lock, flags);
> +	return ret;
> +}

The comment and the function name imply that thins function will "Add
the value val to the resource counter".  But it doesn't do that at all.
In fact the first arg could be a `const struct res_counter *'.

Perhaps res_counter_can_add() would be more accurate.
