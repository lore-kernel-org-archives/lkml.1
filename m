Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbYGXHy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbYGXHy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYGXHys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:54:48 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:38370 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751082AbYGXHys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:54:48 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: mingo@elte.hu (Ingo Molnar)
Subject: Re: [TCP bug, regression] stuck distcc connections in latest -git
Cc: w@1wt.eu, davem@davemloft.net, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl
Organization: Core
In-Reply-To: <20080724063242.GA9051@elte.hu>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KLvds-0001Mc-00@gondolin.me.apana.org.au>
Date: Thu, 24 Jul 2008 15:53:40 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:
> 
> here's a longer log from the server, with sequences, flags, etc:

Sorry but which is the server, phoenix?

> 08:28:48.029057 IP (tos 0x0, ttl 64, id 27412, offset 0, flags [DF], proto TCP (6), length 40) phoenix.distcc > dione.39201: ., cksum 0x8316 (correct), 2272574194:2272574194(0) ack 234561256 win 65535
> 08:30:48.049167 IP (tos 0x0, ttl 64, id 14022, offset 0, flags [DF], proto TCP (6), length 576) dione.39201 > phoenix.distcc: . 234561256:234561792(536) ack 2272574194 win 5840
> 08:30:48.049223 IP (tos 0x0, ttl 64, id 27413, offset 0, flags [DF], proto TCP (6), length 40) phoenix.distcc > dione.39201: ., cksum 0x80fe (correct), 2272574194:2272574194(0) ack 234561792 win 65535
> 08:30:48.049341 IP (tos 0x0, ttl 64, id 14023, offset 0, flags [DF], proto TCP (6), length 576) dione.39201 > phoenix.distcc: . 234626648:234627184(536) ack 2272574194 win 5840
> 08:30:48.049348 IP (tos 0x0, ttl 64, id 14024, offset 0, flags [DF], proto TCP (6), length 183) dione.39201 > phoenix.distcc: . 234627184:234627327(143) ack 2272574194 win 5840
> 08:30:48.049354 IP (tos 0x0, ttl 64, id 27414, offset 0, flags [DF], proto TCP (6), length 40) phoenix.distcc > dione.39201: ., cksum 0x80fe (correct), 2272574194:2272574194(0) ack 234561792 win 65535
> 08:30:48.049359 IP (tos 0x0, ttl 64, id 27415, offset 0, flags [DF], proto TCP (6), length 40) phoenix.distcc > dione.39201: ., cksum 0x80fe (correct), 2272574194:2272574194(0) ack 234561792 win 65535

No further traffic is generated for this connection?

For a problem like this, you really need to dump on both sides
to get the full picture.  Otherwise it's difficult to tell why
we have a gap after 234561792 which is never filled in by dione.

BTW any reason why you appear to have SACK off?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
