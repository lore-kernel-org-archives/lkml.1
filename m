Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYLGOtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYLGOtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 09:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYLGOtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 09:49:42 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:33708 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753403AbYLGOtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 09:49:42 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: alan@lxorguk.ukuu.org.uk (Alan Cox)
Subject: Re: Runaway loop with the current git.
Cc: kay.sievers@vrfy.org, zbr@ioremap.net, linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
Date: Sun, 07 Dec 2008 22:49:27 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> This modprobe process does try to log an error, accesses /dev/console,
>> which is not initialized in the kernel at that time, and the kernel
>> module loader tries the load a module to support dev_t 5:1, which
>> again runs modprobe, and ...
> 
> So we have a buggy modprobe... 

FWIW the crypto layer is doing what is intended.  The algorithm
testing infrastructure in the cryptomgr module is optional and
only used when algorithms are registered.  That's why it sits
in its own module which is loaded by the algorithm registration
code which still functions if the module is absent or fails to
load.

In any case the loop itself does not involve any crypto components
so I don't think making changes in the crypto layer is going to
make this go away forever as anyone calling request_module early
enough will get into this loop.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
