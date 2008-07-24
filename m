Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbYGXJGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbYGXJGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYGXJGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:06:06 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:60488 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751302AbYGXJGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:06:05 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: mingo@elte.hu (Ingo Molnar)
Subject: Re: [TCP bug, regression] stuck distcc connections in latest -git
Cc: w@1wt.eu, davem@davemloft.net, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi
Organization: Core
In-Reply-To: <20080724060448.GA10203@elte.hu>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KLwlD-0001Ub-00@gondolin.me.apana.org.au>
Date: Thu, 24 Jul 2008 17:05:19 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:
>
> the client (running 2.6.24) does periodic 120 seconds retransmits:
> 
> 07:40:48.255452 IP dione.39201 > phoenix.distcc: . 1608:2144(536) ack 1 win 584007:40:48.255547 IP phoenix.distcc > dione.39201: . ack 2144 win 65535
> 07:40:48.255564 IP dione.39201 > phoenix.distcc: . 67143:67679(536) ack 1 win 5840
> 07:40:48.255648 IP phoenix.distcc > dione.39201: . ack 2144 win 65535
> 07:42:48.255440 IP dione.39201 > phoenix.distcc: . 2144:2680(536) ack 1 win 5840
> 07:42:48.255559 IP phoenix.distcc > dione.39201: . ack 2680 win 65535
> 07:42:48.255570 IP dione.39201 > phoenix.distcc: . 67679:68215(536) ack 1 win 5840
> 07:42:48.255659 IP phoenix.distcc > dione.39201: . ack 2680 win 65535
> 07:44:48.255436 IP dione.39201 > phoenix.distcc: . 2680:3216(536) ack 1 win 584007:44:48.255570 IP phoenix.distcc > dione.39201: . ack 3216 win 65535
> 07:44:48.255585 IP dione.39201 > phoenix.distcc: . 68215:68751(536) ack 1 win 5840
> 07:44:48.255669 IP phoenix.distcc > dione.39201: . ack 3216 win 65535

OK, something's seriously screwed up on dione's kernel.  Could
you please disable syncookies (which should enable SACK for you)
and see if the problem goes away?

I think our Reno code may have been broken.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
