Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZIBTRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZIBTRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 15:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZIBTRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 15:17:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:34173 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZIBTRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 15:17:49 -0400
Subject: Re: tree rcu: call_rcu scalability problem?
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Paul McKenney <paulmck@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090902122756.GC12251@wotan.suse.de>
References: <20090902094835.GB12251@wotan.suse.de>
	 <20090902122756.GC12251@wotan.suse.de>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 21:17:44 +0200
Message-Id: <1251919064.10394.25.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-02 at 14:27 +0200, Nick Piggin wrote:

> It seems like nearly 2/3 of the cost is here:
>         /* Add the callback to our list. */
>         *rdp->nxttail[RCU_NEXT_TAIL] = head; <<<
>         rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
> 
> In loading the pointer to the next tail pointer. If I'm reading the profile
> correctly. Can't see why that should be a probem though...
> 
> ffffffff8107dee0 <__call_rcu>: /* __call_rcu total: 320971 100.000 */
>    697  0.2172 :ffffffff8107dee0:       push   %r12

>    921  0.2869 :ffffffff8107df57:       push   %rdx
>    151  0.0470 :ffffffff8107df58:       popfq
> 183507 57.1725 :ffffffff8107df59:       mov    0x50(%rbx),%rax
>    995  0.3100 :ffffffff8107df5d:       mov    %rdi,(%rax)

I'd guess at popfq to be the expensive op here.. skid usually causes the
attribution to be a few ops down the line.

