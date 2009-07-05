Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbZGEQMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbZGEQMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZGEQM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:12:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:47639 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752059AbZGEQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:12:29 -0400
Date: Mon, 6 Jul 2009 00:11:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jeff@garzik.org>, andi@firstfloor.org, arjan@infradead.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       douglas.w.styner@intel.com, chinang.ma@intel.com,
       terry.o.prickett@intel.com, matthew.r.wilcox@intel.com,
       netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090705161151.GA11923@gondor.apana.org.au>
References: <4A4F1EA0.3070501@garzik.org> <20090705040137.GA7747@gondor.apana.org.au> <20090705130926.GS5480@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705130926.GS5480@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 07:09:26AM -0600, Matthew Wilcox wrote:
> 
> Maybe not one RX queue per socket -- sockets belonging to the same
> thread could share the same RX queue.  I'm fairly ignorant of the way
> networking works these days; is it possible to dynamically reassign a
> socket between RX queues, so we'd only need one RX queue per CPU?

Not reliably.  You can tweak the hash in the NIC to redirect
traffic (aka flow director) but ultimately if you've got more
sockets than queues then it's a losing game.

A better strategy for now is to pin everything down and try to
get user-space involved by using threads and distributing the
sockets based on which queue they're associated with.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
