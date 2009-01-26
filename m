Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZAZVV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZAZVV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZAZVVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:21:45 -0500
Received: from corega.com.ru ([195.178.208.66]:60768 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbZAZVVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:21:44 -0500
Date: Tue, 27 Jan 2009 00:21:30 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090126212130.GA4338@ioremap.net>
References: <20090120103122.GC9167@ioremap.net> <20090126082036.GB4183@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126082036.GB4183@ff.dom.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarek.

On Mon, Jan 26, 2009 at 08:20:36AM +0000, Jarek Poplawski (jarkao2@gmail.com) wrote:
> > 1. Network (tree) allocator
> > http://www.ioremap.net/projects/nta
> 
> I looked at this a bit, but alas I didn't find much for this Herbert's
> idea of payload in fragments/pages. Maybe some kind of API RFC is
> needed before this resurrection?

Basic idea is to steal some (probably a lot) pages from the slab
allocator and put network buffers there without strict need for
power-of-two alignment and possible wraps when we add skb_shared_info at
the end, so that old e1000 driver required order-4 allocations for the
jumbo frames. We can do that in alloc_skb() and friends and put returned
buffers into skb's fraglist and updated reference counters for those
pages; and with additional copy of the network headers into skb->head.

-- 
	Evgeniy Polyakov
