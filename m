Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbXLOG35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbXLOG35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXLOG3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:29:45 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2673 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753192AbXLOG3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:29:44 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ranma+kernel@tdiedrich.de (Tobias Diedrich)
Subject: Re: dst cache overflow
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com
Organization: Core
In-Reply-To: <20071214172945.GA10809@yamamaya.is-a-geek.org>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.net
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J3QWn-0006sJ-00@gondolin.me.apana.org.au>
Date: Sat, 15 Dec 2007 14:29:37 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:
>
> Meanwhile I added a slab statistic rrd script. Nothing obvious to
> see on ari or yumi yet, but on oni (which after all is the most
> affected by this) I can see 'size_2048' and 'TCPv6' growing
> steadily along with the route cache size (Presumably 'ip_dst_cache',
> which is also growing larger at a more or less constant rate).

OK that almost certainly means that we have a leak of TCPv6
objects which would then cause a leak of dst objects.

So you need to track down why TCPv6 isn't getting cleaned up.
First check the obvious, do you have any process(es) that are
hoarding TCPv6 sockets?

If not do you see a growing list of dead sockets in netstat?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
