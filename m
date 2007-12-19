Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbXLSDkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbXLSDkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 22:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXLSDkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 22:40:40 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2868 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751535AbXLSDkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 22:40:40 -0500
Date: Wed, 19 Dec 2007 11:40:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Inline local_bh_disable when TRACE_IRQFLAGS
Message-ID: <20071219034033.GA5770@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo:

I noticed that local_bh_disable is now always out-of-line.  The
change was made when TRACE_IRQFLAGS was added.  However, with
TRACE_IRQFLAGS off, local_bh_disable does exactly the same work
as before.  In particular, it does pretty much the same as what
preempt_disable does and the latter is always inline.

So I'm wondering if it would be reasonable to make it out-of-line
when TRACE_IRQFLAGS is off.  This may make a difference because
the networking stack is a frequent user of local_bh_disable and
local_bh_enable.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
