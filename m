Return-Path: <linux-kernel-owner+w=401wt.eu-S1763405AbYBMChN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763405AbYBMChN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYBMChB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:37:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbYBMChA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:37:00 -0500
Date: Tue, 12 Feb 2008 18:35:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 3/4] fib_trie: print statistics for multiple tables
Message-Id: <20080212183521.2c19e2a0.akpm@linux-foundation.org>
In-Reply-To: <20080213005122.805195833@vyatta.com>
References: <20080213005042.150212716@vyatta.com>
	<20080213005122.805195833@vyatta.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 16:50:45 -0800 Stephen Hemminger <shemminger@vyatta.com> wrote:

> +/**
> + * hlist_for_each_entry_continue_rcu - iterate over rcu hlist after current point
> + * @tpos:	the type * to use as a loop cursor.
> + * @pos:	the &struct hlist_node to use as a loop cursor.
> + * @member:	the name of the hlist_node within the struct.
> + */
> +#define hlist_for_each_entry_continue_rcu(tpos, pos, member)		\
> +	for (pos = (pos)->next;						\
> +	     rcu_dereference(pos) && ({ prefetch(pos->next); 1;}) &&	\
> +		     ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
> +	     pos = pos->next)

Is the compiler allowed to look at a term such as

	({ prefetch(pos->next); 1;})

and, when it is used as a truth value, say "hey, that's always true" and
then elide the call to prefetch()?  We've no way of telling because this
remains gcc-specific territory, afaik.

(cc Paul for rcu stuff)
