Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZAGMXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZAGMXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZAGMWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:22:49 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:59074 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751094AbZAGMWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:22:48 -0500
Date: Wed, 7 Jan 2009 23:22:38 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107122238.GB25673@gondor.apana.org.au>
References: <20081224152841.GB13113@1wt.eu> <20090106183223.GA11964@ioremap.net> <20090106183704.GC32491@kernel.dk> <20090107044232.GA22218@gondor.apana.org.au> <20090107112906.GA28161@ioremap.net> <20090107115032.GA25198@gondor.apana.org.au> <20090107115605.GA29250@ioremap.net> <20090107115921.GA25323@gondor.apana.org.au> <20090107121530.GA30164@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107121530.GA30164@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 03:15:30PM +0300, Evgeniy Polyakov wrote:
> 
> Looks like we are talking about different directions of the dataflow.
> I meant that set of pages submitted into the sending part will be copied
> if sending interface does not support acceleration, and thus it will
> copy part of the page corresponding to the linear part of the skb prior
> the transmission, so even if skb will be freed right after that call
> (prior data transmission by the hardware), it should not affect copied
> data.

You must be looking at a different tcp.c than the one I've got
because mine clearly always uses skb frags in sendpage regardless
of SG support.

Yes we will linearize the packet in dev_queue_xmit but as soon
as the netdev stops the tx queue you'll get corruption.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
