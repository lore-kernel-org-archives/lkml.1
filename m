Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZCEBVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZCEBVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZCEBVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:21:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZCEBVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:21:35 -0500
Message-ID: <49AF28C4.1000300@cn.fujitsu.com>
Date: Thu, 05 Mar 2009 09:20:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/6] slub: introduce __kfree_rcu
References: <49AD343E.6010903@cn.fujitsu.com> <alpine.DEB.1.10.0903041003200.3850@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0903041003200.3850@qirst.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 3 Mar 2009, Lai Jiangshan wrote:
> 
>> +
>> +void __kfree_rcu(const void *x, struct rcu_head *rcu)
>> +{
>> +	call_rcu(rcu, kfree_rcu_callback);
>> +}
>> +EXPORT_SYMBOL(__kfree_rcu);
>> +
> 
> The parameter x is unused why require it? I see that SLOB needs it. Cant
> you do a similar trick as in SLUB just calculating the start address of
> the object from the rcu address?
> 


The first parameter of __kfree_rcu() is unused in slab,slub,slqb.
(I used it before, for CONFIG_SLUB_DEBUG=y ...etc. But I found
these debugging code is needless)

Object sizes of the memory objects in slob's kmalloc-slab are various.
We hardly calculate the start address of the object from the rcu address.

Lai


