Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYLGQD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYLGQD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 11:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYLGQDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 11:03:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:38888 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYLGQDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 11:03:19 -0500
Message-ID: <ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
Date: Sun, 7 Dec 2008 17:03:17 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: Runaway loop with the current git.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, zbr@ioremap.net,
       linux-kernel@vger.kernel.org,
       "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
In-Reply-To: <20081207155507.GA15355@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	 <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	 <20081207155507.GA15355@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2008 at 16:55, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sun, Dec 07, 2008 at 10:49:27PM +0800, Herbert Xu wrote:
>>
>> In any case the loop itself does not involve any crypto components
>> so I don't think making changes in the crypto layer is going to
>> make this go away forever as anyone calling request_module early
>> enough will get into this loop.
>
> Having said that I think this patch should remove this particular
> trigger.  Unfortunately I couldn't find a more succinct way of
> expressing this relationship: if ALGAPI is built-in because it's
> selected by an algorithm, and CRYPTO_MANAGER is enabled then we
> require CRYPTO_MANAGER to be built-in as well.
>
> Evgeniy, please let me know whether this fixes the problem.

Even when this works around it, the problem that the kernel triggers
module loading on /dev/console access stays and needs to be fixed
instead.

It's a pure kernel bug, regardless of how many times Alan likes to
establish non-sensical hotplug rules to prevent this. The next
innocent driver change, like yours is, will run into the same problem.

Thanks,
Kay
