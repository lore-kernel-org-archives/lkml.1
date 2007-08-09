Return-Path: <linux-kernel-owner+w=401wt.eu-S937258AbXHIBFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937258AbXHIBFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 21:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbXHIBFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 21:05:21 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2072 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932591AbXHIBFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 21:05:20 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: csnook@redhat.com (Chris Snook)
Subject: Re: [PATCH] make atomic_t volatile on all architectures
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org
Organization: Core
In-Reply-To: <20070808230733.GA17270@shell.boston.redhat.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IIwQx-000468-00@gondolin.me.apana.org.au>
Date: Thu, 09 Aug 2007 09:03:27 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> wrote:
> 
> Some architectures currently do not declare the contents of an atomic_t to be
> volatile.  This causes confusion since atomic_read() might not actually read
> anything if an optimizing compiler re-uses a value stored in a register, which
> can break code that loops until something external changes the value of an
> atomic_t.  Avoiding such bugs requires using barrier(), which causes re-loads

Such loops should always use something like cpu_relax() which comes
with a barrier.

> of all registers used in the loop, thus hurting performance instead of helping
> it, particularly on architectures where it's unnecessary.  Since we generally

Do you have an example of such a loop where performance is hurt by this?

The IPVS code that led to this patch was simply broken and has been
fixed to use cpu_relax().

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
