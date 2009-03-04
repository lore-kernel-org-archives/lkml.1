Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZCDPQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZCDPQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 10:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbZCDPQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 10:16:43 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47347 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752026AbZCDPQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 10:16:42 -0500
Date: Wed, 4 Mar 2009 10:06:17 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/6] slub: introduce __kfree_rcu
In-Reply-To: <49AD343E.6010903@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0903041003200.3850@qirst.com>
References: <49AD343E.6010903@cn.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Lai Jiangshan wrote:

> +
> +void __kfree_rcu(const void *x, struct rcu_head *rcu)
> +{
> +	call_rcu(rcu, kfree_rcu_callback);
> +}
> +EXPORT_SYMBOL(__kfree_rcu);
> +

The parameter x is unused why require it? I see that SLOB needs it. Cant
you do a similar trick as in SLUB just calculating the start address of
the object from the rcu address?

