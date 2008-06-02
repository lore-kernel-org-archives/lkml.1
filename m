Return-Path: <linux-kernel-owner+w=401wt.eu-S1761807AbYFBOJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761807AbYFBOJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbYFBOJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:09:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:36595 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753928AbYFBOJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:09:10 -0400
Date: Tue, 3 Jun 2008 00:08:55 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: johnpol@2ka.mipt.ru, ray-lk@madrabbit.org, mingo@elte.hu,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080602140855.GA25944@gondor.apana.org.au>
References: <E1K33OH-0005QX-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0806021442450.16829@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0806021442450.16829@wrl-59.cs.helsinki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 02:53:09PM +0300, Ilpo Järvinen wrote:
>
> Shouldn't that be already visible in the ingo's sysrq-t dump, no? There:
> 
>   http://marc.info/?l=linux-kernel&m=121182099131520&w=2

No, we need an actual strace rather than the static stack back-trace.
So start with netstat -lntp to locate the process listening on that
port, and then strace it to see if it's calling accept.

> There are many sys_accepts at least (if I understand that dump at all). 
> There were some ip_local_outs there as well, which made me wonder if the 
> totally innocent looking commit 1ac06e0306d0192a7a4d9ea1c9e06d355ce7e7d3 
> (ipsec: Use the correct ip_local_out function) has something to do with 
> this (I definately don't understand that part at all).

This patch only has an effect for IPsec.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
