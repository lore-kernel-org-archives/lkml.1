Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZGCL07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZGCL07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 07:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZGCL0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 07:26:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40695 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbZGCL0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 07:26:51 -0400
Date: Fri, 3 Jul 2009 13:26:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FRV: Implement atomic64_t
Message-ID: <20090703112642.GA14744@elte.hu>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com> <20090703111755.GA7161@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703111755.GA7161@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0115]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Good point. I've done a simple:
> 
> u64 atomic64_read(atomic64_t *ptr)
> {
>         return cmpxchg8b(ptr, 0, 0);
> }

-1 is better i guess, as that way we can avoid dirtying the 
cacheline. Zero is way too common for atomics.

	Ingo
