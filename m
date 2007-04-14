Return-Path: <linux-kernel-owner+w=401wt.eu-S1161039AbXDNGAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039AbXDNGAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 02:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965407AbXDNGAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 02:00:40 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1495 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964974AbXDNGAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 02:00:39 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
Cc: kaber@trash.net, poemann@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, paulus@samba.org
Organization: Core
In-Reply-To: <20070413.161635.26523891.davem@davemloft.net>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HcbIy-0006Pt-00@gondolin.me.apana.org.au>
Date: Sat, 14 Apr 2007 16:00:12 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>
>> It seems we fail to reserve enough headroom for the case
>> buf[0] == PPP_ALLSTATIONS and buf[1] != PPP_UI.
>> 
>> Can you try this patch please?
> 
> Any confirmation of this fix yet?

FWIW the fix definitely looks correct (the bug has been there for
years at least) and it does match the crash dump.  In fact, there
is only a single skb_push (the only thing that can generate an under
panic) in ppp_async.c and this is the one that Patrick has fixed.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
