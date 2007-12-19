Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbXLSLcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbXLSLcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 06:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbXLSLcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 06:32:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55721 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbXLSLcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 06:32:13 -0500
Date: Wed, 19 Dec 2007 12:31:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: Inline local_bh_disable when TRACE_IRQFLAGS
Message-ID: <20071219113152.GD20736@elte.hu>
References: <20071219034033.GA5770@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219034033.GA5770@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Hi Ingo:
> 
> I noticed that local_bh_disable is now always out-of-line.  The change 
> was made when TRACE_IRQFLAGS was added.  However, with TRACE_IRQFLAGS 
> off, local_bh_disable does exactly the same work as before.  In 
> particular, it does pretty much the same as what preempt_disable does 
> and the latter is always inline.
> 
> So I'm wondering if it would be reasonable to make it out-of-line when 
> TRACE_IRQFLAGS is off.  This may make a difference because the 
> networking stack is a frequent user of local_bh_disable and 
> local_bh_enable.

do you mean to make it inline again?

(btw., generally i think local_bh_disable() is a poor API because it is 
opaque about the data structure dependency that it governs. Explicit 
exclusion rules generally work better.)

	Ingo
