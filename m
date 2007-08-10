Return-Path: <linux-kernel-owner+w=401wt.eu-S940863AbXHJULz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940863AbXHJULz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937760AbXHJULX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:11:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:51136 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648AbXHJULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:11:21 -0400
In-Reply-To: <E1IJPkg-0000x0-00@gondolin.me.apana.org.au>
References: <E1IJPkg-0000x0-00@gondolin.me.apana.org.au>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <442f95ba19f8622ce04cf0334f34be11@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: paulmck@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, horms@verge.net.au,
       linux-kernel@vger.kernel.org, csnook@redhat.com, rpjday@mindspring.com,
       netdev@vger.kernel.org, ak@suse.de, cfriesen@nortel.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org, zlynx@acm.org,
       schwidefsky@de.ibm.com, davem@davemloft.net, wensong@linux-vs.org,
       wjiang@resilience.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/24] make atomic_read() behave consistently on alpha
Date: Fri, 10 Aug 2007 22:07:27 +0200
To: Herbert Xu <herbert@gondor.apana.org.au>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> The compiler is within its rights to read a 32-bit quantity 16 bits at
>> at time, even on a 32-bit machine.  I would be glad to help pummel any
>> compiler writer that pulls such a dirty trick, but the C standard 
>> really
>> does permit this.
>
> Code all over the kernel assumes that 32-bit reads/writes
> are atomic so while such a compiler might be legal it certainly
> can't compile Linux.

That means GCC cannot compile Linux; it already optimises
some accesses to scalars to smaller accesses when it knows
it is allowed to.  Not often though, since it hardly ever
helps in the cost model it employs.


Segher

