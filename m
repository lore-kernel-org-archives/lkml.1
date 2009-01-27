Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZA0HOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZA0HOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZA0HNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:13:54 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:39449 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751879AbZA0HNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:13:53 -0500
Date: Tue, 27 Jan 2009 18:11:30 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, zbr@ioremap.net, w@1wt.eu, dada1@cosmosbay.com,
       ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH v3] tcp: splice as many packets as possible at once
Message-ID: <20090127071130.GA29125@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090125.212203.15909648.davem@davemloft.net>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Thu, 22 Jan 2009 09:04:42 +0000
> 
>> It seems this sk_sndmsg_page usage (refcounting) isn't consistent.
>> I used here tcp_sndmsg() way, but I think I'll go back to this question
>> soon.
> 
> Indeed, it is something to look into, as well as locking.
> 
> I'll try to find some time for this, thanks Jarek.

After a quick look it seems to be OK to me.  The code in the patch
is called from tcp_splice_read, which holds the socket lock.  So as
long as the patch uses the usual TCP convention it should work.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
