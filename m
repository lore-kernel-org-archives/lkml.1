Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZAGMnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZAGMnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZAGMm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:42:56 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:46036 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751938AbZAGMmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:42:55 -0500
Date: Wed, 7 Jan 2009 23:42:46 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107124246.GA26034@gondor.apana.org.au>
References: <20090106183223.GA11964@ioremap.net> <20090106183704.GC32491@kernel.dk> <20090107044232.GA22218@gondor.apana.org.au> <20090107112906.GA28161@ioremap.net> <20090107115032.GA25198@gondor.apana.org.au> <20090107115605.GA29250@ioremap.net> <20090107115921.GA25323@gondor.apana.org.au> <20090107121530.GA30164@ioremap.net> <20090107122238.GB25673@gondor.apana.org.au> <20090107123741.GA31255@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107123741.GA31255@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 03:37:41PM +0300, Evgeniy Polyakov wrote:
>
> Doesn't your tcp fallbacks to kernel_sendmsg() without sg in
> tcp_sendpage()? And then just feeds data into the stack the same way it
> happens with send() i.e. by copying it.

Good point.  Did he check GSO though? GSO will always enable SG
on the socket regardless of the netdev's setting.  And if the device
started out with SG enabled then recent kernels will enable GSO
by default.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
