Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbZFJJot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbZFJJot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932075AbZFJJmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:42:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbZFJJmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:42:20 -0400
Date: Wed, 10 Jun 2009 05:42:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 3/5] tracing/events: modify irq print to new format
Message-ID: <20090610094218.GB14860@infradead.org>
References: <20090609014534.790466803@goodmis.org> <20090609014746.709245674@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609014746.709245674@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 09:45:37PM -0400, Steven Rostedt wrote:
> -#define softirq_name(sirq) { sirq##_SOFTIRQ, #sirq }
> -#define show_softirq_name(val)			\
> -	__print_symbolic(val,			\
> -			 softirq_name(HI),	\
> -			 softirq_name(TIMER),	\
> -			 softirq_name(NET_TX),	\
> -			 softirq_name(NET_RX),	\
> -			 softirq_name(BLOCK),	\
> -			 softirq_name(TASKLET),	\
> -			 softirq_name(SCHED),	\
> -			 softirq_name(HRTIMER),	\
> -			 softirq_name(RCU))
> +#define softirq_name(sirq) sirq##_SOFTIRQ, #sirq
> +#define show_softirq_name(val)						\
> +	"%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s>",	\
> +		softirq_name(HI),					\
> +		softirq_name(TIMER),					\
> +		softirq_name(NET_TX),					\
> +		softirq_name(NET_RX),					\
> +		softirq_name(BLOCK),					\
> +		softirq_name(TASKLET),					\
> +		softirq_name(SCHED),					\
> +		softirq_name(HRTIMER),					\
> +		softirq_name(RCU)

This is a massive readability and maintainabilit  regression over the
old code.  I now need to add a useless and counter-intuitive %d=%s,
boilerplate for every new flag I add instead ofa simple line-line
array entry.

Also why does show_softirq_name get a val argument passed that's never
used?  And no, I don't think
%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s,%d=%s is an intuitive
way to print an enum.

