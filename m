Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZAGMSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZAGMSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:18:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZAGMSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:18:09 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:59059 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755453AbZAGMSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:18:07 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: akpm@linux-foundation.org (Andrew Morton)
Subject: Re: Deadlock after info soft-safe -> soft-unsafe lock order detected
Cc: zdenek.kabelac@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, dada1@cosmosbay.com
Organization: Core
In-Reply-To: <20090105201811.00242be7.akpm@linux-foundation.org>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1LKXMF-0006fe-DK@gondolin.me.apana.org.au>
Date: Wed, 07 Jan 2009 23:17:59 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> I'd be suspecting the percpu counter work in TCP?

This is the bogus lockdep output which is fixed by

commit ea319518ba3de282c13ae1cf4bf2215c5e03e67e
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Dec 26 15:08:55 2008 +0100

    locking, percpu counters: introduce separate lock classes
    
    Impact: fix lockdep false positives
    
    Classify percpu_counter instances similar to regular lock objects --
    that is, per instantiation site.
    
    The networking code has increased its use of percpu_counters, which
    leads to false positives if they are treated as a single class.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

It was only pulled very recently despite the Dec 26 date.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
