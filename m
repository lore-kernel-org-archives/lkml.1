Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbXLSLui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbXLSLui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 06:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbXLSLu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 06:50:28 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3215 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752486AbXLSLu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 06:50:27 -0500
Date: Wed, 19 Dec 2007 19:50:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: Inline local_bh_disable when TRACE_IRQFLAGS
Message-ID: <20071219115019.GA9099@gondor.apana.org.au>
References: <20071219034033.GA5770@gondor.apana.org.au> <20071219113152.GD20736@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219113152.GD20736@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 12:31:52PM +0100, Ingo Molnar wrote:
>
> > So I'm wondering if it would be reasonable to make it out-of-line when 
> > TRACE_IRQFLAGS is off.  This may make a difference because the 
> > networking stack is a frequent user of local_bh_disable and 
> > local_bh_enable.
> 
> do you mean to make it inline again?

Yes I meant in-line :)

> (btw., generally i think local_bh_disable() is a poor API because it is 
> opaque about the data structure dependency that it governs. Explicit 
> exclusion rules generally work better.)

I see where you're coming from especially with your preemptible
softirq work.  However I'm mostly thinking about the existing
callers of local_bh_disable in the networking stack.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
