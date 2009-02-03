Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZBCNG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZBCNG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbZBCNGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:06:18 -0500
Received: from tservice.ru ([195.178.208.66]:35941 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbZBCNGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:06:17 -0500
Date: Tue, 3 Feb 2009 16:06:06 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090203130606.GA25471@ioremap.net>
References: <20090202080855.GA4129@ff.dom.local> <20090202.001854.261399333.davem@davemloft.net> <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090203111012.GA16878@ioremap.net> <20090203123628.GB4639@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203123628.GB4639@ff.dom.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 12:36:28PM +0000, Jarek Poplawski (jarkao2@gmail.com) wrote:
> I understand NTA could be better than slabs in above-mentioned cases,
> but I'm not sure you explaind enough your point on solving this
> zero-copy problem vs. NTA?

NTA steals pages from the SLAB so we can maintain any reference counter
logic in them, so linear part of the skb may be not really freed/reused
until reference counter hits zero.

-- 
	Evgeniy Polyakov
