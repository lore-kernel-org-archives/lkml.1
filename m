Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZLWGxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZLWGxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 01:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZLWGxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 01:53:50 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:40919 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752124AbZLWGxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 01:53:50 -0500
Date: Wed, 23 Dec 2009 14:52:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, "David S. Miller" <davem@davemloft.net>,
       Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: workqueue thing
Message-ID: <20091223065240.GA27225@gondor.apana.org.au>
References: <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org> <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org> <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org> <1261480220.4937.24.camel@laptop> <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain> <1261504042.4937.59.camel@laptop> <4B31907C.7070408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B31907C.7070408@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 12:37:32PM +0900, Tejun Heo wrote:
> 
> I wrote this before but if something is burning CPU cycles using MT
> workqueues, this can be easily supported by marking such workqueue as
> not concurrency-managed.  ie. Works queued for such workqueues
> wouldn't contribute to the perceived workqueue concurrency and will be
> left to be managed solely by the scheduler.  This will completely
> cover the crypto_wq case which uses MT workqueue with local cpu
> binding.

Right, the main use of workqueues in the crypto subsystem currently
is to perform operations in a process context, e.g., in order to
use SSE instructions on x86, so there is no real parallelism
involved.

However, Steffen Klassert has proposed a parallelisation mechanism
whereby extremely CPU-intensive operations such as encryption may
be split across CPUs.  Steffen, could you repost your padata patches
here?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
