Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZFHL1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZFHL1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 07:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZFHL1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 07:27:38 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48429 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754315AbZFHL1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 07:27:38 -0400
Date: Mon, 8 Jun 2009 06:27:36 -0500
From: Robin Holt <holt@sgi.com>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, mingo@elte.hu,
       rusty@rustcorp.com.au, davem@davemloft.net
Subject: Re: [this_cpu_xx 04/11] Use this_cpu ops for network statistics
Message-ID: <20090608112736.GL29447@sgi.com>
References: <20090605191819.376530498@gentwo.org> <20090605191851.012334412@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605191851.012334412@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 03:18:23PM -0400, cl@linux-foundation.org wrote:
...
> --- linux-2.6.orig/include/net/netfilter/nf_conntrack.h	2009-06-03 16:23:29.000000000 -0500
...
>  #define NF_CT_STAT_INC_ATOMIC(net, count)		\
> -do {							\
> -	local_bh_disable();				\
> -	per_cpu_ptr((net)->ct.stat, raw_smp_processor_id())->count++;	\
> -	local_bh_enable();				\
> -} while (0)
> +	this_cpu_inc((net)->ct.stat->count)

Why not put this on one line?
#define NF_CT_STAT_INC_ATOMIC(net, count)  this_cpu_inc((net)->ct.stat->count)

obin
