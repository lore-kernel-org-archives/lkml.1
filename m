Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbZATKbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbZATKbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760465AbZATKbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:31:21 -0500
Received: from broadrack.ru ([195.178.208.66]:44430 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760291AbZATKbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:31:19 -0500
Date: Tue, 20 Jan 2009 13:31:22 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090120103122.GC9167@ioremap.net>
References: <20090114.012919.117682429.davem@davemloft.net> <20090115230331.GB1123@1wt.eu> <20090115231934.GA8328@gondor.apana.org.au> <20090115.152608.89323697.davem@davemloft.net> <20090120083726.GA13806@ff.dom.local> <20090120093352.GB13806@ff.dom.local> <20090120100043.GA9167@ioremap.net> <20090120102053.GA17004@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120102053.GA17004@ff.dom.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 10:20:53AM +0000, Jarek Poplawski (jarkao2@gmail.com) wrote:
> Good question! Alas I can't check this soon, but if it's really like
> this, of course this needs some better idea and rework. (BTW, I'd like
> to prevent here as much as possible some strange activities like 1
> byte (payload) packets getting full pages without any accounting.)

I believe approach to meet all our goals is to have own network memory
allocator, so that each skb could have its payload in the fragments, we
would not suffer from the heavy fragmentation and power-of-two overhead
for the larger MTUs, have a reserve for the OOM condition and generally
do not depend on the main system behaviour.

I will resurrect to some point my network allocator to check how things
go in the modern environment, if no one will beat this idea first :)

1. Network (tree) allocator
http://www.ioremap.net/projects/nta

-- 
	Evgeniy Polyakov
