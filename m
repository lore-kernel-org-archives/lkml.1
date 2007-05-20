Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbXETFMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbXETFMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 01:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbXETFML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 01:12:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4016 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758050AbXETFMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 01:12:10 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: davem@davemloft.net (David Miller)
Subject: Re: [PATCH] improved locking performance in rt_run_flush()
Cc: djohnson+linux-kernel@sw.starentnetworks.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Organization: Core
In-Reply-To: <20070514.030412.104035740.davem@davemloft.net>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Hpdhs-00069a-00@gondolin.me.apana.org.au>
Date: Sun, 20 May 2007 15:11:48 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
>> 
>> The below patch changes rt_run_flush() to only take each spinlock
>> protecting the rt_hash_table once instead of taking a spinlock for
>> every hash table bucket (and ending up taking the same small set 
>> of locks over and over).

...

> I'm not ignoring it I'm just trying to brainstorm whether there
> is a better way to resolve this inefficiency. :-)

The main problem I see with this is having to walk and free each
chain with the lock held.  We could avoid this if we had a pointer
in struct rtable to chain them up for freeing later.

I just checked and struct rtable is 236 bytes long on 32-bit but
the slab cache pads it to 256 bytes so we've got some free space.
I suspect 64-bit should be similar.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
