Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbXLDWip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbXLDWip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbXLDWig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:38:36 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:4340 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751380AbXLDWif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:38:35 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: joonwpark81@gmail.com (Joonwoo Park)
Subject: Re: NET: ASSERT_RTNL in __dev_set_promiscuity makes debug warning
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <000001c8365a$e0e500c0$9c94fea9@jason>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IzgPL-0006HB-00@gondolin.me.apana.org.au>
Date: Wed, 05 Dec 2007 09:38:27 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonwoo Park <joonwpark81@gmail.com> wrote:
> Hi,
> dev_set_rx_mode calls __dev_set_rx_mode with softirq disabled (by netif_tx_lock_bh)
> therefore __dev_set_promiscuity can be called with softirq disabled.
> It will cause in_interrupt() to return true and ASSERT_RTNL warning.
> Is there a good solution to fix it besides blowing ASSERT_RTNL up?

We've talked this one before on netdev.  It's on my todo list to fix.
The correct solution is to untangle this so that __dev_set_promiscuity
does not get called in the first place on BH paths.

Unfortunately I've been busy so I haven't completed the patches yet.
But as this problem is not urgent let's not just put on a bandaid.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
