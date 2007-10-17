Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbXJQFwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbXJQFwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXJQFwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:52:08 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2462 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750769AbXJQFwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:52:07 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: npiggin@suse.de (Nick Piggin)
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
Cc: mikulas@artax.karlin.mff.cuni.cz, arjan@infradead.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Organization: Core
In-Reply-To: <20071016002229.GA5851@wotan.suse.de>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Ii1oL-0005I3-00@gondolin.me.apana.org.au>
Date: Wed, 17 Oct 2007 13:51:17 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:
>
> Also, for non-wb memory. I don't think the Intel document referenced
> says anything about this, but the AMD document says that loads can pass
> loads (page 8, rule b).
> 
> This is why our rmb() is still an lfence.

BTW, Xen (in particular, the code in drivers/xen) uses mb/rmb/wmb
instead of smp_mb/smp_rmb/smp_wmb when it accesses memory that's
shared with other Xen domains or the hypervisor.

The reason this is necessary is because even if a Xen domain is
UP the hypervisor might be SMP.

It would be nice if we can have these adopt the new SMP barriers
on x86 instead of the IO ones as they currently do.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
