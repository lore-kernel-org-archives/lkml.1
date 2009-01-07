Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbZAGNDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbZAGNDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbZAGNDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:03:04 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:34170 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919AbZAGNDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:03:01 -0500
Date: Wed, 7 Jan 2009 16:02:59 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Willy Tarreau <w@1wt.eu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107130259.GB32336@ioremap.net>
References: <20090107115032.GA25198@gondor.apana.org.au> <20090107115605.GA29250@ioremap.net> <20090107115921.GA25323@gondor.apana.org.au> <20090107121530.GA30164@ioremap.net> <20090107122238.GB25673@gondor.apana.org.au> <20090107123741.GA31255@ioremap.net> <20090107124246.GA26034@gondor.apana.org.au> <20090107124629.GA31732@ioremap.net> <20090107125535.GC6307@1wt.eu> <20090107125734.GA26331@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107125734.GA26331@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:57:34PM +1100, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Wed, Jan 07, 2009 at 01:55:35PM +0100, Willy Tarreau wrote:
> > 
> > kernel is 2.6.27.10 + a few patches (squashfs, etc..., nothing related to
> 
> 2.6.27 will enable GSO by default if SG is enabled at registration
> time.

So even if later sg was turned off without gso being turned off, it
will try doing fair page transfer and not falling back to the copy.

The simplest case is to also turn gso off, but with older ethtools it is
not possible and you hit the bug.

If I understood correctly Jarek's patch, he wants to allocate a page and
copy linear content of the skb there, so this will end up being the same
case as with splicing from the file. And while generally this may be a
good idea, but with usual 1.5k mtu this will copy every skb, which is
rather bad idea. Will have to think :)

-- 
	Evgeniy Polyakov
