Return-Path: <linux-kernel-owner+w=401wt.eu-S966254AbXJSFiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966254AbXJSFiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 01:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbXJSFiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 01:38:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35161
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756026AbXJSFiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 01:38:07 -0400
Date: Thu, 18 Oct 2007 22:38:20 -0700 (PDT)
Message-Id: <20071018.223820.49264165.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: benh@kernel.crashing.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       netdev@vger.kernel.org
Subject: Re: [NET]: Fix possible dev_deactivate race condition
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071019053624.GA10560@gondor.apana.org.au>
References: <alpine.LFD.0.999.0710182007170.26902@woody.linux-foundation.org>
	<20071019042025.GA9617@gondor.apana.org.au>
	<20071019053624.GA10560@gondor.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 19 Oct 2007 13:36:24 +0800

> [NET]: Fix possible dev_deactivate race condition
> 
> The function dev_deactivate is supposed to only return when
> all outstanding transmissions have completed.  Unfortunately
> it is possible for store operations in the driver's transmit
> function to only become visible after dev_deactivate returns.
> 
> This patch fixes this by taking the queue lock after we see
> the end of the queue run.  This ensures that all effects of
> any previous transmit calls are visible.
> 
> If however we detect that there is another queue run occuring,
> then we'll warn about it because this should never happen as
> we have pointed dev->qdisc to noop_qdisc within the same queue
> lock earlier in the functino.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks Herbert!
