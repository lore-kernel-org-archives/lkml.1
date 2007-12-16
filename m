Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbXLPL5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbXLPL5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763556AbXLPL5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:57:06 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1645 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757031AbXLPL5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:57:05 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: akpm@linux-foundation.org (Andrew Morton)
Subject: Re: oops with 2.6.23.1, marvel, software raid, reiserfs and samba
Cc: jeff@jeffunit.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@davemloft.net
Organization: Core
In-Reply-To: <20071216030516.1562a5d0.akpm@linux-foundation.org>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1J3s76-000166-00@gondolin.me.apana.org.au>
Date: Sun, 16 Dec 2007 19:56:56 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> Dec  7 17:20:53 sata_fileserver kernel: Code: 6c 39 df 74 59 8d b6 00 
>> 00 00 00 85 db 74 4f 8b 55 cc 8d 43 20 8b 0a 3b 48 18 0f 88 f4 05 00 
>> 00 89 ce 2b 70 18 8b 83 90 00 00 00 <0f> b6 50 0d 89 d0 83 e0 02 3c 
>> 01 8b 43 50 83 d6 ff 39 c6 0f 82

This means that skb->network_header == NULL so this line crashes:

	if (tcp_hdr(skb)->syn)
		offset--;

> That's a networking crash.  Do the oops traces which you're getting all look
> like this one?

What's spooky is that I just did a google and we've had reports
since 1998 all crashing on exactly the same line in tcp_recvmsg.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
