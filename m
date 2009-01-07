Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZAGMPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZAGMPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZAGMPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:15:32 -0500
Received: from kandzendo.ru ([195.178.208.66]:42895 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZAGMPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:15:31 -0500
Date: Wed, 7 Jan 2009 15:15:30 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107121530.GA30164@ioremap.net>
References: <20081224152841.GB13113@1wt.eu> <20090106183223.GA11964@ioremap.net> <20090106183704.GC32491@kernel.dk> <20090107044232.GA22218@gondor.apana.org.au> <20090107112906.GA28161@ioremap.net> <20090107115032.GA25198@gondor.apana.org.au> <20090107115605.GA29250@ioremap.net> <20090107115921.GA25323@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107115921.GA25323@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 10:59:21PM +1100, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Wed, Jan 07, 2009 at 02:56:05PM +0300, Evgeniy Polyakov wrote:
> >
> > But it will not push pages into the stack, but copy them including copy
> > of the submitted head?
> 
> It will use a single page entry for skb->head with splice, see
> skb_splice_bits.

Looks like we are talking about different directions of the dataflow.
I meant that set of pages submitted into the sending part will be copied
if sending interface does not support acceleration, and thus it will
copy part of the page corresponding to the linear part of the skb prior
the transmission, so even if skb will be freed right after that call
(prior data transmission by the hardware), it should not affect copied
data.

-- 
	Evgeniy Polyakov
