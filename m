Return-Path: <linux-kernel-owner+w=401wt.eu-S1756448AbYLAAQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbYLAAQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYLAAQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:16:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40686 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbYLAAQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:16:26 -0500
Message-ID: <49332CC6.4080606@redhat.com>
Date: Mon, 01 Dec 2008 01:16:06 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
CC: device-mapper development <dm-devel@redhat.com>,
       Christophe Saout <christophe@saout.de>,
       LKML <linux-kernel@vger.kernel.org>, Herbert@redhat.com,
       linux-next@vger.kernel.org, linux-crypto@vger.kernel.org,
       Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] Re: next-20081125: crypto hard disk gets unaccessable
References: <20081128063355.GA4700@denkbrett.schottelius.org> <20081129192939.925275f0.akpm@linux-foundation.org>
In-Reply-To: <20081129192939.925275f0.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc's added)
> 
>> After about four suspend & resume operations in the midst of editing
>> a file, the system beeped twice and issued this error:

Did this work before? If so, please can you provide version where
it works?

It is suspend to encrypted swap?

There should not be any recent change in dm-crypt related to this path,
so I expect it is some bug related to suspend/resume in combination with
running crypto - like corruption of some memory caused during suspend...


> [lots of snippage]
>> [69186.618357] RIP: 0010:[<ffffffff8031f246>]  [<ffffffff8031f246>] crypto_xor+0x7/0x48

> [69186.618468]  [<ffffffffa027226a>] ? crypto_cbc_encrypt+0xfa/0x15a [cbc]
> [69186.618481]  [<ffffffffa0285705>] ? aes_encrypt+0x0/0x7 [aes_x86_64]
> [69186.618494]  [<ffffffffa020667d>] ? async_encrypt+0x35/0x3a [crypto_blkcipher]
> [69186.618509]  [<ffffffffa0269a6f>] ? crypt_convert+0x1d2/0x253 [dm_crypt]
> [69186.618522]  [<ffffffffa0269ed6>] ? kcryptd_crypt+0x3e6/0x407 [dm_crypt]
> [69186.618533]  [<ffffffffa0269af0>] ? kcryptd_crypt+0x0/0x407 [dm_crypt]

I assume that crypto run here synchronously (not through asynchronous completion callback).

Herbert - is my guess ok? (The asynchronous handling in dm-crypt was the only part changed recently.)
(And I think that except crypto hw nobody uses asynchronous mode yet by default.)

Milan
--
mbroz@redhat.com

