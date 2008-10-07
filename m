Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYJGJZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYJGJZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 05:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYJGJZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 05:25:03 -0400
Received: from smtp27.orange.fr ([80.12.242.94]:54771 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbYJGJZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 05:25:00 -0400
X-ME-UUID: 20081007092457836.CC2091C0009A@mwinf2701.orange.fr
Message-ID: <48EB2AE3.3080200@cosmosbay.com>
Date: Tue, 07 Oct 2008 11:24:51 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: minyard@acm.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, shemminger@vyatta.com,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <20081006185026.GA10383@minyard.local>	 <48EA8197.6080502@cosmosbay.com> <1223367480.26330.7.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1223367480.26330.7.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra a écrit :
> On Mon, 2008-10-06 at 23:22 +0200, Eric Dumazet wrote:
> 
>> Or just add SLAB_DESTROY_BY_RCU to slab creation in proto_register()
>> for "struct proto udp_prot/udpv6_prot" so that kmem_cache_free() 
>> done in sk_prot_free() can defer freeing to RCU...
> 
> Be careful!, SLAB_DESTROY_BY_RCU just means the slab page gets
> RCU-freed, this means that slab object pointers stay pointing to valid
> memory, but it does _NOT_ mean those slab objects themselves remain
> valid.
> 
> The slab allocator is free to re-use those objects at any time -
> irrespective of the rcu-grace period. Therefore you will have to be able
> to validate that the object you point to is indeed the object you
> expect, otherwise strange and wonderful things will happen.
> 
Thanks for this clarification. I guess we really need a rcu head then :)



