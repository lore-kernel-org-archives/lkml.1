Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbXKXCSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbXKXCSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 21:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbXKXCSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 21:18:42 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1029 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753296AbXKXCSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 21:18:41 -0500
Date: Sat, 24 Nov 2007 10:18:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dave Jones <davej@redhat.com>
Subject: Re: [bug] xfrm_state_lock: possible circular locking dependency detected
Message-ID: <20071124021814.GA24056@gondor.apana.org.au>
References: <20071123153851.GA26308@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071123153851.GA26308@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 04:38:51PM +0100, Ingo Molnar wrote:
> 
> DaveJ's Fedora 8 rpm for 2.6.24 works petty well, except for the 
> neworking related lockdep assert attached below, which happened while 
> starting up ipsec. Let me know if you need any more info - it's a pretty 
> stock setup.

Thanks for the report Ingo!

This is indeed a regression caused by:

commit 050f009e16f908932070313c1745d09dc69fd62b
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Oct 9 13:31:47 2007 -0700

    [IPSEC]: Lock state when copying non-atomic fields to user-space

For 2.6.24 I'm simply going to revert this change since that
just puts us back to the same state we've been for the last
few years.

For 2.6.25 I'll do a proper fix by making sure that every xfrm
state user obeys the rule that if x->lock is to be taken with
xfrm_state_lock then it must be done from within.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
